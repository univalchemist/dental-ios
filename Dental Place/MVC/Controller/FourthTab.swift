//
//  FourthTab.swift
//  Dental Place
//
//  Created by eWeb on 13/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SDWebImage
import SVProgressHUD
import Alamofire
import Letters
class FourthTab: UIViewController,UITextFieldDelegate
{
    var pickedImageProduct = UIImage()
    var imagePicker = UIImagePickerController()
    var choosenImage:UIImage!
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var genderImage: UIImageView!
    
    var selectedDate = ""
    
    var phone = ""

    var zipcode = ""
    
    var Longitude = ""
    
    var Latitude = ""
    
    var city = ""
    
    var country = ""
  
    
     var ViewProfileData:ViewProfileModel?
var ForgotModelData:LogoutModel?
    
    @IBOutlet weak var userNameTxt: UITextField!
    
    @IBOutlet weak var profileImg: UIImageView!
    
    
    
    @IBOutlet weak var emailTxt: UITextField!
    
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var genderTxt: UITextField!
    @IBOutlet weak var locationTxt: UITextField!
    @IBOutlet weak var dateOfBirthTxt: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.showDatePicker()
        self.userNameTxt.delegate=self
        
        
        self.saveBtn.isHidden=true
        self.emailTxt.isEnabled = false
        self.dateOfBirthTxt.isEnabled = false
        self.genderTxt.isEnabled = false
        self.passwordTxt.isEnabled = false

        self.locationTxt.isEnabled = false

        self.saveBtn.isHidden=true

        
        self.profileImg.layer.cornerRadius = self.profileImg.frame.height/2
       self.profileImg.clipsToBounds = true
        
        if let url2 = DEFAULT.value(forKey: "FBPictureUrl") as? String
        {
            let url = URL(string: url2)
           // self.profileImg?.sd_setImage(with: url, completed: nil)
            self.profileImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
        }
        
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.ProfilePageRefreshNoti), name: Notification.Name("ProfilePageRefreshNoti"), object: nil)
    }
    
    @objc func ProfilePageRefreshNoti()
    {
        self.navigationController?.popViewController(animated: true)
        DEFAULT.removeObject(forKey: "THIRD")
        DEFAULT.synchronize()
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.ViewProfileAPI()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
        if DEFAULT.value(forKey: "THIRD") != nil
        {
            DEFAULT.removeObject(forKey: "THIRD")
            DEFAULT.synchronize()
            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
            {
                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
            }
            else
            {
                self.ViewProfileAPI()
            }

        }

        
        IQKeyboardManager.shared.enableAutoToolbar = false
        // IQKeyboardManager.shared.sh = false
        //IQKeyboardManager.shared.shouldHidePreviousNext = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        IQKeyboardManager.shared.enableAutoToolbar = true
        //  IQKeyboardManager.shared.shouldShowTextFieldPlaceholder = true
        //  IQKeyboardManager.shared.shouldHidePreviousNext = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
//        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
//        {
//            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
//        }
//        else
//        {
//            self.EditProfileApiCall()
//            self.ViewProfileAPI()
//        }

        print("viewDidDisappear call")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.saveBtn.isHidden=false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        self.hidesBottomBarWhenPushed = true
    }

    @IBAction func logOutAct(_ sender: UIButton)
    {
        
            
        
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.LogoutAPI()
        }
    }
    
    @IBAction func editProfilePic(_ sender: Any)
    {
    
    // MARK:- Choose Image method
    
    let actionSheet = UIAlertController(title: "Add photo !", message: nil, preferredStyle: UIAlertController.Style.alert)
    actionSheet.view.tintColor = UIColor.black
    
    let camera1 =  UIAlertAction(title: "Take Photo", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
        self.openCamera()
    })
    camera1.setValue(0, forKey: "titleTextAlignment")
    
    let camera2 =  UIAlertAction(title: "Choose from Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
        self.openGallary()
    })
    camera2.setValue(0, forKey: "titleTextAlignment")
    
    let camera3 =  UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
        
    })
    camera3.setValue(0, forKey: "titleTextAlignment")
    
    // Add the actions
    imagePicker.delegate = self
    imagePicker.isEditing = true
    imagePicker.allowsEditing = true
    
    actionSheet.addAction(camera1)
    actionSheet.addAction(camera2)
    actionSheet.addAction(camera3)
    self.present(actionSheet, animated: true, completion: {() -> Void in
    
    actionSheet.view.superview?.isUserInteractionEnabled = true
    actionSheet.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertClose)))
    })
    
    
    
}

@objc func alertClose(gesture: UITapGestureRecognizer)
{
    self.dismiss(animated: true, completion: nil)
}

//MARK:- Choose image end ---------------------------------

func openCamera()
{
    if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        imagePicker.delegate = self
        imagePicker.isEditing = true
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    else
    {
        let alertWarning = UIAlertView(title:"Alert!", message: "You don't have camera", delegate:nil, cancelButtonTitle:"Ok")
        alertWarning.show()
    }
}
func openGallary()
{
    
    
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = .photoLibrary
    present(picker, animated: true, completion: nil)
    
    //        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
    //        imagePicker.delegate = self
    //        imagePicker.isEditing = true
    //        imagePicker.allowsEditing = true
    //        self.present(imagePicker, animated: true, completion: nil)
    
}
    
    @IBAction func emailEdit(_ sender: Any)
    {
        self.saveBtn.isHidden=false

        self.emailTxt.isEnabled = true
        self.emailTxt.becomeFirstResponder()

        
    }
    @IBAction func passwordEdit(_ sender: Any)
    {
        
        
        
        let vc = storyboard?.instantiateViewController(withIdentifier:"ChangePasswordViewController") as! ChangePasswordViewController
        self.navigationController?.pushViewController(vc,animated:true)

        
//       self.saveBtn.isHidden=false
//        self.passwordTxt.isEnabled = true
//        self.passwordTxt.isSecureTextEntry = false
//        self.passwordTxt.becomeFirstResponder()
    }
    @IBAction func locationEdit(_ sender: Any)
    {
        
self.saveBtn.isHidden=false
       self.locationTxt.isEnabled = true
        self.locationTxt.becomeFirstResponder()
    }
    
    @IBAction func genderedit(_ sender: Any)
    {
        self.saveBtn.isHidden=false
        self.genderTxt.isEnabled = true
        self.genderTxt.becomeFirstResponder()

        let alert = UIAlertController(title: "Select gender!", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Male", style: .default , handler:{ (UIAlertAction)in
            print("Male")
            self.genderTxt.text = "Male"
            self.genderTxt.resignFirstResponder()
            
              self.genderImage.image=UIImage(named:"male-24")
            
        }))
        
        alert.addAction(UIAlertAction(title: "Female", style: .default , handler:{ (UIAlertAction)in
            print("female")
             self.genderTxt.text = "Female"
            self.genderTxt.resignFirstResponder()
            self.genderImage.image=UIImage(named:"female-24")

        }))
    
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("cancel")
            self.genderTxt.resignFirstResponder()

        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    @IBAction func dateOfBirthEdit(_ sender: Any)
    {
        self.saveBtn.isHidden=false
        self.dateOfBirthTxt.isEnabled = true
        self.dateOfBirthTxt.becomeFirstResponder()
    }
    @IBAction func notificationAction(_ sender: Any)
    {
let vc = self.storyboard?.instantiateViewController(withIdentifier: "StaticViewController") as! StaticViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
       @IBAction func privacyAction(_ sender: Any)
        {
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "StaticViewController") as! StaticViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    
    func showDatePicker()
    {
        
        datePicker.datePickerMode = .date
        
        
        datePicker.backgroundColor = UIColor.white
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -17, to: Date())
        
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        
        self.view.addGestureRecognizer(tapGesture)
        
        
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(WelcmThree.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(WelcmThree
            .cancelDatePicker))
        // toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        // DateText.inputAccessoryView = toolbar
        dateOfBirthTxt.inputView = datePicker
    }
    
    
    @objc func viewTapped()
    {
        self.view.endEditing(true)
    }
    
    
    
    @objc func dateChange()
    {
        
        let formatter = DateFormatter()
        //formatter.dateFormat = "dd/MM/yyyy"
        formatter.dateFormat = "MMMM d yyyy"
        
        formatter.dateFormat = "MMMM d, yyyy"
        
        var dateSelected = formatter.string(from: datePicker.date)
        self.selectedDate = dateSelected
        dateOfBirthTxt.text! = self.selectedDate //self.convertDateFormater(dateSelected)
        dateOfBirthTxt.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        //formatter.dateFormat = "dd/MM/yyyy"
        formatter.dateFormat = "MMMM d yyyy"
        
        formatter.dateFormat = "MMMM d yyyy"
        
        var dateSelected = formatter.string(from: datePicker.date)
        self.selectedDate = dateSelected
        dateOfBirthTxt.text! = self.selectedDate //self.convertDateFormater(dateSelected)
        
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        
        self.view.endEditing(true)
    }
    
    @IBAction func notiAction(_ sender: UISwitch)
    {
        if sender.isOn
        {
            
            DEFAULT.removeObject(forKey: "NOTION")
        }
        else
        {
            DEFAULT.setValue("yes", forKey: "NOTION")
        }
        DEFAULT.synchronize()
    }
    
    @IBAction func saveProfile(_ sender: Any)
    {
        self.userNameTxt.resignFirstResponder()
        self.saveBtn.isHidden=true
        let fullName = userNameTxt.text!
               let fullNameArr = fullName.components(separatedBy: " ")

       var name = ""
              var surname = ""

        var components = fullName.components(separatedBy: " ")
        if components.count > 0 {
         let firstName = components.removeFirst()
         let lastName = components.joined(separator: " ")
         debugPrint(firstName)
            name=firstName
            surname=lastName
            
         debugPrint(lastName)
        }
        if surname==""
        {
              
                NetworkEngine.commonAlert(message: "Please enter last name.", vc: self)
                
            
        }
        else
        {
            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
            {
                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
            }
            else
            {
                self.EditProfileApiCall()
            }

        }
        
            }
}
extension FourthTab: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        self.saveBtn.isHidden=false

        
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        {
        self.profileImg.image = image
        }
        else
        {
           let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
            self.profileImg.image = image

        }
        self.saveBtn.isHidden=false
        picker.dismiss(animated: true, completion: nil)
        
    
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- Api work

extension FourthTab
{
    
    
    func ViewProfileAPI()
    {
        
        
        var newuserEmail = "test@gmail.com"
        if let newuserEmail1 = DEFAULT.value(forKey: "USEREMAIL") as? String
        {
            newuserEmail = "\(newuserEmail1)"
        }
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
        
        ApiHandler.ModelApiGetMethod(url: VIEWPROFILELAPI , Header: header) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    if response != nil
                    {
                        self.ViewProfileData = try decoder.decode(ViewProfileModel.self, from: response!)

                    }
                    //self.view.makeToast(self.loginData?.message)
                    
                    
                    if self.ViewProfileData?.statusCode == "200"
                        
                    {
                        
                        if let mail = self.ViewProfileData?.data?.userEmail
                        {
                           self.emailTxt.text = mail
                        }
                        else
                        {
                            if let fc=DEFAULT.value(forKey: "USEREMAIL") as? String
                            {
                                self.emailTxt.text=fc
                            }
                            
                        }
                        
                        let name1=self.ViewProfileData?.data?.userName ?? ""
                        let name2=self.ViewProfileData?.data?.last_name ?? ""

        self.userNameTxt.text = name1 + " " + name2
                        
                        
                        self.locationTxt.text = self.ViewProfileData?.data?.userDetail?.address
                        self.genderTxt.text = self.ViewProfileData?.data?.userDetail?.gender
                        let userId = self.ViewProfileData?.data?.userDetail?.userid
                        self.zipcode=self.ViewProfileData?.data?.userDetail?.zipcode ?? "3123"
                        DEFAULT.set(userId, forKey: "USERID")
                        
                        if self.genderTxt.text! == ""
                        {
                           let userdateofbirth = DEFAULT.value(forKey: "GENDER") as? String ?? "Male"
                            if userdateofbirth == "male" || userdateofbirth == "Male"
                            {
                                 self.genderTxt.text = "Male"
                            }
                            else
                            {
                               self.genderTxt.text = "Female"
                            }
                          
                            
                        }
                        
                        
                        if self.genderTxt.text?.lowercased() == "male" || self.genderTxt.text?.lowercased() == "Male"
                        {
                            self.genderImage.image=UIImage(named:"male-24")
                        }
                        else
                            //if self.genderTxt.text?.lowercased() == "female"

                        {
                               self.genderImage.image=UIImage(named:"female-24") //
                        }
//
                        
                        self.dateOfBirthTxt.text = self.ViewProfileData?.data?.userDetail?.dob
                        
                                 if self.dateOfBirthTxt.text! == ""
                                {
                                    let userdateofbirth = DEFAULT.value(forKey: "DATEOFBIRTH") as? String ?? "April 11, 1995"
                                        self.dateOfBirthTxt.text = userdateofbirth
                                    }
                        self.phone = self.ViewProfileData?.data?.userDetail?.contact ?? ""
                        self.phone = self.ViewProfileData?.data?.userDetail?.contact ?? ""
                        self.Longitude = self.ViewProfileData?.data?.userDetail?.longitude ?? ""
                        self.Latitude = self.ViewProfileData?.data?.userDetail?.latitude ?? ""
                        self.city = self.ViewProfileData?.data?.userDetail?.city ?? ""
                        self.country = self.ViewProfileData?.data?.userDetail?.country ?? ""
                        DEFAULT.set(self.userNameTxt.text!, forKey: "USERNAME")
                        
//                                             DEFAULT.removeObject(forKey: "name")
//                                                       DEFAULT.removeObject(forKey: "picture")
//                                                       DEFAULT.removeObject(forKey: "first_name")
//                                                       DEFAULT.removeObject(forKey: "last_name")
//                                                       DEFAULT.removeObject(forKey: "email")
                        DEFAULT.synchronize()
                        
                        
                        if let url2 = self.ViewProfileData?.data?.profile_image as? String
                        {
                            let fullurl = url2
                            
                            
                            print("Image full url \(fullurl)")
                            if fullurl != ""
                            {
                                let url = URL(string: fullurl)!
                              self.profileImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
                                DEFAULT.set(url2, forKey: "USERPROFILE")
                                DEFAULT.synchronize()
                                
        

                            }
                            else
                            {
                                let attrs = [
                                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28),
                                    NSAttributedString.Key.foregroundColor: UIColor.white
                                ]
                                
                                self.profileImg.setImage(string: self.userNameTxt.text!, color: PROFILECOLOL, circular: true, textAttributes:attrs)
                            }
                            
                        
                          
                            
                        }
                        else
                        
                        {
                            if let url2 = DEFAULT.value(forKey: "FBPictureUrl") as? String
                            {
                                let url = URL(string: url2)
                                DEFAULT.set(url2, forKey: "USERPROFILE")
                                DEFAULT.synchronize()
                               // self.profileImg?.sd_setImage(with: url, completed: nil)
                                self.profileImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
                            }
                            else
                            {
                                let attrs = [
                                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28),
                                    NSAttributedString.Key.foregroundColor: UIColor.white
                                ]
                                
                                self.profileImg.setImage(string: self.userNameTxt.text!, color: PROFILECOLOL, circular: true, textAttributes:attrs)
                            }
                        }
                    }
                    else
                    {
                        NetworkEngine.commonAlert(message: self.ViewProfileData?.message ?? "", vc: self)
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
    
    func EditProfileApiCall()
    {
        SVProgressHUD.show()
        
        var USERID = "66"
        if  let id = DEFAULT.value(forKey: "USERID") as? String
        {
            USERID = id
        }
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
        
        let Header = ["device-id":DEVICETOKEN,"device-type":"iOS","api-token":apiKey] as [String:String]
        
        let fullName = userNameTxt.text!
       // let fullNameArr = fullName.components(separatedBy: " ")

        var name = ""
        var surname = ""
//        if fullNameArr.count>0
//        {
//          name = fullNameArr[0]
//
//            if fullNameArr.count>1
//            {
//                surname = fullNameArr[1]
//            }
//        }
         var components = fullName.components(separatedBy: " ")
                if components.count > 0 {
                 let firstName = components.removeFirst()
                 let lastName = components.joined(separator: " ")
                 debugPrint(firstName)
                    name=firstName
                    surname=lastName
                 debugPrint(lastName)
                }
        
                
        
        let para = ["name" : name,
                     "last_name":surname,
                    "gender":genderTxt.text!,
                    "dob":dateOfBirthTxt.text!,
                    "phone":self.phone,
                    "email":emailTxt.text!,
                    "address":locationTxt.text!,
                    "zipcode":self.zipcode,
                 "Longitude":self.Longitude,
                "Latitude":self.Latitude,
                  "city":self.city,
                   "country":self.country]   as? [String : String]
        
        print(para)
        print(BASEURL+"update-profile")


        Alamofire.upload(multipartFormData: { multipartFormData in
            //Parameter for Upload files
            guard let imgData1 = ( self.profileImg.image as! UIImage).jpegData(compressionQuality: 0.1) else{return}
            multipartFormData.append(imgData1, withName: "profile_image", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            
            for (key, value) in para!//!
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }

            
        }, usingThreshold:UInt64.init(),
           to: BASEURL+"update-profile", //URL Here
            method: .post,
            headers: Header, //pass header dictionary here
            encodingCompletion: { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    print("the status code is :")
                    SVProgressHUD.dismiss()

                    upload.uploadProgress(closure: { (progress) in
                        print("something")
                        if progress.isFinished
                        {
                            self.saveBtn.isHidden=true
                           // self.ViewProfileAPI()
                            SVProgressHUD.dismiss()
                        }
                        else{
                            SVProgressHUD.show()
                        }
                    })
                    
                    upload.responseJSON { response in
                        print("the resopnse code is : \(response)")
                        print("the response is : \(response)")
                        if let dict = response as? [String:Any]
                        {
                            
                        }
                    }
                    break
                case .failure(let encodingError):
                    SVProgressHUD.dismiss()
                    print("the error is  : \(encodingError.localizedDescription)")
                    break
                }
        })




        /*
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if self.profileImg.image != nil
            {
     
                guard let imgData1 = ( self.profileImg.image as! UIImage).jpegData(compressionQuality: 0.1) else{return}
                multipartFormData.append(imgData1, withName: "profile_image", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            for (key, value) in para!
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to:BASEURL+"update-profile") ,headers:Header,
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    
                })
                
                upload.responseJSON { response in
                    
                    if let JSON = response.result.value! as? NSDictionary
                    {
                        print(JSON)
                        
                        SVProgressHUD.dismiss()
                    }
                }
                
                break
                
            case .failure(let encodingError):
                break
                print(encodingError)
                
            }
        }
        */
    }
    
    
    func LogoutAPI()
    {
        
        
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
        
        ApiHandler.ModelApiPostMethod(url: LOGOUTAPI, parameters: ["" : ""] , Header: header) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.ForgotModelData = try decoder.decode(LogoutModel.self, from: response!)
    
                    
                    if self.ForgotModelData?.code == "201"
                        
                    {
                        DEFAULT.removeObject(forKey: "USERID")
                        DEFAULT.removeObject(forKey: "USEREMAIL")
                         DEFAULT.removeObject(forKey: "FBPictureUrl")
                        DEFAULT.removeObject(forKey: "START")
                        DEFAULT.removeObject(forKey: "APITOKEN")
                        DEFAULT.removeObject(forKey: "first_name")
                        DEFAULT.removeObject(forKey: "last_name")
                        
                        DEFAULT.removeObject(forKey: "CategorySelected")
                        DEFAULT.removeObject(forKey: "SELECTEDFILTER")
                        DEFAULT.removeObject(forKey: "minimum")
                        DEFAULT.removeObject(forKey: "maximum")
                        
                        
                        DEFAULT.synchronize()
                        self.view.makeToast(self.ForgotModelData?.message)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0)
                        {
                            APPDEL.loadLoginView()
                        };
                        

                    }
                    else
                    {
                        NetworkEngine.commonAlert(message: self.ForgotModelData?.message ?? "", vc: self)
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




// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
