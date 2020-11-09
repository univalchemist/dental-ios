//
//  RatingViewController.swift
//  Dental Place
//
//  Created by eWeb on 13/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import FloatRatingView
import IQKeyboardManagerSwift
import SVProgressHUD

class RatingViewController: UIViewController,FloatRatingViewDelegate{

   
    @IBOutlet weak var messageText: IQTextView!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var clinicnmeLbl: UILabel!
    @IBOutlet weak var serviceNem: UILabel!
    var star_rate = ""
    var clinicId = ""
    
    var servicename = ""
    var profile = ""
       var location = ""
    var detailDict = NSDictionary()
    @IBOutlet weak var profileImg: UIImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ratingView.delegate=self
        
        messageText.layer.shadowPath = UIBezierPath(rect: messageText.bounds).cgPath
               messageText.layer.shadowRadius = 5
               messageText.layer.shadowOffset = .zero
               messageText.layer.shadowOpacity = 1
               messageText.layer.shadowColor = UIColor.gray.cgColor

        self.locationLbl.text = location
        self.serviceNem.text = servicename
        
        let dict = detailDict
            
            
           // avgRating.text = dict.value(forKey: "star_rate") as? String ?? ""
           
            
            let rating = dict.value(forKey: "star_rate") as? String ?? "1"
           ratingView.rating = Double(rating)!
        self.star_rate=rating
            profileImg.layer.cornerRadius=profileImg.frame.height/2
            profileImg.clipsToBounds=true
            
        if let clilicDict = dict.value(forKey: "owner_data") as? NSDictionary
             {
                 
                 
                 clinicnmeLbl.text = clilicDict.value(forKey: "user_name") as? String ?? ""
                 
                 
                 if let url2 = clilicDict.value(forKey: "profile_image") as? String
                 {
                 let fullurl =  url2
                                                       
             print("Image full url \(fullurl)")
             let url = URL(string: fullurl)
                                                       
            profileImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
             }
                 
             }

            
            
        
        
        
        
//        if let url2 = clilicDict.value(forKey: "profile_image") as? String
//                      {
//                      let fullurl =  url2
//                                                            
//                  print("Image full url \(fullurl)")
//                  let url = URL(string: fullurl)
//                                                            
//                 cell.profileImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
//                  }
              // locaView.dropShadow(color: .black, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 20, scale: true)
               
               messageText.layer.cornerRadius = 4
    }
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        self.star_rate="\(Int(rating))"
    }
    @IBAction func goback(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func submitAction(_ sender: Any)
    {
        if messageText.text == ""
            {
                
                NetworkEngine.commonAlert(message: "Please type some message.", vc: self)
                
            }
        else
        {
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                                    {
                    NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
                        }
        else
                    {
                            self.AddRatingAPI()

            }
        }
        
      
    }
    
    //MARK:- book Appointment Api
         
         func AddRatingAPI()
         {
             var apiKey = "1234"
                     if let newuserEmail1 = DEFAULT.value(forKey: "APITOKEN") as? String
                     {
                         apiKey = "\(newuserEmail1)"
                     }
              
            let params = ["vendor_id" : self.clinicId,"star_rate" : self.star_rate,"feedback" : messageText.text!] as [String:String]
             
             SVProgressHUD.show()
             
             
           
           print("para in book AddRatingAPI = \(params)")
           var DEVICETOKEN = "123456"
                  if let device = DEFAULT.value(forKey: "DEVICETOKEN") as? String
                  {
                      DEVICETOKEN = device
                  }
             let header = ["device-id":DEVICETOKEN,"device-type":"iOS","type":"iOS","api-token":apiKey] as [String:String]
             
             ApiHandler.apiDataPostMethod(url: ADDRATINGAPI, parameters: params, Header: header) { (response, error) in
                 
                 if error == nil
                 {
                     print(response)
                    
                   if let dict = response as? NSDictionary
                                  {
                                      if let code = dict.value(forKey: "code") as? String
                                      {
                                       self.view.makeToast( dict.value(forKey: "message") as? String)
                                       if code == "201"
                                       {
                                           DispatchQueue.main.asyncAfter(deadline: .now() + 2.0)
                                               {
                                                                                   
                  
                        
                        self.navigationController?.popViewController(animated: true)
                   }
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
}
