//
//  LoginViewController.swift
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


class LoginViewController: UIViewController
{
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var fbBtn: UIView!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    var loginData:LoginModel?
    var faceloginData:FacebookLoginModel?
    
    
    var userNameFB = ""
    var userEmailFB = ""
    var facebook_id = ""
    let fbLoginManager : LoginManager = LoginManager()
    
    var authAPI: AuthRemoteAPI!
    
    @IBOutlet weak var appleSignInBtn: UIButton!
    fileprivate var currentNonce: String?
    var social_login_type = "F"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        authAPI = DentalAuthRemoteAPI()
        self.loginBtn.layer.cornerRadius = 6
        self.fbBtn.layer.cornerRadius = 6
        
        
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
    
    @IBAction func mainLoginAct(_ sender: UIButton)
    {
        
        //        let WelcomeScreen = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeScreen") as! WelcomeScreen
        //        DEFAULT.set("YES", forKey: "USERID")
        //        DEFAULT.set("YES", forKey: "START")
        //        DEFAULT.synchronize()
        //
        //        self.navigationController?.pushViewController(WelcomeScreen, animated: true)
        //
        if emailTxt.text == ""
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
            
            
        else if !NetworkEngine.networkEngineObj.validateEmail(candidate: emailTxt.text!)
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
                self.LoginWithEmailAPI()
            }
            
        }
        
    }
    
    
    @IBAction func forgtAct(_ sender: UIButton)
    {
        let ForgetPassView = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPassView") as! ForgetPassView
        self.navigationController?.pushViewController(ForgetPassView, animated: true)
        
    }
    
    @IBAction func goSignup(_ sender: UIButton)
    {
        
        let signup = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(signup, animated: true)
        
    }
    
    @IBAction func loginFB(_ sender: Any)
    {
        
        /*
         
         facebookId =  testdemo198@gmail.com
         facebookPASS = adminuser@123
         
         */
        
        
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
                            //"id,name,email,birthday,gender,hometown"
                            
                            //["fields": "id, name, first_name, last_name, picture.type(large), email"]
                            //"id, name, first_name, last_name, picture.type(large), email, gender, birthday, phone"
                            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.width(80).height(80), email,birthday,gender,hometown,location"]).start(completionHandler: { (connection, result, error) -> Void in
                                if (error == nil)
                                {
                                    let dict: NSDictionary = result as! NSDictionary
                                    
                                    print("facebook data= \(dict)")
                                    if let token = AccessToken.current?.tokenString
                                    {
                                        print("tocken: \(token)")
                                        
                                        let userDefult = UserDefaults.standard
                                        userDefult.setValue(token, forKey: "access_tocken")
                                        userDefult.synchronize()
                                        
                                        
                                    }
                                    if let user : NSString = dict.object(forKey:"name") as! NSString?
                                    {
                                        self.userNameFB = user as String
                                        
                                        let userDefult = UserDefaults.standard
                                        userDefult.setValue(user, forKey: "name")
                                        userDefult.synchronize()
                                        print("user: \(user)")
                                        // self.fusername1 = user as String
                                        
                                    }
                                    
                                    if let profilePictureObj = dict.object(forKey: "picture") as? NSDictionary
                                    {
                                        let data = profilePictureObj.value(forKey: "data") as! NSDictionary
                                        let pictureUrlString  = data.value(forKey: "url") as! String
                                        //let pictureUrl = URL(string: pictureUrlString)
                                        DEFAULT.setValue(pictureUrlString, forKey: "FBPictureUrl")
                                        DEFAULT.synchronize()
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
                                        // self.fusername1 = user as String
                                        
                                    }
                                    if let id : NSString = dict.object(forKey:"id") as? NSString
                                    {
                                        print("id: \(id)")
                                        self.facebook_id = id as String
                                        
                                        //self.loginType = "facebook"
                                        //self.ApiSocialLoginSuccess(getID: "\(id)")
                                        
                                    }
                                    if let email : NSString = dict.value(forKey: "email") as? NSString
                                    {
                                        print("email: \(email)")
                                        self.userEmailFB = email as String
                                        
                                        //self.fuseremail1 = email as String
                                        let userDefult = UserDefaults.standard
                                        userDefult.setValue(email, forKey: "email")
                                        userDefult.setValue(email, forKey: "USEREMAIL")
                                        userDefult.synchronize()
                                        print("email: \(email)")
                                        
                                    }
                                    
                                    
                                    
                                    self.LoginWithFacebookAPI()
                                    
                                    //    let WelcomeScreen = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeScreen") as! WelcomeScreen
                                    //    DEFAULT.set("YES", forKey: "USERID")
                                    //    DEFAULT.set("YES", forKey: "START")
                                    //    DEFAULT.synchronize()
                                    //
                                    //    self.navigationController?.pushViewController(WelcomeScreen, animated: true)
                                    
                                }
                                else
                                {
                                    print("facebook \(error) error =\(error?.localizedDescription)")
                                }
                            })
                        }
                    }
                }
            }
            else
            {
                print("facebook \(error) error =\(error?.localizedDescription)")
                
            }
        }
        
    }
    
}

//MARK:- Api work

extension LoginViewController
{
    //MARK:- Login With Email Api
    func signedIn(to userSession: UserSession) {
        self.view.makeToast(self.loginData?.message)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
        {
            
            if userSession.userData?.userName == nil
                || userSession.userData?.userName == " " || userSession.userData?.userName == "  " || userSession.userData?.userName == "null"
            {

                let WelcomeScreen = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeScreen") as! WelcomeScreen

                DEFAULT.set(self.loginData?.data?.apiToken, forKey: "APITOKEN")
                DEFAULT.set(self.loginData?.data?.userData?.userEmail, forKey: "USEREMAIL")
                DEFAULT.set(self.loginData?.data?.userData?.userName, forKey: "USERNAME")

                DEFAULT.set(self.loginData?.data?.userData?.id, forKey: "USERID")
                //DEFAULT.set("YES", forKey: "START")
                DEFAULT.removeObject(forKey: "name")
                DEFAULT.removeObject(forKey: "picture")
                DEFAULT.removeObject(forKey: "first_name")
                DEFAULT.removeObject(forKey: "last_name")
                DEFAULT.removeObject(forKey: "email")


                DEFAULT.synchronize()




                self.navigationController?.pushViewController(WelcomeScreen, animated: true)

            }
            else
            {


                let WelcomeScreen = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController//HomeTabBarController
                DEFAULT.set(self.loginData?.data?.apiToken, forKey: "APITOKEN")
                DEFAULT.set(self.loginData?.data?.userData?.userEmail, forKey: "USEREMAIL")
                DEFAULT.set(self.loginData?.data?.userData?.userName, forKey: "USERNAME")
                DEFAULT.set(self.loginData?.data?.userData?.id, forKey: "USERID")

                //DEFAULT.set("YES", forKey: "START")
                DEFAULT.synchronize()

                self.navigationController?.pushViewController(WelcomeScreen, animated: true)
            }



        };

    }

    func indicateErrorSigningIn(_ error: Error) {
        let authError = DentalHelpers.handlePromiseError(error)
        self.view.makeToast(authError.message)
    }
    
    func LoginWithEmailAPI()
    {
        
        
        var DEVICETOKEN = "123456"
        if let device = DEFAULT.value(forKey: "DEVICETOKEN") as? String
        {
            DEVICETOKEN = device
        }
        
        
        fbLoginManager.logOut()
        let params = ["user_email" : emailTxt.text!,
                      "password" : passwordTxt.text!,]   as [String : String]
        let header = ["device-id":DEVICETOKEN,"device-type":"iOS"] as [String:String]
        let signInParams = SignInParameters(email: emailTxt.text!, password: passwordTxt.text!)
        authAPI.signIn(account: signInParams)
            .done(signedIn(to:))
            .catch(indicateErrorSigningIn)
        
        
//        ApiHandler.ModelApiPostMethod(url: LOGINWITHEMAILAPI, parameters: params, Header: header) { (response, error) in
//
//            if error == nil
//            {
//                let decoder = JSONDecoder()
//                do
//                {
//                    self.loginData = try decoder.decode(LoginModel.self, from: response!)
//                    //self.view.makeToast(self.loginData?.message)
//
//                    if self.loginData?.statusCode == "200" {
//                        self.view.makeToast(self.loginData?.message)
//
//
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0)
//                        {
//
//                            if self.loginData?.data?.userData?.userName == nil
//                                || self.loginData?.data?.userData?.userName == " " || self.loginData?.data?.userData?.userName == "  " || self.loginData?.data?.userData?.userName == "null"
//                            {
//
//                                let WelcomeScreen = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeScreen") as! WelcomeScreen
//
//                                DEFAULT.set(self.loginData?.data?.apiToken, forKey: "APITOKEN")
//                                DEFAULT.set(self.loginData?.data?.userData?.userEmail, forKey: "USEREMAIL")
//                                DEFAULT.set(self.loginData?.data?.userData?.userName, forKey: "USERNAME")
//
//                                DEFAULT.set(self.loginData?.data?.userData?.id, forKey: "USERID")
//                                //DEFAULT.set("YES", forKey: "START")
//                                DEFAULT.removeObject(forKey: "name")
//                                DEFAULT.removeObject(forKey: "picture")
//                                DEFAULT.removeObject(forKey: "first_name")
//                                DEFAULT.removeObject(forKey: "last_name")
//                                DEFAULT.removeObject(forKey: "email")
//
//
//                                DEFAULT.synchronize()
//
//
//
//
//                                self.navigationController?.pushViewController(WelcomeScreen, animated: true)
//
//                            }
//                            else
//                            {
//
//
//
//
//                                let WelcomeScreen = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController//HomeTabBarController
//                                DEFAULT.set(self.loginData?.data?.apiToken, forKey: "APITOKEN")
//                                DEFAULT.set(self.loginData?.data?.userData?.userEmail, forKey: "USEREMAIL")
//                                DEFAULT.set(self.loginData?.data?.userData?.userName, forKey: "USERNAME")
//                                DEFAULT.set(self.loginData?.data?.userData?.id, forKey: "USERID")
//
//                                //DEFAULT.set("YES", forKey: "START")
//                                DEFAULT.synchronize()
//
//                                self.navigationController?.pushViewController(WelcomeScreen, animated: true)
//                            }
//
//
//
//                        };
//
//
//
//                    }
//                    else
//                    {
//                        NetworkEngine.commonAlert(message: self.loginData?.message ?? "", vc: self)
//                    }
//
//
//                }
//                catch let error
//                {
//                    self.view.makeToast(error.localizedDescription)
//                }
//
//            }
//            else
//            {
//                self.view.makeToast(error)
//            }
//        }
        
        
    }
    
    
    //MARK:- Login With social Api
    
    func LoginWithFacebookAPI()
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
        
        
        let params = ["user_email" : self.userEmailFB,
                      "user_name" : self.userNameFB,
                      "facebook_id" : self.facebook_id,
                      "facebook_login" : "F"]   as [String : String]
        let header = ["device-id":DEVICETOKEN,"device-type":"iOS"] as [String:String]
        ApiHandler.ModelApiPostMethod(url: LOGINWITHFACEBOOKLAPI, parameters: params, Header: header) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.faceloginData = try decoder.decode(FacebookLoginModel.self, from: response!)
                    //self.view.makeToast(self.loginData?.message)
                    
                    
                    if self.faceloginData?.statusCode == "200"
                        
                    {
                        
                        
                        if self.faceloginData?.data?.profile_status == "1"
                            
                        {
                            let WelcomeScreen = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
                            
                            if let cout = self.faceloginData?.data?.tokens?.count
                            {
                                if cout>0
                                    
                                {
                                    DEFAULT.set("YES", forKey: "USERID")
                                    // DEFAULT.set("YES", forKey: "START")
                                    DEFAULT.synchronize()
                                    DEFAULT.set(self.faceloginData?.data?.tokens?[0].apiToken, forKey: "APITOKEN")
                                    DEFAULT.set(self.faceloginData?.data?.id, forKey: "USERID")
                                    DEFAULT.set(self.userEmailFB, forKey: "USEREMAIL")
                                    DEFAULT.set(self.faceloginData?.data?.userName, forKey: "USERNAME")
                                    self.navigationController?.pushViewController(WelcomeScreen, animated: true)
                                }
                                
                            }
                        }
                        else
                            
                        {
                            
                            
                            let WelcomeScreen = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeScreen") as! WelcomeScreen
                            
                            if let cout = self.faceloginData?.data?.tokens?.count
                            {
                                if cout>0
                                    
                                {
                                    DEFAULT.set("YES", forKey: "USERID")
                                    //  DEFAULT.set("YES", forKey: "START")
                                    DEFAULT.synchronize()
                                    DEFAULT.set(self.faceloginData?.data?.tokens?[0].apiToken, forKey: "APITOKEN")
                                    DEFAULT.set(self.faceloginData?.data?.id, forKey: "USERID")
                                    DEFAULT.set(self.userEmailFB, forKey: "USEREMAIL")
                                    DEFAULT.set(self.faceloginData?.data?.userName, forKey: "USERNAME")
                                    
                                    self.navigationController?.pushViewController(WelcomeScreen, animated: true)
                                }
                                
                            }
                        }
                        
                    }
                    else
                    {
                        NetworkEngine.commonAlert(message: self.faceloginData?.message ?? "", vc: self)
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
    
    //MARK:- Login With social Api
    
    func LoginWithAppleAPI()
    {
        
        
        
        var DEVICETOKEN = "123456"
        if let device = DEFAULT.value(forKey: "DEVICETOKEN") as? String
        {
            DEVICETOKEN = device
        }
        
        
        let params = ["user_email" : self.userEmailFB,
                      "user_name" : self.userNameFB,
                      "apple_id" : self.facebook_id,
                      "apple_login" : "A"]   as [String : String]
        let header = ["device-id":DEVICETOKEN,"device-type":"iOS"] as [String:String]
        ApiHandler.ModelApiPostMethod(url: LOGINWITHFACEBOOKLAPI, parameters: params, Header: header) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.faceloginData = try decoder.decode(FacebookLoginModel.self, from: response!)
                    //self.view.makeToast(self.loginData?.message)
                    
                    
                    if self.faceloginData?.statusCode == "200"
                        
                    {
                        
                        
                        if self.faceloginData?.data?.profile_status == "1"
                            
                        {
                            let WelcomeScreen = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
                            
                            if let cout = self.faceloginData?.data?.tokens?.count
                            {
                                if cout>0
                                    
                                {
                                    DEFAULT.set("YES", forKey: "USERID")
                                    // DEFAULT.set("YES", forKey: "START")
                                    DEFAULT.synchronize()
                                    DEFAULT.set(self.faceloginData?.data?.tokens?[0].apiToken, forKey: "APITOKEN")
                                    DEFAULT.set(self.faceloginData?.data?.id, forKey: "USERID")
                                    DEFAULT.set(self.userEmailFB, forKey: "USEREMAIL")
                                    DEFAULT.set(self.faceloginData?.data?.userName, forKey: "USERNAME")
                                    self.navigationController?.pushViewController(WelcomeScreen, animated: true)
                                }
                                
                            }
                        }
                        else
                            
                        {
                            
                            
                            let WelcomeScreen = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeScreen") as! WelcomeScreen
                            
                            if let cout = self.faceloginData?.data?.tokens?.count
                            {
                                if cout>0
                                    
                                {
                                    DEFAULT.set("YES", forKey: "USERID")
                                    //  DEFAULT.set("YES", forKey: "START")
                                    DEFAULT.synchronize()
                                    DEFAULT.set(self.faceloginData?.data?.tokens?[0].apiToken, forKey: "APITOKEN")
                                    DEFAULT.set(self.faceloginData?.data?.id, forKey: "USERID")
                                    DEFAULT.set(self.userEmailFB, forKey: "USEREMAIL")
                                    DEFAULT.set(self.faceloginData?.data?.userName, forKey: "USERNAME")
                                    
                                    self.navigationController?.pushViewController(WelcomeScreen, animated: true)
                                }
                                
                            }
                        }
                        
                    }
                    else
                    {
                        NetworkEngine.commonAlert(message: self.faceloginData?.message ?? "", vc: self)
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
extension LoginViewController: ASAuthorizationControllerDelegate {
    
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
                
                let appleUserEmail = appleIDCredential.email
                print("appleId = \(appleId)")
                print("appleUserEmail = \(appleUserEmail)")
                print("appleUserFirstName = \(appleUserFirstName)")
                print("appleUserLastName = \(appleUserLastName)")
                //Write your code
                
                self.social_login_type="A"
                self.facebook_id=appleId ?? "".randomString(length: 10)
                self.userNameFB = appleUserFirstName ?? "apple"+".".randomString(length: 5)
                //            print(fullName)
                //            let givenName = user.profile.givenName
                //            let familyName = user.profile.familyName
                self.userEmailFB = appleUserEmail ?? "".randomString(length: 5)+"@privaterelay.appleid.com"
                
                // let image = user.profile.imageURL(withDimension: 120)
                
                //  self.gmailProfile = user.profile.imageURL(withDimension: 400)
                
                if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                {
                    NetworkEngine.networkEngineObj.showInterNetAlert(vc: self)
                }
                else
                {
                    self.LoginWithAppleAPI()
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

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    
    //For present window
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return self.view.window!
        
    }
    
}



extension String {
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
