//
//  TimeTableViewController.swift
//  Dental Place
//
//  Created by AMARENDRA on 08/04/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class TimeTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    var delegate:AppoitnmentpopUpDataProtocol? = nil
    @IBOutlet weak var allcommentTable: UITableView!
var vendor_metaDict=NSDictionary()
    
    var from = ""
    var venderServiceArray=NSArray()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor
            .black.withAlphaComponent(0.5)
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        print("from = \(from)")
         allcommentTable.register(UINib(nibName: "TimeTableTableViewCell", bundle: nil), forCellReuseIdentifier: "TimeTableTableViewCell")
        
        
    }
    
    @IBAction func btn2Action(_ sender: UIButton)
    {
        //"Check Delegate nil"
        if(delegate != nil)
        {
            delegate?.inputData(data: sender.titleLabel?.text! ?? "yes")
            self.view.removeFromSuperview()
            
            
        }
    }
    
    @IBAction func btn1Action(_ sender: UIButton)
    {
        if from=="Send push notification"
        {
            delegate?.inputData(data: sender.titleLabel?.text! ?? "NO")
        }
        
        self.view.removeFromSuperview()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
                        
        if let openDict = vendor_metaDict.value(forKey: "open") as? NSDictionary
            {
            return openDict.allValues.count
            }
        else
        {
        return 0
        }
           
            
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeTableTableViewCell") as! TimeTableTableViewCell
        
        
                      
                      if let openDict = vendor_metaDict.value(forKey: "open") as? NSDictionary
                      {
                         
                        let Key = openDict.allKeys[indexPath.row] as? String ?? "Sun"
                         let openTime = openDict.value(forKey: Key) as! String
                        cell.title.text = Key+" : "
                if let closeDict = vendor_metaDict.value(forKey: "close") as? NSDictionary
                  {
                   let closeTime = closeDict.value(forKey: Key) as! String
                    
                    if closeTime.contains("00:00") || openTime.contains("00:00")
                    {
                        cell.priceLbl.textColor=UIColor.red
                        cell.priceLbl.text = "Closed"
                    }
                    else
                    
                    {
                        cell.priceLbl.textColor=APPCOLOL
                        cell.priceLbl.text = openTime+" - "+closeTime
                    }
                    }
                        else
                {
                    cell.priceLbl.textColor=UIColor.red
                    cell.priceLbl.text = "Closed"
                }
                }
        
        else
                {
                    cell.priceLbl.textColor=UIColor.red
                    cell.priceLbl.text = "Closed"
                }
        
        
        
        cell.bckView.backgroundColor = UIColor.clear
//        //UIColor.init(red: 231/255, green: 251/255, blue: 249/255, alpha: 1)
//        if indexPath.row == 0
//        {
//            cell.title.textColor = UIColor.black
//          //  cell.title.text = "Root Canal"
//            cell.title.font = UIFont(name: "FiraSans-Bold", size: 21)
//           // cell.priceLbl.text = "€100"
//            cell.bckView.backgroundColor = UIColor.init(red: 231/255, green: 251/255, blue: 249/255, alpha: 1)
//            cell.bckView.layer.borderWidth = 1
//            cell.bckView.layer.borderColor = APPCOLOL.cgColor
//        }
//        else
//        {
//            //cell.title.text = "Dental Implant"
//            //cell.priceLbl.text = "€550"
//            cell.bckView.backgroundColor = UIColor.white
//            cell.bckView.layer.borderWidth = 1
//            cell.bckView.layer.borderColor = UIColor.lightGray.cgColor
//        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
}

