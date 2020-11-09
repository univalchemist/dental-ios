//
//  CompleteWelcmProfie.swift
//  Dental Place
//
//  Created by eWeb on 12/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CompleteWelcmProfie: UIViewController
{
    // For location
    let manager = CLLocationManager()
    @IBOutlet weak var searchBtn: UIButton!

    @IBOutlet weak var findBtn: UIButton!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var txt1: UITextField!
    @IBOutlet weak var zipcodeTF: UITextField!
    @IBOutlet weak var addresslineTF: UITextField!
    
    
    //MARK:-  Api variable
    
    var firstName = ""
    var lastName = ""
    var gender = ""
    var dateOfBirth = ""
    var phoneNumber = ""
    var address1 = ""
    var zipCode = ""
    var loginData:LoginModel?
    
    
    
    
    
    //MARK:- Location
    
    var useLocation = ""
    
    var userLat = ""
    var userLong = ""
    var userCity = ""
    var userState = ""
    var userCountry = ""
    var userLocation = ""
    var currentLat = ""
    var currentLong = ""
    var age = ""
    var coutry = ""
    var selectedLocation = ""
    var country_code = ""
    var state = ""
    var city = ""

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let attributedString = NSAttributedString(string: NSLocalizedString("Find Address", comment: ""), attributes:[
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20.0),
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.underlineStyle:1.0
        ])
        
        self.findBtn.setAttributedTitle(attributedString, for: .normal)
        searchBtn.layer.cornerRadius = 5
       txt1.attributedPlaceholder = NSAttributedString(string: "Address line 1", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 151/255, green: 216/255, blue: 214/255, alpha: 1)])
        txt2.attributedPlaceholder = NSAttributedString(string: "Zipcode", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 151/255, green: 216/255, blue: 214/255, alpha: 1)])
        
        print("First name = \(firstName)")
        print("last name = \(lastName)")
        print("gender name = \(gender)")
        print("date of birtth  = \(dateOfBirth)")
        print("phone number = \(phoneNumber)")
        
        
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }
    @IBAction func FindAct(_ sender: UIButton)
    {
        self.addresslineTF.text = self.selectedLocation
        self.zipcodeTF.text = self.zipCode
        
    }
    
    @IBAction func searchAct(_ sender: UIButton)
    {
        if addresslineTF.text == ""
        {
            
            NetworkEngine.commonAlert(message: "Please enter valid address.", vc: self)
            
        }
        else if zipcodeTF.text == ""
        {
            NetworkEngine.commonAlert(message: "Please enter zipcode.", vc: self)
            
        }
        
        else
        {
            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
            {
                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
            }
            else
            {
                self.CompleteProfileAPI()
            }

        }

        
     }
}
//MARK:- Api work

extension CompleteWelcmProfie
{
    //MARK:- Login With Email Api
    
    func CompleteProfileAPI()
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
        let GENDER = DEFAULT.value(forKey: "GENDER") as? String ?? "Male"
        let userdateofbirth = DEFAULT.value(forKey: "DATEOFBIRTH") as? String ?? dateOfBirth
        
        var DEVICETOKEN = "123456"
        if let device = DEFAULT.value(forKey: "DEVICETOKEN") as? String
        {
            DEVICETOKEN = device
        }
        let header = ["device-id":DEVICETOKEN,"device-type":"iOS","type":"iOS","api-token":apiKey] as [String:String]
        
        let params = ["name" : firstName,
                      "last_name" : lastName,
                      "gender" : GENDER,
                      "dob" : userdateofbirth,
                      "phone" : phoneNumber,
                      "email" : newuserEmail,
                      "address" : addresslineTF.text!,
                      "zipcode" : zipcodeTF.text!,
                      "Longitude" : self.currentLong ,
                      "Latitude" : self.currentLat ,
                      "country" : self.coutry,
                      "city" : self.city]   as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: COMPLETEPROFILERAPI, parameters: params, Header: header) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    if response == nil
                    {
                    }
                    else
                    {
                         self.loginData = try decoder.decode(LoginModel.self, from: response!)
                        if self.loginData?.statusCode == "200"
                            
                        {
                            let WelcomeScreen = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
                            DEFAULT.set("YES", forKey: "USERID")
                            DEFAULT.set("YES", forKey: "START")
                            DEFAULT.synchronize()
                            
                            self.navigationController?.pushViewController(WelcomeScreen, animated: true)
                            
                        }
                        else
                        {
                           // NetworkEngine.commonAlert(message: self.loginData?.message ?? "", vc: self)
                            
                            let alert=UIAlertController(title: "Alert!", message: self.loginData?.message ?? "", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                                
                            }))
                    self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                   
            
//                    if self.loginData?.statusCode == "200"
//
//                    {
//                        let WelcomeScreen = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
//                        DEFAULT.set("YES", forKey: "USERID")
//                        DEFAULT.set("YES", forKey: "START")
//                        DEFAULT.synchronize()
//
//                        self.navigationController?.pushViewController(WelcomeScreen, animated: true)
//
//                    }
//                    else
//                    {
//                        NetworkEngine.commonAlert(message: self.loginData?.message ?? "", vc: self)
//                    }
//
//
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

//MARK:- location work

extension CompleteWelcmProfie:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let _ :CLLocation = locations[0] as CLLocation
        
        if let lastLocation = locations.last
        {
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(lastLocation) { [weak self] (placemarks, error) in
                if error == nil
                {
                    if let firstLocation = placemarks?[0],
                        let cityName = firstLocation.locality,   // locality
                        let stateName = firstLocation.subLocality,
                        let nationality = firstLocation.administrativeArea,
                        let latitude = firstLocation.location?.coordinate.latitude,
                        let longitude = firstLocation.location?.coordinate.longitude
                    {
                        print(firstLocation)
                        
                        print(cityName + stateName + nationality)
                        
                        let address = stateName + " , " + cityName + " , " + nationality
                        CURRENTLOCATIONLONG=longitude
                        CURRENTLOCATIONLAT=latitude
                        

                        self?.selectedLocation = address
                        self?.coutry = firstLocation.country!
                        self?.zipCode = firstLocation.postalCode!
                        self?.city = cityName
                        self?.state = stateName
                        self?.country_code = firstLocation.isoCountryCode ?? "IND"
                        print("Address =  \(address)")
                        self?.userLocation = address
                        
                        self?.currentLong = "\(longitude)"
                        self?.currentLat = "\(latitude)"
                        CURRENTLOCATIONLAT = latitude
                        CURRENTLOCATIONLONG = longitude
                        
                        DEFAULT.set("\(latitude)", forKey: "CURRENTLAT")
                        DEFAULT.set("\(longitude)", forKey: "CURRENTLONG")
                        //  self?.CompanyLocationTF.text! = address
                        self?.manager.stopUpdatingLocation()
                        
                    }
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error)
    }
    
}

