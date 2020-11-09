//
//  RegisterViewController.swift
//  Dental Place
//
//  Created by eWeb on 11/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookLogin
import AuthenticationServices
import CoreData
class RegisterViewController: UIViewController
{

    @IBOutlet weak var facebook: UIView!
    @IBOutlet weak var createAcc: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var confirmpwdTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    var registerData:RegisterModel?
    
    @IBOutlet weak var appleSignInBtn: UIButton!
       fileprivate var currentNonce: String?
       var social_login_type = "F"
    var social_login_status = 0
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.facebook.layer.cornerRadius = 6
        self.createAcc.layer.cornerRadius = 6
        self.confirmpwdTxt.isSecureTextEntry = true
        self.passwordTxt.isSecureTextEntry = true
    
        if #available(iOS 13.0, *) {
                   self.appleSignInBtn.isHidden=false
                 //  appleSignInBtn.layer.cornerRadius=appleSignInBtn.frame.height/2
                 //  appleSignInBtn.clipsToBounds=true
                 //  appleSignInBtn.layer.borderColor = UIColor.black.cgColor
                  // appleSignInBtn.layer.borderWidth=1
                 //  appleSignInBtn.setTitle("", for: .normal)
                   setupSOAppleSignIn()
                 
               }
               else
               {
                   self.appleSignInBtn.isHidden=true
                   appleSignInBtn.setTitle("", for: .normal)
                
               }
    }
    
    func setupSOAppleSignIn() {
          
          if #available(iOS 13.0, *) {
              let btnAuthorization = ASAuthorizationAppleIDButton()
              
              
              btnAuthorization.translatesAutoresizingMaskIntoConstraints = false
              
              // add the button to the view controller root view
              self.appleSignInBtn.addSubview(btnAuthorization)
              
              // set constraint
              NSLayoutConstraint.activate([
                  btnAuthorization.leadingAnchor.constraint(equalTo: self.appleSignInBtn.leadingAnchor, constant: 0.0),
                  btnAuthorization.trailingAnchor.constraint(equalTo: self.appleSignInBtn.trailingAnchor, constant: 0.0),
                  btnAuthorization.bottomAnchor.constraint(equalTo: self.appleSignInBtn.bottomAnchor, constant: 0.0),
                  btnAuthorization.widthAnchor.constraint(equalToConstant: 45.0),
                  btnAuthorization.heightAnchor.constraint(equalToConstant: 48.0)
                  ])
              
              
              btnAuthorization.addTarget(self, action: #selector(actionHandleAppleSignin), for: .touchUpInside)
              
              self.appleSignInBtn.addSubview(btnAuthorization)
          } else {
              // Fallback on earlier versions
          }
          
          
          
      }
      
      @objc func actionHandleAppleSignin() {
          
          if #available(iOS 13.0, *) {
              let appleIDProvider = ASAuthorizationAppleIDProvider()
              let request = appleIDProvider.createRequest()
              let nonce = randomNonceString()
              currentNonce = nonce
              request.requestedScopes = [.fullName, .email]
              
              let authorizationController = ASAuthorizationController(authorizationRequests: [request])
              
              authorizationController.delegate = self
              
              authorizationController.presentationContextProvider = self
              
              authorizationController.performRequests()
          } else {
              // Fallback on earlier versions
          }
          
          
          
      }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let maxLength = 35
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
 
    @IBAction func goLogin(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func facebookAct(_ sender: UIButton)
    {
        
            
            /*
             
             facebookId =  testdemo198@gmail.com
             facebookPASS = adminuser@123
             
             */
            let fbLoginManager : LoginManager = LoginManager()
            
            
            fbLoginManager.logIn(permissions: ["public_profile","email"], from: self)
            { (result, error) in
                if (error == nil)
                {
                    
                    
                    let fbloginresult : LoginManagerLoginResult = result!
                    if fbloginresult.grantedPermissions != nil
                    {
                        if(fbloginresult.grantedPermissions.contains("email"))
                        {
                            if((AccessToken.current) != nil)
                            {
                                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                                    if (error == nil)
                                    {
                                        let dict: NSDictionary = result as! NSDictionary
                                        
                                        print("facebook data=\(dict)")
                                        if let token = AccessToken.current?.tokenString
                                        {
                                            print("tocken: \(token)")
                                            
                                            let userDefult = UserDefaults.standard
                                            userDefult.setValue(token, forKey: "access_tocken")
                                            userDefult.synchronize()
                                            
                                            
                                        }
                                        if let user : NSString = dict.object(forKey:"name") as! NSString?
                                        {
                                            let userDefult = UserDefaults.standard
                                            userDefult.setValue(user, forKey: "name")
                                            userDefult.synchronize()
                                            print("user: \(user)")
                                            // self.fusername1 = user as String
                                            
                                        }
            if let first_name : NSString = dict.object(forKey:"first_name") as! NSString?
            {
            let userDefult = UserDefaults.standard
            userDefult.setValue(first_name, forKey: "first_name")
                userDefult.synchronize()
            print("first_name: \(first_name)")
                                            // self.fusername1 = user as String
                                            
            }
    if let last_name : NSString = dict.object(forKey:"last_name") as! NSString?
        {
            let userDefult = UserDefaults.standard
            userDefult.setValue(last_name, forKey: "last_name")
            userDefult.synchronize()
        print("last_name: \(last_name)")
        // s= user as String
                                            
    }
                                        
                                        if let id : NSString = dict.object(forKey:"id") as? NSString
                                        {
                                            print("id: \(id)")
                                            //self.loginType = "facebook"
                                            //self.ApiSocialLoginSuccess(getID: "\(id)")
                                            
                                        }
                                        if let email : NSString = (result! as AnyObject).value(forKey: "email") as? NSString
                                        {
                                    self.emailField.text = email as String
                                            //self.passwordTxt.text = email as String
                                            print("email: \(email)")
                                            //self.fuseremail1 = email as String
                                            
                                        
                                        }
                                        fbLoginManager.logOut()
                                        
                                                 }
                                })
                            }
                        }
                    }
                }
            }
            
        
    }
    
    @IBAction func createAct(_ sender: UIButton)
    {
        
        if emailField.text == ""
        {
            
            NetworkEngine.commonAlert(message: "Please enter email id.", vc: self)
            
        }
        else if passwordTxt.text == ""
        {
            NetworkEngine.commonAlert(message: "Please enter password.", vc: self)
            
        }
        else if (Int(passwordTxt.text!.count) < 6)
        {
            NetworkEngine.commonAlert(message: "Please enter at least 6 characters password.", vc: self)
            
        }

        else if passwordTxt.text != confirmpwdTxt.text
        {
     NetworkEngine.commonAlert(message: "Password and confirm password should match.", vc: self)
            
        }

        else if !NetworkEngine.networkEngineObj.validateEmail(candidate: emailField.text!)
        {
            NetworkEngine.commonAlert(message: "Please enter valid email.", vc: self)
        }

        else
        {
            
            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
            {
                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
            }
            else
            {
                self.RegisterAPI()
            }
            
        }
    }
    

}

extension RegisterViewController
{
    //MARK:- Register Api
    
    func RegisterAPI()
    {
        var DEVICETOKEN = "123456"
        if let device = DEFAULT.value(forKey: "DEVICETOKEN") as? String
        {
            DEVICETOKEN = device
        }
        let params = ["user_email" : emailField.text!,
                      "password" : passwordTxt.text!,
                      "status" : self.social_login_status]   as [String : Any]
        let header = ["device-id":DEVICETOKEN,"device-type":"iOS"] as [String:String]
        
        ApiHandler.ModelApiPostMethod(url: REGISTERAPI, parameters: params, Header: header) { (response, error) in

            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.registerData = try decoder.decode(RegisterModel.self, from: response!)
                    if self.registerData?.statusCode == "200"
                    
                    {
                        self.view.makeToast(self.registerData?.message)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0)
                        {
                            APPDEL.loadLoginView()

                            
                        };
                        
                        

                        
//
                        
                        
//                        let WelcomeScreen = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeScreen") as! WelcomeScreen
//                        DEFAULT.set("YES", forKey: "USERID")
//                        DEFAULT.set("YES", forKey: "START")
//                        DEFAULT.synchronize()
//
//                        self.navigationController?.pushViewController(WelcomeScreen, animated: true)
//
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
    
}

extension RegisterViewController: ASAuthorizationControllerDelegate {

     // ASAuthorizationControllerDelegate function for authorization failed
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

        print(error.localizedDescription)

    }

       // ASAuthorizationControllerDelegate function for successful authorization
    @available(iOS 13.0, *)
  
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        if #available(iOS 13.0, *) {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                
                // Create an account as per your requirement
                
                let appleId = appleIDCredential.user
                
                let appleUserFirstName = appleIDCredential.fullName?.givenName
                
                let appleUserLastName = appleIDCredential.fullName?.familyName
                
                
                 var userEmailFB = "".randomString(length: 5)+"@privaterelay.appleid.com"
                if let appleUserEmail = appleIDCredential.email
                {
                    userEmailFB = appleUserEmail
                }
                  else
                    {
                    self.social_login_status = 1
                    }
                
                
                print("appleId = \(appleId)")
                 print("appleUserEmail = \(userEmailFB)")
                print("appleUserFirstName = \(appleUserFirstName)")
                print("appleUserLastName = \(appleUserLastName)")
                //Write your code
                
                    self.social_login_type="A"
                var facebook_id=appleId ?? "".randomString(length: 10)
            
                            //            print(fullName)
                            //            let givenName = user.profile.givenName
                            //            let familyName = user.profile.familyName
               
        DEFAULT.setValue(appleUserLastName, forKey: "last_name")
            DEFAULT.setValue(appleUserFirstName, forKey: "first_name")
            DEFAULT.setValue(userEmailFB, forKey: "name")
                DEFAULT.synchronize()
                
                
                self.emailField.text = userEmailFB as String
                
                            // let image = user.profile.imageURL(withDimension: 120)
                            
                          //  self.gmailProfile = user.profile.imageURL(withDimension: 400)
                            
                            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                            {
                              NetworkEngine.networkEngineObj.showInterNetAlert(vc: self)
                            }
                            else
                            {
                               // self.LoginWithAppleAPI()
                            }
                
            } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
                
                let appleUsername = passwordCredential.user
                
                let applePassword = passwordCredential.password
                
                //Write your code
                
            }
        } else {
            // Fallback on earlier versions
        }

    }
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
     func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
}

extension RegisterViewController: ASAuthorizationControllerPresentationContextProviding {
    
    //For present window
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return self.view.window!
        
    }
    
}
