//
//  ChatScreen.swift
//  Dental Place
//
//  Created by eWeb on 13/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import SVProgressHUD
import IQKeyboardManagerSwift

class ChatScreen: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var chatViewBottomConst: NSLayoutConstraint!
    
    @IBOutlet weak var clinicName: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var clinicName3: UILabel!
      @IBOutlet weak var profileImg3: UIImageView!
    
    @IBOutlet weak var chatViewHight: NSLayoutConstraint!
    @IBOutlet weak var msgView: UIView!
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var confirm: UIButton!
    @IBOutlet weak var reject: UIButton!
    var hidePopUp = "0"
    @IBOutlet weak var confirmView: UIView!
    var servicesBooking_id = 0
     var clinicId = ""
    
      var profileImage = ""
        var clinicName2 = ""
    
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var msgText: IQTextView!
    
     @IBOutlet weak var firstmsgText: UITextView!
    
    var allChatDataArray = NSMutableArray()
    var ClinicDataArray = NSMutableArray()
    
    @IBOutlet weak var timeFirst: UILabel!
    var gameTimer: Timer?
    var timmercalling=false
    
      var appointmentDate = ""
      var appointmentTime = ""
    var RequestTime = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)

        self.msgView.layer.cornerRadius = 10
        self.roundView.layer.cornerRadius = 20
        self.confirm.layer.cornerRadius = 6
        self.reject.layer.cornerRadius = 6
        profileImg.layer.cornerRadius=profileImg.frame.height/2
        profileImg.clipsToBounds=true
        self.clinicName.text=clinicName2
        
        
        profileImg3.layer.cornerRadius=profileImg3.frame.height/2
        profileImg3.clipsToBounds=true
        self.clinicName3.text=clinicName2
        
        
        
        
                      if let url2 = profileImage as? String
                             {
                    let fullurl =  url2
                                                                   
                         print("Image full url \(fullurl)")
                         let url = URL(string: fullurl)
                                profileImg3.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
                        profileImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
                         }
       
        
        if hidePopUp == "0"
        {
            self.timeFirst.text = self.RequestTime
            
            self.confirmView.isHidden=false
        let name = DEFAULT.value(forKey: "USERNAME") as? String ?? "Amarendra"
                 
                let str = "Hi " + "\(name)"
                 let str2 = str + ", We are happy to inform you that your schedule for appointment has been approved. Your dental appointment will be on " + "\(appointmentDate)"
                 let str3 = str2 + " at " + "\(appointmentTime)"

                 let str4 = str3+" Please confirm."
                 
               self.firstmsgText.text = str4
             //"Hi "+ "\(name)"+ " , We are happy to inform you that your schedule for appointent has been approved. Your dental appointment will be on "\(appointmentDate)" at 10:30 am. Please confirm."
        }
        else
        {
            self.confirmView.isHidden=true
            AllChatDataAPI()
        }
        
        chatTable.register(UINib(nibName: "ReciverTableViewCell", bundle: nil), forCellReuseIdentifier: "ReciverTableViewCell")
        chatTable.register(UINib(nibName: "ChatSenderTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatSenderTableViewCell")
        
        chatTable.rowHeight=100
        chatTable.estimatedRowHeight=UITableView.automaticDimension
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
        IQKeyboardManager.shared.enable=false
           self.tabBarController?.tabBar.isHidden = true
        
        
       }
       
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(true)
        gameTimer?.invalidate()
        IQKeyboardManager.shared.enable=true
           self.tabBarController?.tabBar.isHidden = false
       }
  @objc func runTimedCode()
  {
    print("timmer calling ")
    timmercalling=true
    AllChatDataAPI()
 }
    
    @objc fileprivate func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
            // Do something with size
            self.chatViewBottomConst.constant = -(keyboardSize.height+90)
            self.chatViewHight.constant=100
        }
    }

    @objc fileprivate func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            // Do something with size
             self.chatViewBottomConst.constant = -8
            self.chatViewHight.constant=60
        }
    }
    @IBAction func sendMesgAction(_ sender: UIButton) {
         if  msgText.text == ""
        {
            NetworkEngine.commonAlert(message: "Please type message.", vc: self)
        }
            
        else
        {
            
            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
            {
                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
            }
            else
            {
                self.sendMessageAPI()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
       {
           return self.allChatDataArray.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
       {
        let dict = self.allChatDataArray.object(at: indexPath.row) as! NSDictionary
        
        let senderId = dict.value(forKey: "senderId") as? String  ?? ""
        
        if senderId == clinicId
        {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ReciverTableViewCell") as! ReciverTableViewCell
               
    cell.messageView.layer.cornerRadius = 10
    cell.messagetext.text = dict.value(forKey: "message") as? String  ?? ""
            cell.timelbl.text =  self.convertDateFormater(dict.value(forKey: "created_at") as? String  ?? "")
            
            
            
            cell.profileimg.layer.cornerRadius=cell.profileimg.frame.height/2
            cell.profileimg.clipsToBounds=true
            
            cell.messagetext.textAlignment = .left
            cell.clinicName.text=clinicName2
              if let url2 = profileImage as? String
                     {
            let fullurl =  url2
                                                           
                 print("Image full url \(fullurl)")
                 let url = URL(string: fullurl)
                                                           
                        cell.profileimg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
                 }
            
        return cell
            
        }
        else
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatSenderTableViewCell") as! ChatSenderTableViewCell
            cell.messageView.layer.cornerRadius = 10
            cell.messagetext.textAlignment = .right
            
            cell.senderTime.text =  self.convertDateFormater(dict.value(forKey: "created_at") as? String  ?? "")
            
            cell.messagetext.text = dict.value(forKey: "message") as? String  ?? ""
            cell.profileimg.layer.cornerRadius=cell.profileimg.frame.height/2
            cell.profileimg.clipsToBounds=true
            if let url2 = DEFAULT.value(forKey: "USERPROFILE") as? String
            {
          let fullurl =  url2
                                                                      
            print("Image full url \(fullurl)")
            let url = URL(string: fullurl)
                                                                      
            cell.profileimg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
            }
//            else
//            {
//                let attrs = [
//                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28),
//                                                 NSAttributedString.Key.foregroundColor: UIColor.white
//                                             ]
//                                        
//                let user = DEFAULT.value(forKey: "USERNAME") as? String ?? ""
//                
//        self.profileImg.setImage(string: user, color: PROFILECOLOL, circular: true, textAttributes:attrs)
//            }
            
            
              return cell
        }
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
       {
           return UITableView.automaticDimension
       }
    
    
    @IBAction func confirm(_ sender: Any)
    {

        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
          self.confirmtAPI()
        }
        
    }
    @IBAction func reject(_ sender: Any)
    {
        
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
          self.CancelAppointmentAPI()
        }
    }
    @IBAction func goback(_ sender: UIButton)
    {
      self.navigationController?.popToRootViewController(animated: true)
    }
   
    func AllChatDataAPI()
            {
                var apiKey = "1234"
                        if let newuserEmail1 = DEFAULT.value(forKey: "APITOKEN") as? String
                        {
                            apiKey = "\(newuserEmail1)"
                        }
                    
                let params = ["recevierId" : self.clinicId,
                    "bookAppointmentId" :  "\(self.servicesBooking_id)"] as [String:String]
                
                if timmercalling == false
                {
                   SVProgressHUD.show()
                }
                else
                {
                    SVProgressHUD.dismiss()
                }
                
                
                
              
              print("para in book appotment = \(params)")
                   var DEVICETOKEN = "123456"
                     if let device = DEFAULT.value(forKey: "DEVICETOKEN") as? String
                     {
                         DEVICETOKEN = device
                     }
          let header = ["device-id":DEVICETOKEN,"device-type":"iOS","type":"iOS","api-token":apiKey] as [String:String]
                
                ApiHandler.apiDataPostMethod(url: GETCHATDATAAPI, parameters: params, Header: header) { (response, error) in
                    
                    if error == nil
                    {
                             
                        print(response)
                
                      if let dict = response as? NSDictionary
                                     {
                                         if let data = dict.value(forKey: "data") as? NSArray
                                         {
                                         
                                            self.allChatDataArray=data.mutableCopy() as! NSMutableArray
                                           self.chatTable.reloadData()
                                      }
//                                        if let data = dict.value(forKey: "clinicData") as? NSArray
//                                                {
//
//                                        self.ClinicDataArray=data.mutableCopy() as! NSMutableArray
//
//                                                }
                                         
                      }
                      
                    
                    }
                    else
                    {
                         SVProgressHUD.dismiss()
                        self.view.makeToast(error)
                    }
                }
            }
    
    
       func sendMessageAPI()
            {
                var apiKey = "1234"
                        if let newuserEmail1 = DEFAULT.value(forKey: "APITOKEN") as? String
                        {
                            apiKey = "\(newuserEmail1)"
                        }
            
                
               let params = ["bookAppointmentId" : "\(self.servicesBooking_id)",
                "recevierId" : self.clinicId,
                "message" : self.msgText.text!] as [String:String]
                
                SVProgressHUD.show()
                
                
              
              print("para in book appotment = \(params)")
                   var DEVICETOKEN = "123456"
                     if let device = DEFAULT.value(forKey: "DEVICETOKEN") as? String
                     {
                         DEVICETOKEN = device
                     }
          let header = ["device-id":DEVICETOKEN,"device-type":"iOS","type":"iOS","api-token":apiKey] as [String:String]
                
                ApiHandler.apiDataPostMethod(url: SENDMESSAGEBYUSERAPI, parameters: params, Header: header) { (response, error) in
                    
                    if error == nil
                    {
                        self.msgText.text = ""
                        self.msgText.resignFirstResponder()
                        self.AllChatDataAPI()
                        
                        
                        print(response)
                       self.confirmView.isHidden=true
                       //self.navigationController?.popViewController(animated: true)
                      if let dict = response as? NSDictionary
                                     {
                                         if let code = dict.value(forKey: "code") as? String
                                         {
                                          self.view.makeToast( dict.value(forKey: "message") as? String)
                                          if code == "201"
                                          {
                                            
                                           }
                                         
                                           
                                      }
                      }
                      
                    
                    }
                    else
                    {
                         SVProgressHUD.dismiss()
                        self.view.makeToast(error)
                    }
                }
            }
    
    func confirmtAPI()
         {
             var apiKey = "1234"
                     if let newuserEmail1 = DEFAULT.value(forKey: "APITOKEN") as? String
                     {
                         apiKey = "\(newuserEmail1)"
                     }
                 
            let params = ["servicesBooking_id" : "\(self.servicesBooking_id)"] as [String:String]
             
             SVProgressHUD.show()
             
             
           
           print("para in book appotment = \(params)")
                var DEVICETOKEN = "123456"
                  if let device = DEFAULT.value(forKey: "DEVICETOKEN") as? String
                  {
                      DEVICETOKEN = device
                  }
       let header = ["device-id":DEVICETOKEN,"device-type":"iOS","type":"iOS","api-token":apiKey] as [String:String]
             
             ApiHandler.apiDataPostMethod(url: CONFIRMBYUSERAPI, parameters: params, Header: header) { (response, error) in
                 
                 if error == nil
                 {
                    self.confirmView.isHidden=true
                    if let dict = response as? NSDictionary
                    {
                        if let code = dict.value(forKey: "code") as? String
                        {
                            
                            if code == "201"
                            {
                                
                            }
                            else
                            {
                               self.view.makeToast( dict.value(forKey: "message") as? String)
                            }
                            
                            
                        }
                    }
                    
                    
                    self.AllChatDataAPI()
                    
                     print(response)
                 
                 }
                 else
                 {
                      SVProgressHUD.dismiss()
                     self.view.makeToast(error)
                 }
             }
         }
    
    func CancelAppointmentAPI()
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
        let para = ["bookingId":"\(self.servicesBooking_id)"] as [String:String]
           
           print("heder =  \(header) and para =  \(para)")
           ApiHandler.ModelApiPostMethod(url: CANCELAPPOINTMENTAPI, parameters: para , Header: header) { (response, error) in
               
               if error == nil
               {
                self.navigationController?.popViewController(animated: true)
               }
               else
               {
                   SVProgressHUD.dismiss()
                   self.view.makeToast(error)
               }
           }
       }
    
    func convertDateFormater(_ date: String) -> String
                     {
                         let dateFormatter = DateFormatter()
                        //"2020-04-22 11:24:30"
                         dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                         dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                         let date2 = dateFormatter.date(from: date)
                         dateFormatter.dateFormat = "hh:mm a"
                        dateFormatter.timeZone = TimeZone.current
                        if date2 != nil
                        {
                           return  dateFormatter.string(from: date2!)
                        }
                        else
                        {
                            let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMMM d, yyyy"
                            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                        let date3 = dateFormatter.date(from: date)
                        dateFormatter.dateFormat = "hh:mm a"
                            dateFormatter.timeZone = TimeZone.current
                            return  "10:31 AM"//dateFormatter.string(from: date3!)
                        }

                     }
    
    
}
