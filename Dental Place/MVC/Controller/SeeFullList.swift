//
//  SeeFullList.swift
//  Dental Place
//
//  Created by eWeb on 14/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class SeeFullList: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    var catData:CategoryModel?

    //@IBOutlet weak var filterView: UIView!
 
    @IBOutlet weak var searchTable: UITableView!
    
 
    var array = ["General Checkup", "Root Canal", "Dental Implant",
                 "Tooth Fillings", "Dental Cleaning", "Extractions", "Dentures", "Gum Surgery"]
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.CatAPI()
        }


        searchTable.register(UINib(nibName: "SearchTableCell", bundle: nil), forCellReuseIdentifier: "SearchTableCell")
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
    }
    @IBAction func goback(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
return self.catData?.data?.count ?? 0//3
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableCell") as! SearchTableCell
        let celldata = self.catData?.data?[indexPath.row]
            let title = celldata?.categoryName
        cell.btn.setTitle(title, for: .normal)

        cell.btn.tag = indexPath.row
        cell.btn.addTarget(self, action: #selector(rateBtnAct(_:)), for: .touchUpInside)
        
        return cell
    }
    @objc func rateBtnAct(_ sender: UIButton)
    {
         let newView = self.storyboard?.instantiateViewController(withIdentifier: "ListMapTabViewController") as! ListMapTabViewController
        let celldata = self.catData?.data?[sender.tag]
                     let titl = celldata?.categoryName ?? "All"
                 
                            let id = celldata?.id ?? "All"
                             DEFAULT.set(id, forKey: "CategoryId")
                             DEFAULT.set(titl, forKey: "CategoryName")
                            DEFAULT.set(titl, forKey: "CategorySelected")
                            DEFAULT.synchronize()
        //APPDEL.loadHomeView()
              self.navigationController?.pushViewController(newView, animated: true)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print(indexPath.row)
        let newView = self.storyboard?.instantiateViewController(withIdentifier: "ListMapTabViewController") as! ListMapTabViewController
        let celldata = self.catData?.data?[indexPath.row]
               let titl = celldata?.categoryName ?? "All"
           
                      let id = celldata?.id ?? "All"
                       DEFAULT.set(id, forKey: "CategoryId")
                       DEFAULT.set(titl, forKey: "CategoryName")
                      DEFAULT.set(titl, forKey: "CategorySelected")
                      DEFAULT.synchronize()
        self.navigationController?.pushViewController(newView, animated: true)
    }
    @IBAction func FilterBtn(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        self.navigationController?.pushViewController(vc, animated: true)
      
    }
   @IBAction func searchBtn(_ sender: UIButton)
           {
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchView") as! SearchView
               self.navigationController?.pushViewController(vc, animated: true)
           }
    
    func CatAPI()
       {        var apiKey = "1234"
           if let newuserEmail1 = DEFAULT.value(forKey: "APITOKEN") as? String
           {
               apiKey = "\(newuserEmail1)"
           }
        var DEVICETOKEN = "123456"
           if let device = DEFAULT.value(forKey: "DEVICETOKEN") as? String
           {
               DEVICETOKEN = device
           }
           let header = ["device-id":DEVICETOKEN,"device-type":"iOS","type":"iOS","api-token":apiKey] as [String:String]
           
           ApiHandler.ModelApiGetMethod(url: CATAPI , Header: header) { (response, error) in
               
               if error == nil
               {
                   let decoder = JSONDecoder()
                   do
                   {
                       self.catData = try decoder.decode(CategoryModel.self, from: response!)
                       //self.view.makeToast(self.loginData?.message)
                       
                       
                       if self.catData?.code == "201"
                           
                       {
                          
                           self.searchTable.reloadData()
                       }
                       else
                       {
                           NetworkEngine.commonAlert(message: self.catData?.message ?? "", vc: self)
                       }
                       
                       
                   }
                   catch let error
                   {
                       self.view.makeToast(error.localizedDescription)
                       print(error)
                   }
                   
               }
               else
               {
                   self.view.makeToast(error)
               }
           }
       }
       
       
       
}
