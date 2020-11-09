//
//  wlcomeFour.swift
//  Dental Place
//
//  Created by eWeb on 12/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import FlagPhoneNumber
import CountryList

class wlcomeFour: UIViewController
{
    @IBOutlet weak var countryCode: UIButton!
    
    @IBOutlet weak var nexxt: UIButton!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    var countryList = CountryList()
    
    var firstName = ""
    
    var lastName = ""
    
    var gender = ""
    
    var dateOfBirth = ""
    
    var yourPhonenumber = ""
    
    
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    let phoneNumberTextField = FPNTextField()//(frame: CGRect(x: 0, y: 0, width: 50, height: 50))

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.backBtn.layer.cornerRadius = 6
       self.nexxt.layer.cornerRadius = 6
        self.backBtn.layer.borderWidth = 1
        self.backBtn.layer.borderColor = UIColor(red: 35/255.0, green: 166/255.0, blue: 152/255.0, alpha: 1).cgColor
       // phoneNumberTextField.frame = phoneTF.frame
        
       countryList.delegate = self

       // phoneNumberTextField.setFlag(key: .IN)
       // phoneNumberTextField.set(phoneNumber: "0600000001")
        
        // Or directly set the phone number with country code, which will update automatically the flag image
       // phoneNumberTextField.set(phoneNumber: "+33600000001")
        
       // phoneTF.addSubview(phoneNumberTextField)
        
       // phoneNumberTextField.displayMode = .list // .picker by default
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        phoneNumberTextField.displayMode = .list // .picker by default
              
              phoneNumberTextField.delegate = self
            listController.setup(repository: phoneNumberTextField.countryRepository)
            listController.didSelect = { [weak self] country in
                self?.phoneNumberTextField.setFlag(countryCode: country.code)
           
        }

    }
    
    
    @IBAction func selectCountryCode(_ sender: UIButton)
    {
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.red
        
        let navController = UINavigationController(rootViewController: countryList)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.red]
        navController.navigationController?.navigationBar.tintColor=UIColor.black
      //  navController.title = "Select country"
//navController.navigationController?.navigationBar.titleTextAttributes=textAttributes
      
            
               
        
    self.present(navController, animated: true, completion: nil)
          
        
//        let navigationViewController = UINavigationController(rootViewController: listController)
//        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
//       listController.navigationController?.navigationBar.titleTextAttributes=textAttributes
//
//
//        listController.title = "Select country"
//
//        self.present(navigationViewController, animated: true, completion: nil)
    }
    @IBAction func Next(_ sender: UIButton)
    {
        let code = self.countryCode.titleLabel?.text!
        
        if phoneTF.text == ""
        {
            
            NetworkEngine.commonAlert(message: "Please enter phone number.", vc: self)
            
        }
        else if code == "000"
        {
            
            NetworkEngine.commonAlert(message: "Please select country.", vc: self)
            
        }
        else
        
        {
            
            let code = (self.countryCode.titleLabel?.text! ?? "+91")
            self.yourPhonenumber = code + self.phoneTF.text!
            
            
            let CompleteWelcmProfie = self.storyboard?.instantiateViewController(withIdentifier: "CompleteWelcmProfie") as! CompleteWelcmProfie
            CompleteWelcmProfie.firstName = self.firstName
            CompleteWelcmProfie.lastName = self.lastName
            CompleteWelcmProfie.gender = self.gender
            CompleteWelcmProfie.dateOfBirth = self.dateOfBirth
            CompleteWelcmProfie.phoneNumber = self.yourPhonenumber
            self.navigationController?.pushViewController(CompleteWelcmProfie, animated: true)

        }
        
    }
    @IBAction func back(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func skip(_ sender: UIButton)
    {
        let CompleteWelcmProfie = self.storyboard?.instantiateViewController(withIdentifier: "CompleteWelcmProfie") as! CompleteWelcmProfie
        self.navigationController?.pushViewController(CompleteWelcmProfie, animated: true)
        
    }
    
}

extension wlcomeFour:CountryListDelegate {

        func selectedCountry(country: Country) {
                print(country.name)
                print(country.flag)
                print(country.countryCode)
                print(country.phoneExtension)
            let code = "+" + country.phoneExtension
            self.countryCode.setTitle(code, for: .normal)
        }
}

extension wlcomeFour: FPNTextFieldDelegate {
    
    /// The place to present/push the listController if you choosen displayMode = .list
    func fpnDisplayCountryList() {
        let navigationViewController = UINavigationController(rootViewController: listController)
        
        present(navigationViewController, animated: true, completion: nil)
    }
    
    /// Lets you know when a country is selected
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code) // Output "France", "+33", "FR"
        
        self.countryCode.setTitle(dialCode, for: .normal)
        
    }
    
    /// Lets you know when the phone number is valid or not. Once a phone number is valid, you can get it in severals formats (E164, International, National, RFC3966)
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            // Do something...
    textField.getFormattedPhoneNumber(format: .E164)//,           // Output "+33600000001"
            //textField.getFormattedPhoneNumber(format: .International),  // Output "+33 6 00 00 00 01"
            //textField.getFormattedPhoneNumber(format: .National),       // Output "06 00 00 00 01"
            //textField.getFormattedPhoneNumber(format: .RFC3966),        // Output "tel:+33-6-00-00-00-01"
            textField.getRawPhoneNumber()                               // Output "600000001"
        } else {
            // Do something...
        }
    }
}
