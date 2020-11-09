//
//  OTPscreen.swift
//  Dental Place
//
//  Created by eWeb on 11/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class OTPscreen: UIViewController
{
    
    var prodSeconds = String() // This value is set in a different view controller
    lazy var intProdSeconds = Int(prodSeconds)
    var timer = Timer()
    var isTimerRunning = false  // Make sure only one timer is running at a time

    var otpTimer: Timer?

    @IBOutlet weak var submet: UIButton!
    @IBOutlet weak var minTxt: UILabel!
    @IBOutlet weak var secTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    var registerData:ForgotModel?
    
    var userEmail=""
    var userOTP=""

    
    
    @IBOutlet weak var text: UITextView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.submet.layer.cornerRadius = 6
       // startTimer()
        
        self.passwordTxt.text=userOTP
        
        text.textAlignment = .center
        text.attributedText = attributedText()
        
        }
    
   
    func startTimer() {
        otpTimer?.invalidate() //cancels it if already running
        otpTimer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(timerDidFire(_:)), userInfo: nil, repeats: false)
    }
    @objc func timerDidFire(_ timer: Timer) {
        
        // timer has completed.  Do whatever you want...
    }

    @IBAction func submetAct(_ sender: UIButton)
    {
        
       
         if passwordTxt.text == ""
        {
            NetworkEngine.commonAlert(message: "Please enter OTP.", vc: self)
            
        }
        else
        {
            
            let NewPassScreen = self.storyboard?.instantiateViewController(withIdentifier: "NewPassScreen") as! NewPassScreen
           
            NewPassScreen.userOTP=self.passwordTxt.text!
            NewPassScreen.userEmail=self.userEmail

            self.navigationController?.pushViewController(NewPassScreen, animated: true)
            
//            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
//            {
//                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
//            }
//            else
//            {
//                self.OTPAPI()
//            }
//
        }
        
        
    }
    
    @IBAction func resendCode(_ sender: UIButton)
    {
        
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.ForgotAPI()
        }
    }
    @IBAction func gotoLogin(_ sender: UIButton)
    {
        let signup = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(signup, animated: true)
        
        
    }
    
    
}
extension OTPscreen
{
    //MARK:- OTP Api
    
    func OTPAPI()
    {
        
        
        var userid = "16"
        if let newuserID = DEFAULT.value(forKey: "USERID") as? String
        {
            userid = "\(newuserID)"
        }
        var DEVICETOKEN = "123456"
               if let device = DEFAULT.value(forKey: "DEVICETOKEN") as? String
               {
                   DEVICETOKEN = device
               }
        
        let params = ["password" : passwordTxt.text!]   as [String : String]
        let header = ["device-id":DEVICETOKEN,"device-type":"iOS"] as [String:String]
        
        ApiHandler.ModelApiPostMethod(url: REGISTERAPI, parameters: params, Header: header) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.registerData = try decoder.decode(ForgotModel.self, from: response!)
                    if self.registerData?.code == 201
                        
                    {
                        self.view.makeToast(self.registerData?.message)
                        
                        self.passwordTxt.text=self.registerData?.otp
//                        let WelcomeScreen = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeScreen") as! WelcomeScreen
//                        DEFAULT.set("YES", forKey: "USERID")
//                        DEFAULT.set("YES", forKey: "START")
//                        DEFAULT.synchronize()
//
//                        self.navigationController?.pushViewController(WelcomeScreen, animated: true)
                        
                    }
                    else
                    {
                        NetworkEngine.commonAlert(message: self.registerData?.message ?? "", vc: self)
                        
                        //self.view.makeToast(self.registerData?.message)
                    }
                    
                    
                }
                catch let error
                {
                    self.view.makeToast(error.localizedDescription)
                }
                
            }
            else
            {
                self.view.makeToast(error)
            }
        }
    }
    
    
    //MARK:- forgot Api
    
    func ForgotAPI()
    {
        let params = ["email" : userEmail]   as [String : String]
        var DEVICETOKEN = "123456"
        if let device = DEFAULT.value(forKey: "DEVICETOKEN") as? String
        {
            DEVICETOKEN = device
        }
        let header = ["device-id":DEVICETOKEN,"device-type":"iOS"] as [String:String]
        
        ApiHandler.ModelApiPostMethod(url: RECOVERYPASSORDAPI, parameters: params, Header: header) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.registerData = try decoder.decode(ForgotModel.self, from: response!)
                    if self.registerData?.code == 201
                        
                    {
                     // NetworkEngine.commonAlert(message: self.registerData?.message ?? "", vc: self)
                        self.passwordTxt.text=self.registerData?.otp
                        
                    }
                    else
                    {
                        NetworkEngine.commonAlert(message: self.registerData?.message ?? "", vc: self)
                        
                        //self.view.makeToast(self.registerData?.message)
                    }
                    
                    
                }
                catch let error
                {
                    self.view.makeToast(error.localizedDescription)
                }
                
            }
            else
            {
                self.view.makeToast(error)
            }
        }
    }
    
    func attributedText() -> NSAttributedString {
        
        let string = "We've  sent a code to your email : \(userEmail). Kindly enter the code here before it expires." as NSString
        
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17.0)])
        
        let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18.0)]
        
        // Part of string to be bold
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: userEmail))
        //attributedString.addAttributes(boldFontAttribute, range: string.range(of: "PLEASE NOTE:"))
        
        // 4
        return attributedString
    }
}

