//
//  SearchView.swift
//  Dental Place
//
//  Created by eWeb on 12/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import SVProgressHUD

class SearchView: UIViewController,UITextFieldDelegate
{
    
    @IBOutlet weak var filterTable: UITableView!
    @IBOutlet weak var searchTxt: UITextField!
    
    var catData:CategoryModel?
    var allSearchArray = NSMutableArray()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchTxt.delegate=self
        
        filterTable.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
        filterTable.delegate = self
        filterTable.dataSource=self
        
        

    }
    override func viewWillAppear(_ animated: Bool)
    {
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            if textField.text?.count ?? 0>0
            {
                self.SerachAPI()
            }
           
        }
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            if textField.text?.count ?? 0>0
                       {
                           self.SerachAPI()
                       }
        }
        return true
    }
    @IBAction func FilterBtnAct(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
      // self.filterPopScreen.isHidden = false
    }

}
extension SearchView:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allSearchArray.count//self.catData?.data?.count ?? 0//3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
        cell.backView.backgroundColor=UIColor.clear
        cell.backgroundColor=UIColor.clear
        cell.catNameLbl.backgroundColor=UIColor.clear
        cell.lineView.backgroundColor=UIColor.lightGray
        
        let dict = self.allSearchArray.object(at: indexPath.row) as! NSDictionary
        
        cell.catNameLbl.textAlignment = .left
        //cell.catNameLbl.textColor = UIColor.black
        
        //cell.catNameLbl.text = dict.value(forKey: "user_name") as? String ?? ""
        
        let stringValue = dict.value(forKey: "title") as? String ?? ""
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
        attributedString.setColor(color: UIColor.black, forText: self.searchTxt.text!)
       // label.font = UIFont.systemFont(ofSize: 26)
        
        cell.catNameLbl.attributedText = attributedString
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        // cell.backgroundView = clearView
        
        
        let SearchView = self.storyboard?.instantiateViewController(withIdentifier: "ListMapTabViewController") as! ListMapTabViewController
       // let celldata = self.catData?.data?[indexPath.row]
        //let titl = celldata?.categoryName ?? "All"
        let dict=self.allSearchArray.object(at: indexPath.row) as! NSDictionary
        
               let id = dict.value(forKey: "id") as? Int ??  0
               let titl = dict.value(forKey: "title") as? String ??  "0"
           SearchView.searchId="\(id)"
           SearchView.searchedText=titl
               DEFAULT.set("0", forKey: "SELECTEDFILTER")
               DEFAULT.synchronize()
               DEFAULT.set("\(id)", forKey: "CategoryId")
               DEFAULT.set(titl, forKey: "CategoryName")
               DEFAULT.set(titl, forKey: "CategorySelected")
        //APPDEL.loadHomeView()
        self.navigationController?.pushViewController(SearchView, animated: true)
        
    }
    
      func SerachAPI()
       {
        SVProgressHUD.dismiss()
        
           
        let params = ["searchWord" : searchTxt.text!] as [String:String]
           
           
           var apiKey = "1234"
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
           print("sao vay sao ko search")
           ApiHandler.apiDataPostMethod(url: SERVICESSEARCHAPI, parameters: params, Header: header) { (response, error) in
            debugPrint("Rêefea", response)
            debugPrint("Rêefea", error)
               SVProgressHUD.dismiss()
               if error == nil
               {
                
                   print(response)
                   if let dict = response as? NSDictionary
                   {
                    SVProgressHUD.dismiss()
                    
                       if let dataArray = dict.value(forKey: "data") as? NSArray
                       {
                           
                           self.allSearchArray = dataArray.mutableCopy() as! NSMutableArray
                        
                        self.filterTable.reloadData()
                        
                       }
                       
                   }
                SVProgressHUD.dismiss()
                
               }
               else
               {
                SVProgressHUD.dismiss()
                   self.view.makeToast(error)
               }
           }
       }
    
    
    
}
extension NSMutableAttributedString {

    func setColor(color: UIColor, forText stringValue: String) {
       let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

}
