//
//  ThirdTab.swift
//  Dental Place
//
//  Created by eWeb on 13/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import SVProgressHUD

class ThirdTab: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var appointMentArray = NSMutableArray()
    var appointMentArray2 = NSMutableArray()
    @IBOutlet weak var myAppointmentTable: UITableView!
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var nodtaFoundLbl: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        chatTable.register(UINib(nibName: "chatTableCell", bundle: nil), forCellReuseIdentifier: "chatTableCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.ChatPageRefreshNoti), name: Notification.Name("ChatPageRefreshNoti"), object: nil)
    }
    
    @objc func ChatPageRefreshNoti()
    {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.selectedIndex = 2
    }
        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.nodtaFoundLbl.isHidden=true
        
        
        
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.GetAppointmentAPI()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.appointMentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatTableCell") as! chatTableCell
        
        let dict = self.appointMentArray.object(at: indexPath.row) as! NSDictionary
        cell.profileImg.layer.cornerRadius=cell.profileImg.frame.height/2
        cell.profileImg.clipsToBounds=true
        
        if let latestMessage = dict.value(forKey: "latestMessage") as? String
        {
           
            if latestMessage == ""
            {
                cell.messageLbl.textColor=UIColor.black
               cell.messageLbl.text  = "Appointment confirmed..."
                if let cofimedByClinicTime = dict.value(forKey: "cofimedByClinicTime") as? String
                {
                     cell.timeLbl.text  =  self.convertDateFormater4(dict.value(forKey: "cofimedByClinicTime") as? String ?? "")//cofimedByClinicTime
                }
                else{
                    cell.timeLbl.text  =  "10:40 AM"
                }
                
            }
            else
            {
                cell.messageLbl.text = latestMessage
                cell.messageLbl.textColor=APPTEXTLIGHTCOLOL
                 cell.timeLbl.text  =  self.convertDateFormater(dict.value(forKey: "messageTime") as? String ?? "")
            }
        }
        else
        {
          cell.messageLbl.textColor=UIColor.black
            cell.messageLbl.text  = "Appointment confirmed..."
            if let cofimedByClinicTime = dict.value(forKey: "cofimedByClinicTime") as? String
                           {
                                cell.timeLbl.text  = cofimedByClinicTime
                           }
                           else{
                               cell.timeLbl.text  =  "10:40 AM"
                           }
        }
        
        
        
       
       // cell.messageLbl.textColor = APPTEXTLIGHTCOLOL
        
        if let clilicDict = dict.value(forKey: "owner_data") as? NSDictionary
        {
            cell.titleLbl.text = clilicDict.value(forKey: "user_name") as? String ?? ""
            if let url2 = clilicDict.value(forKey: "profile_image") as? String
            {
                let fullurl =  url2
                
                print("Image full url \(fullurl)")
                let url = URL(string: fullurl)
                
                cell.profileImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
            }
            
        }
        
        //        if indexPath.row == 0
        //        {
        //
        //        }
        //        else
        //        {
        //            cell.messageLbl.textColor = APPTEXTLIGHTCOLOL
        //            cell.messageLbl.text = "Hello?"
        //        }
        //
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("You tapped cell number \(indexPath.section).")
        print("Cell cliked value is \(indexPath.row)")
        let new = self.storyboard?.instantiateViewController(withIdentifier: "ChatScreen") as! ChatScreen
        if let dict = self.appointMentArray.object(at: indexPath.row) as? NSDictionary
        {
            let confirmByUser = dict.value(forKey: "confirmByUser") as? String ?? "0"
            new.appointmentDate = self.convertDateFormater2(dict.value(forKey: "appoinment_date") as? String ?? "")
            new.appointmentTime = dict.value(forKey: "time") as? String ?? ""
            
            if let cofimedByClinicTime = dict.value(forKey: "cofimedByClinicTime") as? String
                           {
                            new.RequestTime  =  self.convertDateFormater4(dict.value(forKey: "cofimedByClinicTime") as? String ?? "")//cofimedByClinicTime
                           }
        
            
            if confirmByUser == "1"
            {
                new.hidePopUp = "1"
            }
            else
            {
                new.hidePopUp = "0"
            }
            new.servicesBooking_id=dict.value(forKey: "id") as? Int ?? 0
            new.clinicId=dict.value(forKey: "clinicId") as? String ?? "0"
            if let clilicDict = dict.value(forKey: "owner_data") as? NSDictionary
            {
                new.clinicName2 = clilicDict.value(forKey: "user_name") as? String ?? ""
                new.profileImage = clilicDict.value(forKey: "profile_image") as? String ?? ""
            }
            
            
            
            self.navigationController?.pushViewController(new, animated: true)
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 110
    }
    @IBAction func searchBtn(_ sender: UIButton)
    {
        
    }
    @IBAction func searchBtn2(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchView") as! SearchView
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func GetAppointmentAPI()
    {
        SVProgressHUD.show()
        
        
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
        
        ApiHandler.apiDataGetMethod2(url: GETBOOKAPPOINTMENTAPI, parameters: ["":""] , Header: header) { (response, error) in
            
            if error == nil
            {
                if let dict = response as? NSDictionary
                {
                    if let dataArray = dict.value(forKey: "data") as? NSArray
                    {
                        
                        if self.appointMentArray2.count>0
                        {
                            self.appointMentArray2.removeAllObjects()
                            
                        }
                        
                        self.appointMentArray2 = (dataArray.reversed() as! NSArray).mutableCopy() as! NSMutableArray
                        if self.appointMentArray.count>0
                        {
                            self.appointMentArray.removeAllObjects()
                            
                        }
                        for dict1 in self.appointMentArray2
                        {
                            let dict = dict1 as! NSDictionary
                            
                            let confirmByClinic = dict.value(forKey: "confirmByClinic") as? String ?? "0"
                            
                            //let confirmByUser = dict.value(forKey: "confirmByUser") as? String ?? "0"
                            
                            
                            if confirmByClinic == "1"
                            {
                                self.appointMentArray.add(dict)
                                
                            }
                            self.chatTable.reloadData()
                        }
                        
                    }
                    //                                          else
                    //                                          {
                    //                                            if self.appointMentArray.count>0
                    //                                            {
                    //                                                self.appointMentArray.removeAllObjects()
                    //                                            }
                    //                                        self.chatTable.reloadData()
                    //                                            //  self.notfoundView.isHidden=false
                    //                                        }
                    
                    if self.appointMentArray.count==0
                    {
                        self.nodtaFoundLbl.isHidden=false
                    }
                    else
                        
                    {
                        self.nodtaFoundLbl.isHidden=true
                        
                    }
                    
                    SVProgressHUD.dismiss()
                }
                else
                {
                    if self.appointMentArray.count>0
                    {
                        self.appointMentArray.removeAllObjects()
                    }
                    self.chatTable.reloadData()
                    SVProgressHUD.dismiss()
                    self.view.makeToast(error)
                }
            }
            else
            {
                if self.appointMentArray.count>0
                {
                    self.appointMentArray.removeAllObjects()
                }
                self.chatTable.reloadData()
                SVProgressHUD.dismiss()
                self.view.makeToast(error)
            }
        }
    }
    
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        //"2020-04-22 11:24:30"
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date2 = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "hh:mm a"
        if date2 != nil
        {
            return  dateFormatter.string(from: date2!)
        }
        else
        {
            return "10:31 AM"
        }
        
    }
    func convertDateFormater4(_ date: String) -> String
      {
          
        let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
           dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

           let date = dateFormatter.date(from: date)
           dateFormatter.timeZone = TimeZone.current
           dateFormatter.dateFormat = "hh:mm a"
        if date != nil
        {
            return dateFormatter.string(from: date!)
        }
        else
        {
            return "10:24 AM"
        }
      }
    
    func convertDateFormater2(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let date2 = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMMM d, yyyy"
        if date2 != nil
        {
            return  dateFormatter.string(from: date2!)
        }
        else
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            let date3 = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "MMMM d, yyyy"
            return  "June 06,2020" //dateFormatter.string(from: date3!)
        }
        
        //                    if date2 != nil
        //
        //                    {
        //                        return  dateFormatter.string(from: date2!)
        //                    }
        //                     else
        //                    {
        //                        let dateFormatter = DateFormatter()
        //                        dateFormatter.dateFormat = "MMMM d, yyyy"
        //                        let date = dateFormatter.date(from: date)
        //                        dateFormatter.dateFormat = "MMMM d, yyyy")
        //                         return  dateFormatter.string(from: date2!)
        //                    }
        
    }
}
