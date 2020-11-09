//
//  DetailsViewController.swift
//  Dental Place
//
//  Created by eWeb on 19/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import SVProgressHUD
import FloatRatingView
import MapKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    var yelpReviewArray=NSMutableArray()
    var yelp_id = ""
    var allMarkerArray = NSMutableArray()
    @IBOutlet weak var allcommentTable: UITableView!
    var datedelegate:datePopUpDataProtocol? = nil
    var cellData = NSDictionary()
    //MARK:- variable
    var clinicId = ""
    
    var selectedService = -1
    
    var serviceId = ""
    var serviceName = ""
    var servicePrice = ""
    var time = ""
    var appoinment_date = ""
    
    
    
    
    @IBOutlet weak var mainview: UIView!
    @IBOutlet weak var bookAppBtn: UIButton!
    @IBOutlet weak var ratingV: FloatRatingView!
    
    @IBOutlet weak var ratingNumber: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var ratingLbl: UIButton!
    @IBOutlet weak var closeLbl: UILabel!
    @IBOutlet weak var openlbl: UILabel!
    @IBOutlet weak var locLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    var Mycoordinate = CLLocation(latitude: CURRENTLOCATIONLAT, longitude: CURRENTLOCATIONLONG)
    var locationManager = CLLocationManager()
    var currentLat = ""
    var currentLong = ""
    
    var  vendor_metaDict=NSDictionary()
    
    
    let yourAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.init(red: 106/255, green: 134/255, blue: 165/255, alpha: 1),
        .underlineStyle: NSUnderlineStyle.single.rawValue]
    var venueLat:NSString = ""
    var venueLng:NSString  = ""
    var venueAddress:String  = ""
    var venderServiceArray=NSArray()
    
    var closeOpenStatus="Closed"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        allcommentTable.rowHeight=100
        allcommentTable.estimatedRowHeight=UITableView.automaticDimension
        allcommentTable.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
        
        ratingV.isUserInteractionEnabled=false
        
    }
    
    @IBAction func goback(_ sender: Any)
    {
        DEFAULT.set("Yes", forKey: "DetailBack")
        DEFAULT.synchronize()
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func SeeDirectionBtnAct(_ sender: Any)
    {
        
        
        
        if let vendor_meta=self.cellData.value(forKey: "vendor_meta") as? NSArray
        {
            if vendor_meta.count>0
            {
                let service2=vendor_meta.object(at: 0) as!NSDictionary
                if let Latitude=service2.value(forKey: "Latitude") as? String
                {
                    
                    
                    if let Longitude=service2.value(forKey: "Longitude") as? String
                    {
                        //   vc.destLat=Latitude as String
                        // vc.destLong=Longitude as String
                        
                        self.venueLat=Latitude as NSString
                        self.venueLng=Longitude as NSString
                        self.venueAddress=service2.value(forKey: "address1") as? String ?? "India"
                        
                        self.openMapForPlace()
                    }
                }
            }
        }
        
        
    }
    
    func openMapForPlace() {
        
        let lat1 : NSString = self.venueLat as NSString
        let lng1 : NSString = self.venueLng as NSString
        
        let latitude:CLLocationDegrees =  lat1.doubleValue
        let longitude:CLLocationDegrees =  lng1.doubleValue
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.venueAddress
        mapItem.openInMaps(launchOptions: options)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
        return self.venderServiceArray.count
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell") as! DetailTableViewCell
        cell.bckView.backgroundColor = UIColor.init(red: 231/255, green: 251/255, blue: 249/255, alpha: 1)
        
        cell.selectBtn.tag=indexPath.row
        
        cell.selectBtn.addTarget(self, action: #selector(selectAction), for: .touchUpInside)
        
        let dict=self.venderServiceArray.object(at: indexPath.row) as! NSDictionary
        
        
        if self.selectedService == -1
        {
            if let serviceName1=dict.value(forKey: "serviceName") as? String
            {
                cell.title.text = serviceName1
                let serviceName2 = DEFAULT.value(forKey: "CategoryName") as? String ?? ""
                
                
                if serviceName1.lowercased()==serviceName2.lowercased()
                    
                {
                    cell.title.textColor = UIColor.black
                    //  cell.title.text = "Root Canal"
                    cell.title.font = UIFont(name: "FiraSans-Bold", size: 21)
                    // cell.priceLbl.text = "€100"
                    cell.bckView.backgroundColor = UIColor.init(red: 231/255, green: 251/255, blue: 249/255, alpha: 1)
                    cell.bckView.layer.borderWidth = 1
                    cell.bckView.layer.borderColor = APPCOLOL.cgColor
                    
                    let servicesId = dict.value(forKey: "servicesId") as? String ?? ""
                    let servicePrice = dict.value(forKey: "servicePrice") as? String ?? ""
                    self.servicePrice=servicePrice
                    self.serviceId=servicesId
                    self.serviceName=serviceName1
                    
                }
                else
                    
                {
                    cell.title.textColor = APPTEXTCOLOL
                    cell.bckView.backgroundColor = UIColor.white
                    cell.bckView.layer.borderWidth = 1
                    cell.title.font = UIFont(name: "FiraSans-Regular", size: 21)
                    cell.bckView.layer.borderColor = UIColor.lightGray.cgColor
                }
                
            }
            else
            {
                cell.title.textColor = APPTEXTCOLOL
                cell.bckView.backgroundColor = UIColor.white
                cell.bckView.layer.borderWidth = 1
                cell.title.font = UIFont(name: "FiraSans-Regular", size: 21)
                cell.bckView.layer.borderColor = UIColor.lightGray.cgColor
                
            }
        }
        else
            
        {
            if self.selectedService == indexPath.row
            {
                cell.title.textColor = UIColor.black
                //  cell.title.text = "Root Canal"
                cell.title.font = UIFont(name: "FiraSans-Bold", size: 21)
                // cell.priceLbl.text = "€100"
                cell.bckView.backgroundColor = UIColor.init(red: 231/255, green: 251/255, blue: 249/255, alpha: 1)
                cell.bckView.layer.borderWidth = 1
                cell.bckView.layer.borderColor = APPCOLOL.cgColor
                let dict2=self.venderServiceArray.object(at: indexPath.row) as! NSDictionary
                let servicesId = dict2.value(forKey: "servicesId") as? String ?? ""
                let serviceName = dict2.value(forKey: "serviceName") as? String ?? ""
                let servicePrice = dict2.value(forKey: "servicePrice") as? String ?? ""
                self.servicePrice=servicePrice
                self.serviceId=servicesId
                self.serviceName=serviceName
            }
            else
                
            {
                cell.title.textColor = APPTEXTCOLOL
                cell.bckView.backgroundColor = UIColor.white
                cell.bckView.layer.borderWidth = 1
                cell.title.font = UIFont(name: "FiraSans-Regular", size: 21)
                cell.bckView.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
        
        
        if let servicePrice=dict.value(forKey: "servicePrice") as? String
        {
            
            cell.priceLbl.text = "$" + servicePrice
        }
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension//80
    }
    
    @objc func selectAction(_ sender:UIButton)
    {
        self.selectedService = sender.tag
        self.allcommentTable.reloadData()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.CategoryDetailsAPI()
            
        }
        
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func TimeTableAction(_ sender:UIButton)
    {
        
        
        
        print(self.vendor_metaDict)
        let contentCV = self.storyboard?.instantiateViewController(withIdentifier: "TimeTableViewController") as! TimeTableViewController
        
        contentCV.modalPresentationStyle = UIModalPresentationStyle.popover // 13
        let popPC = contentCV.popoverPresentationController // 14
        contentCV.vendor_metaDict=self.vendor_metaDict
        
        popPC?.backgroundColor = UIColor.white
        
        contentCV.preferredContentSize = CGSize(width:SCREENWIDTH-30,height:300)
        contentCV.popoverPresentationController?.sourceRect =  (sender as! UIButton).bounds
        contentCV.popoverPresentationController?.sourceView = sender as? UIButton // button
        popPC?.delegate = self // 18
        present(contentCV, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func BookAppoitmentAction(_ sender:UIButton)
    {
        
        
        
        print(self.vendor_metaDict)
        let popUpVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePopupViewController") as! DatePopupViewController
        //Don't forget initialize protocal deletage
        // EditOrDelete = "Delete"
        //  popUpVc.from = "Delete"
        popUpVc.delegate = self
        self.addChild(popUpVc)
        popUpVc.view.frame = self.view.frame
        self.view.addSubview(popUpVc.view)
        popUpVc.didMove(toParent: self)
        
        
        //            let contentCV = self.storyboard?.instantiateViewController(withIdentifier: "DatePopupViewController") as! DatePopupViewController
        //
        //                 contentCV.modalPresentationStyle = UIModalPresentationStyle.popover // 13
        //                 let popPC = contentCV.popoverPresentationController // 14
        ////           contentCV.vendor_metaDict=self.vendor_metaDict
        //
        //                  popPC?.backgroundColor = UIColor.white
        //        contentCV.delegate=self
        //                 contentCV.preferredContentSize = CGSize(width:SCREENWIDTH-16,height:400)
        //                 contentCV.popoverPresentationController?.sourceRect =  (sender as! UIButton).bounds
        //                 contentCV.popoverPresentationController?.sourceView = sender as? UIButton // button
        //                 popPC?.delegate = self // 18
        //                 present(contentCV, animated: true, completion: nil)
        //
        //
        
    }
    
    
}
extension DetailsViewController:CLLocationManagerDelegate
{
    // MARK: CLLocation Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        let location = locations.last
        let lat = (location?.coordinate.latitude)!
        let long = (location?.coordinate.longitude)!
        CURRENTLOCATIONLONG=long
        CURRENTLOCATIONLAT=lat
        self.currentLat = "\((location?.coordinate.latitude)!)"
        self.currentLong = "\((location?.coordinate.longitude)!)"
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        self.Mycoordinate = CLLocation(latitude: lat, longitude: long)
        //self.myMapView.animate(to: camera)
        
        // showPartyMarkers(lat: lat, long: long)
    }
    func  isOpenClinic(OpenTime:String) -> Bool
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let now1 = Date()
        
        let enteredDate = dateFormatter.date(from: OpenTime)!
        
        
        let now2 = dateFormatter.string(from: now1)
        let now = dateFormatter.date(from: now2)!
        
        //        let dateFormatter2 = DateFormatter()
        //        dateFormatter2.dateFormat = "HH:mm"
        //
        //        let now3 = dateFormatter2.string(from: now)
        //         let enteredDate3 = dateFormatter2.string(from: enteredDate)
        //
        //        let now4 = dateFormatter2.date(from: now3)!
        //        let enteredDate4 = dateFormatter2.date(from: enteredDate3)!
        //
        //
        //        print("24 hrs format = \(now3) ===  \(enteredDate3)")
        //
        let endOfMonth = Calendar.current.date(byAdding: .minute, value: 0, to: enteredDate)!
        
        if endOfMonth.compare(now) == ComparisonResult.orderedDescending
        {
            print("orderedDescending")
            return false
        }
        else  if endOfMonth.compare(now) == ComparisonResult.orderedAscending
        {
            print("orderedAscending")
            return true
        }
        else
            
        {
            print("equal")
            return false
        }
    }
    func  isClosedClinic(closetime:String) -> Bool
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let now1 = Date()
        
        let enteredDate = dateFormatter.date(from: closetime)!
        let now2 = dateFormatter.string(from: now1)
        let now = dateFormatter.date(from: now2)!
        
        
        
        
        let endOfMonth = Calendar.current.date(byAdding: .minute, value: 0, to: enteredDate)!
        
        if endOfMonth.compare(now) == ComparisonResult.orderedDescending
        {
            print("orderedDescending")
            return false
        }
        else  if endOfMonth.compare(now) == ComparisonResult.orderedAscending
        {
            print("orderedAscending")
            return true
        }
        else
            
        {
            print("equal")
            return false
        }
    }
}
extension DetailsViewController
{
    //MARK:- catlist Api
    
    func CategoryDetailsAPI()
    {
        
        
        let params = ["clinicId" : self.clinicId] as [String:String]
        
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
        
        ApiHandler.apiDataPostMethod(url: CATDETAILSAPI, parameters: params, Header: header) { (response, error) in
            
            if error == nil
            {
                print(response)
                if let dict = response as? NSDictionary
                {
                    if let dataArray = dict.value(forKey: "data") as? NSArray
                    {
                        SVProgressHUD.dismiss()
                        if dataArray.count>0
                        {
                            
                            let dict = dataArray.object(at: 0) as! NSDictionary
                            
                            self.cellData=dict
                            
                            if let url2 = dict.value(forKey: "profile_image") as? String
                            {
                                let fullurl =   url2
                                
                                print("Image full url \(fullurl)")
                                let url = URL(string: fullurl)
                                
                                self.profileImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
                            }
                            if let vendor_services=dict.value(forKey: "vendor_services") as? NSArray
                            {
                                self.venderServiceArray=vendor_services
                            }
                            
                            self.allcommentTable.reloadData()
                            
                            if let user_name = dict.value(forKey: "user_name") as? String
                            {
                                self.nameLbl.text = user_name
                            }
                            
                            
                            if let  review = dict.value(forKey: "reviewsAvg") as? Double
                            {
                                let str = "\(review)"
                                
                                if str.contains(".")
                                {
                                    self.ratingNumber.text = str
                                }
                                else
                                {
                                    self.ratingNumber.text = str+".0"
                                    
                                }
                                
                                self.ratingV.rating = Double(review)
                                
                            }
                            if let  review = dict.value(forKey: "reviewsCount") as? Int
                            {
                                if review == 0 || review == 1
                                {
                                    let add = "("+"\(review)" + " Review" + ")"
                                    //cell.ratingLbl.setTitle(add, for: .normal)
                                    let attributeString = NSMutableAttributedString(string: add,attributes: self.yourAttributes)
                                    self.ratingLbl.setAttributedTitle(attributeString, for: .normal)
                                }
                                else
                                {
                                    let add = "("+"\(review)" + " Reviews" + ")"
                                    let attributeString = NSMutableAttributedString(string: add,attributes: self.yourAttributes)
                                    self.ratingLbl.setAttributedTitle(attributeString, for: .normal)
                                    
                                }
                                
                            }
                            
                            if let vendor_metaArray = dict.value(forKey: "vendor_meta") as? NSArray
                                
                            {
                                if vendor_metaArray.count>0
                                    
                                {
                                    
                                    let vendor_metaDict = vendor_metaArray.object(at: 0) as! NSDictionary
                                    self.vendor_metaDict=vendor_metaDict
                                    
                                    
                                    let dayOfWeak = Date().dayOfWeek() ?? ""
                                    
                                    if let openDict = vendor_metaDict.value(forKey: "open") as? NSDictionary
                                    {
                                        var openTime = openDict.value(forKey: dayOfWeak) as? String ?? "00:00"
                                        print("open time = \(openTime)")
                                        
                                        if openTime.contains("00:00")
                                        {
                                            self.openlbl.isHidden = true
                                            self.closeLbl.isHidden=false
                                            self.closeLbl.text = "Closed"
                                        }
                                        else
                                            
                                        {
                                            if let openDict = vendor_metaDict.value(forKey: "close") as? NSDictionary
                                            {
                                                var closeTime = openDict.value(forKey: dayOfWeak) as? String ?? "00:00"
                                                print("close time = \(openTime)")
                                                self.openlbl.text = "Open \(dayOfWeak) " + openTime+"-"+closeTime
                                                
                                                //self.closeLbl.text = "Closed"
                                                
                                                
                                                openTime = openTime.replacingOccurrences(of: "am", with: " AM")
                                                openTime = openTime.replacingOccurrences(of: "Am", with: " AM")
                                                openTime = openTime.replacingOccurrences(of: " am", with: " AM")
                                                openTime = openTime.replacingOccurrences(of: "pm", with: " PM")
                                                openTime = openTime.replacingOccurrences(of: "Pm", with: " PM")
                                                openTime = openTime.replacingOccurrences(of: " pm", with: " PM")
                                                self.closeLbl.text = "Open"
                                                
                                                // for close time
                                                
                                                closeTime = closeTime.replacingOccurrences(of: "am", with: " AM")
                                                closeTime = closeTime.replacingOccurrences(of: "Am", with: " AM")
                                                closeTime = closeTime.replacingOccurrences(of: " am", with: " AM")
                                                closeTime = closeTime.replacingOccurrences(of: "pm", with: " PM")
                                                closeTime = closeTime.replacingOccurrences(of: "Pm", with: " PM")
                                                closeTime = closeTime.replacingOccurrences(of: " pm", with: " PM")
                                                
                                                
                                                if self.isOpenClinic(OpenTime: openTime) == true
                                                {
                                                    
                                                    self.closeLbl.text = "Open"
                                                    if self.isClosedClinic(closetime: closeTime) == true
                                                    {
                                                        self.closeLbl.text = "Closed"
                                                    }
                                                    else if self.isClosedClinic(closetime: closeTime) == false
                                                    {
                                                        self.closeLbl.text = "Open"
                                                    }
                                                    else
                                                    {
                                                        self.closeLbl.text = ""//"Open"
                                                    }
                                                    
                                                }
                                                else
                                                {
                                                    self.closeLbl.text = "Closed"
                                                }
                                                
                                                
                                                
                                                
                                                self.openlbl.isHidden=false
                                                self.closeLbl.isHidden=false
                                            }
                                        }
                                        
                                    }
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    let city = vendor_metaDict.value(forKey: "state") as? String ?? ""
                                    
                                    let county = vendor_metaDict.value(forKey: "country") as? String ?? ""
                                    var yelp_avg_Rating2 = 0.0
                                    
                                    let yelp_id =  vendor_metaDict.value(forKey: "yelp_id") as? String ?? ""
                                    
                                    let apikey = "JirnDvucDtITkVBEgoR4tmKM0j3FroivAqecvL2UYxYNkXnf3APYUfmdfC2ZF90udn8KFVOeNU-oXZlaS35HAlwPx9NQtZO0D5Ywc_r_JfXXrh02vJBptjolDmTFXnYx"
                                    let url1 = "https://api.yelp.com/v3/businesses/"+yelp_id+"/reviews"
                                    print("full url  = \(url1)")
                                    let url = URL(string: url1)
                                    var request = URLRequest(url: url!)
                                    request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
                                    request.httpMethod = "GET"
                                    
                                    URLSession.shared.dataTask(with: request) { (data, response, error) in
                                        if let err = error {
                                            print(err.localizedDescription)
                                        }
                                        do {
                                            if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                                            {
                                                if let array = json.value(forKey: "reviews") as? NSArray
                                                {
                                                    self.yelpReviewArray = array.mutableCopy() as! NSMutableArray
                                                    
                                                    
                                                }
                                                for dict1 in self.yelpReviewArray
                                                {
                                                    let dict = dict1 as! NSDictionary
                                                    let rating = dict.value(forKey: "rating") as? Double ?? 0.0
                                                    yelp_avg_Rating2 = yelp_avg_Rating2 + rating
                                                    print("yelp_avg_Rating2 = \(yelp_avg_Rating2)")
                                                    
                                                    
                                                    
                                                }
                                                DispatchQueue.main.sync
                                                    {
                                                        var yelprating = 0.0
                                                        
                                                        if self.yelpReviewArray.count != 0
                                                        {
                                                            yelprating = Double(Int(yelp_avg_Rating2)/self.yelpReviewArray.count)
                                                        }
                                                        else{
                                                            yelprating =  yelp_avg_Rating2
                                                        }
                                                        let userrating = dict.value(forKey: "reviewsAvg") as? Double ?? 0.0
                                                       
                                                        if self.yelpReviewArray.count != 0
                                                        {
                                                            yelprating =  Double(Int(yelp_avg_Rating2)/self.yelpReviewArray.count)
                                                        }
                                                        else{
                                                            yelprating =  yelp_avg_Rating2
                                                        }
                                                      
                                                        var totalvg = 0.0
                                                        if userrating == 0.0 || userrating == 0
                                                        {
                                                            totalvg = (yelprating)
                                                            
                                                        }
                                                        else if yelprating == 0.0 || yelprating == 0
                                                        {
                                                            
                                                            totalvg = (userrating)
                                                        }
                                                        else{
                                                            totalvg = (yelprating+userrating)/2.0
                                                        }
                                                        
                                                        self.ratingNumber.text = String(totalvg.round(to: 2))
                                                        
                                                    
                                                        self.ratingV.rating = Double(totalvg)
                                                        let userReview = dict.value(forKey: "reviewsCount") as? Int ?? 0
                                                        let yelpReview = self.yelpReviewArray.count
                                                        let totalReview = (userReview+yelpReview)
                                                        
                                                        
                                                        
                                                        
                                                        if totalReview == 0 || totalReview == 1
                                                        {
                                                            let add = "("+"\(totalReview)" + " Review" + ")"
                                                            //cell.ratingLbl.setTitle(add, for: .normal)
                                                            let attributeString = NSMutableAttributedString(string: add,attributes: self.yourAttributes)
                                                            self.ratingLbl.setAttributedTitle(attributeString, for: .normal)
                                                        }
                                                        else
                                                        {
                                                            let add = "("+"\(totalReview)" + " Reviews" + ")"
                                                            let attributeString = NSMutableAttributedString(string: add,attributes: self.yourAttributes)
                                                            self.ratingLbl.setAttributedTitle(attributeString, for: .normal)
                                                            
                                                        }
                                                        
                                                        
                                                        
                                                        
                                                }
                                                
                                                SVProgressHUD.dismiss()
                                                
                                                print(">>>>>", json, #line, "<<<<<<<<<")
                                                
                                            }
                                            
                                        } catch {
                                            SVProgressHUD.dismiss()
                                            
                                            print("caught")
                                        }
                                        }.resume()
                                    
                                    
                                    
                                    
                                    
                                    
                                    self.locLbl.text = city+" ,"+county
                                    
                                    
                                    if let lat2 = vendor_metaDict.value(forKey: "Latitude") as? String
                                    {
                                        if let long2 = vendor_metaDict.value(forKey: "Longitude") as? String
                                        {
                                            
                                            let lat3 = Double(lat2)!
                                            let long3=Double(long2)!
                                            
                                            print("current coordinate = \(self.Mycoordinate)")
                                            let distance = self.Mycoordinate.distance(from: CLLocation(latitude: lat3, longitude: long3)) / 1000
                                            self.distanceLbl.text = String(format: "%.02f Km", distance) + " away"
                                            
                                            print(String(format: "The distance to my buddy is %.02f km", distance))
                                            
                                            
                                            
                                            
                                            
                                        }
                                    }
                                }
                                else
                                {
                                    self.locLbl.text = "Mohali, Punjab"
                                }
                            }
                            
                            // self.closeLbl.text=self.closeOpenStatus
                            
                        }
                        self.allMarkerArray = dataArray.mutableCopy() as! NSMutableArray
                        
                        self.allcommentTable.reloadData()
                    }
                    
                }
                else
                {
                    SVProgressHUD.dismiss()
                }
                
            }
            else
            {
                SVProgressHUD.dismiss()
                self.view.makeToast(error)
            }
        }
    }
    
    //MARK:- book Appointment Api
    
    func BookAppointmentAPI()
    {
        var apiKey = "1234"
        if let newuserEmail1 = DEFAULT.value(forKey: "APITOKEN") as? String
        {
            apiKey = "\(newuserEmail1)"
        }
        var userId = "72"
        if let USERID = DEFAULT.value(forKey: "USERID") as? String
        {
            userId = "\(USERID)"
        }
        
        let params = ["ownerId" : "1",
                      "clinicId" : self.clinicId,
                      "serviceId" : self.serviceId,
                      "serviceName" : self.serviceName,
                      "servicePrice" : self.servicePrice,
                      "time" : self.time,
                      "appoinment_date" : self.appoinment_date] as [String:String]
        
        SVProgressHUD.show()
        
        
        
        print("para in book appotment = \(params)")
        var DEVICETOKEN = "123456"
        if let device = DEFAULT.value(forKey: "DEVICETOKEN") as? String
        {
            DEVICETOKEN = device
        }
        let header = ["device-id":DEVICETOKEN,"device-type":"iOS","type":"iOS","api-token":apiKey] as [String:String]
        
        ApiHandler.apiDataPostMethod(url: BOOKAPPOINTMENTAPI, parameters: params, Header: header) { (response, error) in
            
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
                                
                                DEFAULT.set("Yes", forKey: "DetailBack")
                                DEFAULT.synchronize()
                                
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
extension DetailsViewController:datePopUpDataProtocol
{
    func dateInputData(data: Date)
    {
        print(data)
        let dateFormatter: DateFormatter = DateFormatter()
        //2020/04/20
        dateFormatter.dateFormat = "yyyy/MM/dd"//"MMMM d, yyyy"
        
        let selectedDate: String = dateFormatter.string(from: data)
        self.appoinment_date=selectedDate
        
        
        let dateFormatter2: DateFormatter = DateFormatter()
        
        dateFormatter2.dateFormat = "hh:mm a"
        
        // Apply date format
        let selectedDate2: String = dateFormatter2.string(from: data)
        
        let dateFormatter3: DateFormatter = DateFormatter()
        dateFormatter3.dateFormat = "EEE"
        let dayOfWeak = dateFormatter3.string(from: data)
        
        print("selected data = \(dayOfWeak)")
        
        
        self.time=selectedDate2
        
        // let dayOfWeak = Date().dayOfWeek() ?? ""
        
        if let openDict = self.vendor_metaDict.value(forKey: "open") as? NSDictionary
        {
            var openTime = openDict.value(forKey: dayOfWeak) as? String ?? "00:00"
            print("open time = \(openTime)")
            
            if openTime.contains("00:00")
            {
                //             self.openlbl.isHidden = true
                //             self.closeLbl.isHidden=false
                
                let alert=UIAlertController(title: "Alert!", message: "Sorry clinic on this day close please choose other day!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
                    let popUpVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePopupViewController") as! DatePopupViewController
                    //Don't forget initialize protocal deletage
                    // EditOrDelete = "Delete"
                    //  popUpVc.from = "Delete"
                    popUpVc.delegate = self
                    self.addChild(popUpVc)
                    popUpVc.view.frame = self.view.frame
                    self.view.addSubview(popUpVc.view)
                    popUpVc.didMove(toParent: self)
                }))
                self.present(alert, animated: true) {
                    
                }
                
            }
            else
                
            {
                if let closeDict = vendor_metaDict.value(forKey: "close") as? NSDictionary
                {
                    var closeTime = closeDict.value(forKey: dayOfWeak) as? String ?? "00:00"
                    
                    openTime = openTime.replacingOccurrences(of: "am", with: " AM")
                    openTime = openTime.replacingOccurrences(of: "Am", with: " AM")
                    openTime = openTime.replacingOccurrences(of: " am", with: " AM")
                    openTime = openTime.replacingOccurrences(of: "pm", with: " PM")
                    openTime = openTime.replacingOccurrences(of: "Pm", with: " PM")
                    openTime = openTime.replacingOccurrences(of: " pm", with: " PM")
                    
                    // for close time
                    
                    closeTime = closeTime.replacingOccurrences(of: "am", with: " AM")
                    closeTime = closeTime.replacingOccurrences(of: "Am", with: " AM")
                    closeTime = closeTime.replacingOccurrences(of: " am", with: " AM")
                    closeTime = closeTime.replacingOccurrences(of: "pm", with: " PM")
                    closeTime = closeTime.replacingOccurrences(of: "Pm", with: " PM")
                    closeTime = closeTime.replacingOccurrences(of: " pm", with: " PM")
                    
                    print("selected time = \(selectedDate)")
                    print("open time = \(openTime)")
                    print("close time = \(closeTime)")
                    
                    
                    //   self.openlbl.text = "Open " + openTime+"-"+closeTime
                    // self.closeLbl.text = "Closed"
                    let time1 = dateFormatter2.date(from: self.time)!
                    let time2 = dateFormatter2.date(from: openTime)!
                    let time3 = dateFormatter2.date(from: closeTime)!
                    
                    if time1.compare(time2) == ComparisonResult.orderedDescending
                    {
                        print("Discending")
                        
                        if time1.compare(time3) == ComparisonResult.orderedDescending
                        {
                            print("not due within a week")
                            let alert=UIAlertController(title: "Alert!", message: "Please choose time between \(openTime) to \(closeTime)", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
                                
                            }))
                            self.present(alert, animated: true) {
                                
                            }
                            
                        }
                        else if time1.compare(time3) == ComparisonResult.orderedAscending
                        {
                            print("due within a week")
                            
                            // hit api here
                            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                            {
                                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
                            }
                            else
                            {
                                self.BookAppointmentAPI()
                                
                            }
                            
                        } else
                        {
                            print("due in exactly a week (to the second, this will rarely happen in practice)")
                            //                            let alert=UIAlertController(title: "Alert!", message: "please choose time between \(openTime) to \(closeTime)", preferredStyle: .alert)
                            //
                            //                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
                            //
                            //                            }))
                            //                            self.present(alert, animated: true) {
                            //
                            //                            }
                            
                            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                            {
                                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
                            }
                            else
                            {
                                self.BookAppointmentAPI()
                                
                            }
                        }
                        
                        
                    }
                    else if time1.compare(time2) == ComparisonResult.orderedAscending
                    {
                        print("Ascending")
                        
                        let alert=UIAlertController(title: "Alert!", message: "Please choose time between \(openTime) to \(closeTime)", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
                            
                        }))
                        self.present(alert, animated: true) {
                            
                        }
                        //                        print("due within a week")
                        //                        if time2.compare(time3) == ComparisonResult.orderedDescending
                        //                                         {
                        //                                         print("not due within a week")
                        //
                        //                                         }
                        //                                         else if time2.compare(time3) == ComparisonResult.orderedAscending
                        //                                         {
                        //                                             print("due within a week")
                        //
                        //                                         } else
                        //                                         {
                        //                                             print("due in exactly a week (to the second, this will rarely happen in practice)")
                        //                                         }
                        //
                        
                        
                    } else
                    {
                        print("due in exactly a week (to the second, this will rarely happen in practice)")
                        //                        let alert=UIAlertController(title: "Alert!", message: "please choose time between \(openTime) to \(closeTime)", preferredStyle: .alert)
                        //
                        //                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
                        //
                        //                        }))
                        //                        self.present(alert, animated: true) {
                        //
                        //                        }
                        
                        
                        
                        if time1.compare(time3) == ComparisonResult.orderedDescending
                        {
                            print("not due within a week")
                            let alert=UIAlertController(title: "Alert!", message: "Please choose time between \(openTime) to \(closeTime)", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
                                
                            }))
                            self.present(alert, animated: true) {
                                
                            }
                            
                        }
                        else if time1.compare(time3) == ComparisonResult.orderedAscending
                        {
                            print("due within a week")
                            
                            // hit api here
                            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                            {
                                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
                            }
                            else
                            {
                                self.BookAppointmentAPI()
                                
                            }
                            
                        } else
                        {
                            print("due in exactly a week (to the second, this will rarely happen in practice)")
                            //                            let alert=UIAlertController(title: "Alert!", message: "please choose time between \(openTime) to \(closeTime)", preferredStyle: .alert)
                            //
                            //                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
                            //
                            //                            }))
                            //                            self.present(alert, animated: true) {
                            //
                            //                            }
                            
                            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                            {
                                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
                            }
                            else
                            {
                                self.BookAppointmentAPI()
                                
                            }
                        }
                        
                    }
                    
                }
            }
            
        }
        
        
        
        
        print("Selected value \(selectedDate)")
        
    }
    
    
}

extension DetailsViewController:UIPopoverPresentationControllerDelegate
{
    
    
    //  MARK: - adaptivePresentationStyleForPresentationController
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.popover // 20
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        
        return UIModalPresentationStyle.none
    }
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController?
    {
        let navController = UINavigationController.init(rootViewController: controller.presentedViewController)
        print(navController)
        return navController // 21
    }
    
}
