//
//  MapAndListView.swift
//  Dental Place
//
//  Created by eWeb on 16/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapAndListView: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var allMarkerArray = NSMutableArray()
    var allMarkerArray2 = NSMutableArray()
var locationManager = CLLocationManager()
    
    var Mycoordinate = CLLocation(latitude: CURRENTLOCATIONLAT, longitude: CURRENTLOCATIONLONG)

    @IBOutlet weak var locationlbl: UILabel!
    @IBOutlet weak var nodatafoundLbl: UILabel!
    
    @IBOutlet weak var listMapTable: UITableView!
  
    var singleCatDat:CatListModel?
    
    let yourAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.init(red: 106/255, green: 134/255, blue: 165/255, alpha: 1),
        .underlineStyle: NSUnderlineStyle.single.rawValue]
    
    override func viewDidLoad()
    {
//        GMSServices.provideAPIKey("AIzaSyAxECLYUaVv267Aypd3Q5yAo_yDW10eQ90")
//        GMSPlacesClient.provideAPIKey("AIzaSyAxECLYUaVv267Aypd3Q5yAo_yDW10eQ90")
        
        super.viewDidLoad()
        DEFAULT.removeObject(forKey: "DetailBack")
        DEFAULT.synchronize()
        listMapTable.register(UINib(nibName: "ListAndMapTableCell", bundle: nil), forCellReuseIdentifier: "ListAndMapTableCell")

        listMapTable.register(UINib(nibName: "SearchServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchServiceTableViewCell")

         self.nodatafoundLbl?.isHidden=true
        listMapTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0); //values

    }
    override func viewWillAppear(_ animated: Bool)
    {
     super.viewWillAppear(true)
        self.nodatafoundLbl?.isHidden=true
       locationManager.delegate = self
       locationManager.requestWhenInUseAuthorization()
       locationManager.startUpdatingLocation()
       locationManager.startMonitoringSignificantLocationChanges()
        if let loc=DEFAULT.value(forKey: "CURRENTLOCATION") as? String
        {
            self.locationlbl?.text=loc
        }

        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {

            self.CategoryBasedDataAPI()

        }
        print("current time = ")
        print(Date().dayOfWeek() ?? "")
        print(Date().currentTime())
    }
    @IBAction func filterBtn(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SeeFullList") as! SeeFullList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.allMarkerArray.count//self.singleCatDat?.data?.count ?? 0 //5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ListAndMapTableCell") as! ListAndMapTableCell
         let cell = tableView.dequeueReusableCell(withIdentifier: "SearchServiceTableViewCell") as! SearchServiceTableViewCell
        
        cell.bookAppBtn.layer.cornerRadius = 6
        
        cell.bookAppBtn.tag=indexPath.row
        
        cell.bookAppBtn.addTarget(self, action: #selector(BookAction), for: .touchUpInside)
        cell.seeAllBtn.tag=indexPath.row
        
        cell.seeAllBtn.addTarget(self, action: #selector(TimeTableAction), for: .touchUpInside)
        
       
        cell.mainview.layer.cornerRadius = 12
        cell.mainview.layer.shadowColor = UIColor.lightGray.cgColor
         cell.mainview.layer.shadowOpacity = 1
         cell.mainview.layer.shadowOffset = .zero
         cell.mainview.layer.shadowRadius = 3
        
        let dict = self.allMarkerArray.object(at: indexPath.row) as! NSDictionary
        if let url2 = dict.value(forKey: "profile_image") as? String
        {
            let fullurl =   url2
            
            print("Image full url \(fullurl)")
            let url = URL(string: fullurl)
            
            cell.profileImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
        }
        if let user_name = dict.value(forKey: "user_name") as? String
        {
            cell.nameLbl.text = user_name
        }
        if let vendor_servicesArray = dict.value(forKey: "vendor_services") as? NSArray
                   
               {
                   if vendor_servicesArray.count>0
                       
                   {
                     for dict1 in vendor_servicesArray
                     {
                        let dict=dict1 as! NSDictionary
                        let serviceName1 = dict.value(forKey: "serviceName") as? String ?? ""
                        let serviceName2 = DEFAULT.value(forKey: "CategoryName") as? String ?? ""
                        let rating = DEFAULT.value(forKey: "SELECTEDFILTER") as? String ?? "-1"
                        //if rating == "-1" || rating==""
                            let value=DEFAULT.value(forKey: "currentCat") as? String ?? ""
                                   
                                   
                        if value == "  All  "
                                   
                        {
                            cell.serviceView.isHidden=true
                                                                            cell.searviceNamelbl.text=""
                                                                             cell.serviceCostLbl.text=""
                                                                             cell.topConst.constant=13
                        }
                        else
                            
                        {
                            if serviceName1.lowercased()==serviceName2.lowercased()
                                                  {
                                              cell.searviceNamelbl.text=serviceName2
                                                      cell.serviceCostLbl.text="$"+(dict.value(forKey: "servicePrice") as? String ?? "")
                                                      cell.topConst.constant=73
                                                       cell.serviceView.isHidden=false
                                                    break
                                                  }
                                                  else
                                                  
                                                  {
                                                       cell.serviceView.isHidden=true
                                                     cell.searviceNamelbl.text=""
                                                      cell.serviceCostLbl.text=""
                                                      cell.topConst.constant=13
                                                  }
                        }
                      
                      }
                    
                  }
                else
                                       
                                       {
                                        cell.serviceView.isHidden=true

                                          cell.searviceNamelbl.text=""
                                           cell.serviceCostLbl.text=""

                                        cell.topConst.constant=13
                                       }
           }
        if let vendor_metaArray = dict.value(forKey: "vendor_meta") as? NSArray
            
        {
            if vendor_metaArray.count>0
                
            {
                
                let vendor_metaDict = vendor_metaArray.object(at: 0) as! NSDictionary
                
                
              let dayOfWeak = Date().dayOfWeek() ?? ""
                
                if let openDict = vendor_metaDict.value(forKey: "open") as? NSDictionary
                {
                    let openTime = openDict.value(forKey: dayOfWeak) as? String ?? "00:00"
                    print("open time = \(openTime)")
                    
                    if openTime.contains("00:00")
                    {
                        cell.openlbl.isHidden = true
                        cell.closeLbl.isHidden=false
                    }
                    else
                    
                    {
                        if let openDict = vendor_metaDict.value(forKey: "close") as? NSDictionary
                        {
                            let closeTime = openDict.value(forKey: dayOfWeak) as? String ?? "00:00"
                            print("close time = \(openTime)")
                            cell.openlbl.text = openTime+"-"+closeTime
                        cell.closeLbl.text = "Open"
                            
                        cell.openlbl.isHidden=false
                        cell.closeLbl.isHidden=false
                        }
                    }
                    
                }
                
                
                if let lat2 = vendor_metaDict.value(forKey: "Latitude") as? String
                {
                 if let long2 = vendor_metaDict.value(forKey: "Longitude") as? String
                  {
                    if let CURRENTLAT = DEFAULT.value(forKey: "CURRENTLAT") as? String
                                   {
                                    if let CURRENTLONG = DEFAULT.value(forKey: "CURRENTLONG") as? String
                                           {
                                            //cell.distanceLbl.text = "\("A".distance(lat1: Double(CURRENTLAT), lon1: Double(CURRENTLAT), lat2: Double(lat2), lon2: Double(long2), unit: "KM"))"
                                            let lat3 = Double(lat2)!
                                            let long3=Double(long2)!
                                            
                                       let distance = self.Mycoordinate.distance(from: CLLocation(latitude: lat3, longitude: long3)) / 1000
                                    cell.distanceLbl.text = String(format: "%.01fKm", distance) + " away"
                                            
                                            print(String(format: "The distance to my buddy is %.01fkm", distance))


                                           }
                                           
                                   }
                }
                }
                

               
            }
            else
            {
                cell.locLbl.text = "Mohali, Punjab"
            }
        }
        
            
               
        
        
        if let  review = dict.value(forKey: "reviewsAvg") as? Int
        {
            let str = "\(review)"
            
            if str.contains(".")
            {
                
            }
            else
            {
                cell.ratingNumber.text = str+".0"
                
            }
            cell.ratingV.rating = Double(review)
            cell.ratingV.isUserInteractionEnabled=false
        }
        if let  review = dict.value(forKey: "reviewsCount") as? Int
        {
            if review == 0 || review == 1
            {
                let add = "("+"\(review)" + " Review" + ")"
                //cell.ratingLbl.setTitle(add, for: .normal)
                let attributeString = NSMutableAttributedString(string: add,attributes: yourAttributes)
                cell.ratingLbl.setAttributedTitle(attributeString, for: .normal)
            }
            else
            {
                let add = "("+"\(review)" + " Reviews" + ")"
                let attributeString = NSMutableAttributedString(string: add,attributes: yourAttributes)
                cell.ratingLbl.setAttributedTitle(attributeString, for: .normal)
                
            }
            
        }
        
        if let vendor_metaArray = dict.value(forKey: "vendor_meta") as? NSArray
            
        {
            if vendor_metaArray.count>0
                
            {
                
                let vendor_metaDict = vendor_metaArray.object(at: 0) as! NSDictionary
                
                let city =  vendor_metaDict.value(forKey: "state") as? String ?? ""
                let country =  vendor_metaDict.value(forKey: "country") as? String ?? ""

                cell.locLbl.text = city+" , "+country
            }
            else
            {
                cell.locLbl.text = "Mohali, Punjab"
            }
        }
        
        
        
        
        
        /*
        let singleCellData=self.singleCatDat?.data?[indexPath.row]
        
        if let url2 = singleCellData?.profileImage
        {
            let fullurl =   url2
            
            print("Image full url \(fullurl)")
            let url = URL(string: fullurl)
            
     cell.profileImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
        }
        cell.ratingV.rating = Double(singleCellData?.reviewsAvg ?? 1)
        if let  review = singleCellData?.reviewsAvg as? Int
        {
            let str = "\(review)"
            
            if str.contains(".")
            {
                
            }
            else
            {
                cell.ratingNumber.text = str+".0"

            }
        }
        
        
       let review = singleCellData?.reviewsCount
        if review == 0 || review == 1
        {
            let add = "("+"\(review!)" + " Review" + ")"
            
            //cell.ratingLbl.setTitle(add, for: .normal)
            let attributeString = NSMutableAttributedString(string: add,attributes: yourAttributes)
            cell.ratingLbl.setAttributedTitle(attributeString, for: .normal)
        }
        else
        {
            let add = "("+"\(review!)" + " Reviews" + ")"
            let attributeString = NSMutableAttributedString(string: add,attributes: yourAttributes)
            cell.ratingLbl.setAttributedTitle(attributeString, for: .normal)

        }
        
        
        cell.nameLbl.text = singleCellData?.userName
        if singleCellData?.vendorMeta?.count ?? 0>0
        {
          cell.locLbl.text = singleCellData?.vendorMeta?[0].address1
            
        }
        else
        {
            cell.locLbl.text = "Mohali, Punjab"
        }
       
        */

        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListAndMapTableCell") as! ListAndMapTableCell
//        let clearView = UIView()
//        clearView.backgroundColor = UIColor.clear // Whatever color you like
//        cell.backgroundView = clearView
//
        tableView.deselectRow(at: indexPath, animated: true)

        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
         let dict = self.allMarkerArray.object(at: indexPath.row) as! NSDictionary
        
        print(dict)
        //let singleCellData=self.singleCatDat?.data?[indexPath.row]
        let id = dict.value(forKey: "id") as? Int ?? 0
        
        vc.clinicId="\(id)"
        
        self.navigationController?.pushViewController(vc, animated: true)

        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       
        let value=DEFAULT.value(forKey: "currentCat") as? String ?? ""
        
        
        if value == "  All  "
        {
           return 280
        }
        else
        {
            return 340
            
        }
//          let dict = self.allMarkerArray.object(at: indexPath.row) as! NSDictionary
//        if let vendor_servicesArray = dict.value(forKey: "vendor_services") as? NSArray
//
//                     {
//                         if vendor_servicesArray.count>0
//
//                         {
//                            for i in 0..<vendor_servicesArray.count
//                           {
//                            let dict = vendor_servicesArray.object(at: i) as! NSDictionary
//                              let serviceName1 = dict.value(forKey: "serviceName") as? String ?? ""
//                              let serviceName2 = DEFAULT.value(forKey: "CategoryName") as? String ?? ""
//                            let rating = DEFAULT.value(forKey: "SELECTEDFILTER") as? String ?? "-1"
//                            let minimum = DEFAULT.value(forKey: "minimum") as? String ?? "0"
//
//
//                                     if rating == "-1" || rating==""
//                                                  {
//                                               return 280
//                                              }
//                        else if minimum == "" || minimum == "0"
//                                     {
//                                        return 280
//                                     }
//                                             else
//                                                  {
//                                                    if serviceName1.lowercased()==serviceName2.lowercased()
//                                                                                 {
//                                                                                    return 340
//                                                                                 }
//                                                                                 else
//                                                                                 {
//                                                                                   return 280
//                                                                                }
//                            }
//                            }
//
//
//                            }
//                        }
//                        else{
//                            return 280
//                            }
//
////        else{
////                return 280
////                }
      
      
    }
    
    @IBAction func ListBtnAct(_ sender: Any)
    {
       
//        mapBtn.setTitleColor(UIColor(red: 0/255.0, green: 106/255.0, blue: 160/255.0, alpha: 1), for: .normal)
//        mapView.backgroundColor = UIColor(red: 0/255.0, green: 106/255.0, blue: 160/255.0, alpha: 1)
//
//        listBtn.setTitleColor(UIColor(red: 32/255.0, green: 156/255.0, blue: 141/255.0, alpha: 1), for: .normal)
//        listVeiw.backgroundColor = UIColor(red: 32/255.0, green: 156/255.0, blue: 141/255.0, alpha: 1)
    }
    @IBAction func MapBtnAct(_ sender: Any)
    {
        
//        listBtn.setTitleColor(UIColor(red: 0/255.0, green: 106/255.0, blue: 160/255.0, alpha: 1), for: .normal)
//        listVeiw.backgroundColor = UIColor(red: 0/255.0, green: 106/255.0, blue: 160/255.0, alpha: 1)
//
//        mapBtn.setTitleColor(UIColor(red: 32/255.0, green: 156/255.0, blue: 141/255.0, alpha: 1), for: .normal)
//        mapView.backgroundColor = UIColor(red: 32/255.0, green: 156/255.0, blue: 141/255.0, alpha: 1)
    
    
    
    
    }
    
    @objc func BookAction(_ sender:UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        let dict = self.allMarkerArray.object(at: sender.tag) as! NSDictionary
               
               print(dict)
    
               let id = dict.value(forKey: "id") as? Int ?? 0
               
               vc.clinicId="\(id)"
            
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func TimeTableAction(_ sender:UIButton)
       {
        
        let dict = self.allMarkerArray.object(at: sender.tag) as! NSDictionary
        if let vendor_metaArray = dict.value(forKey: "vendor_meta") as? NSArray
                  
              {
                  if vendor_metaArray.count>0
                      
                  {
                      
                      let vendor_metaDict = vendor_metaArray.object(at: 0) as! NSDictionary
                    
                    print(vendor_metaDict)
            let contentCV = self.storyboard?.instantiateViewController(withIdentifier: "TimeTableViewController") as! TimeTableViewController
                 
                 contentCV.modalPresentationStyle = UIModalPresentationStyle.popover // 13
                 let popPC = contentCV.popoverPresentationController // 14
                  contentCV.vendor_metaDict=vendor_metaDict
                    
                  popPC?.backgroundColor = UIColor.white
                 
                 contentCV.preferredContentSize = CGSize(width:SCREENWIDTH-30,height:300)
                 contentCV.popoverPresentationController?.sourceRect =  (sender as! UIButton).bounds
                 contentCV.popoverPresentationController?.sourceView = sender as? UIButton // button
                 popPC?.delegate = self // 18
                 present(contentCV, animated: true, completion: nil)
                }
        }
           
       }
    
}
extension MapAndListView
{
    //MARK:- catlist Api
    
    func CategoryBasedDataAPI()
    {
        
        
        var params = ["type" : "a"] as [String:String]
        let servicesId = DEFAULT.value(forKey: "CategoryId") as? String ?? "0"
        let rating = DEFAULT.value(forKey: "SELECTEDFILTER") as? String ?? "-1"
        let minimum = DEFAULT.value(forKey: "minimum") as? String ?? "0"
        let maximum = DEFAULT.value(forKey: "maximum") as? String ?? "1000"
        
        
       
    
     if servicesId != "" && servicesId != "0" && rating != "" && rating != "-1" && minimum != "" && minimum != "0" && maximum != "" && maximum != "0"
                         {
                         params = ["servicesId":servicesId,"type" : "a","ratiningRange":rating,"minimum" : minimum,"maximum":maximum]

                         }
                         else  if  servicesId != "" && servicesId != "0" &&  minimum != "" && minimum != "0" && maximum != "" && maximum != "0"
                           {
                       params = ["servicesId":servicesId,"type" : "a","ratiningRange":rating,"minimum" : minimum,"maximum":maximum]

                                   }
               
                          else if servicesId != "" && servicesId != "0" && rating != "" && rating != "-1"
                                            {
                                            params = ["servicesId":servicesId,"type" : "a","ratiningRange":rating,"minimum" : minimum,"maximum":maximum]

                                            }
                           
                 //            else if rating != "" && rating != "-1"
                 //                              {
                 //                              params = ["type" : "a","ratiningRange":rating,"minimum" : minimum,"maximum":maximum]
                 //                              }
                            else if servicesId != "" && servicesId != "0"
                                    {
                                        params = ["type" : "a","servicesId":servicesId]
                                    }
                                   
                         else
                         
                         {
                             params = ["type" : "a"]
                         }
        
//        if let rating = DEFAULT.value(forKey: "SELECTEDFILTER") as? String
//        {
//            if let minimum = DEFAULT.value(forKey: "minimum") as? String
//            {
//                if let maximum = DEFAULT.value(forKey: "maximum") as? String
//                {
//                    params = ["type" : "r","ratiningRange":rating,"minimum" : minimum,"maximum":maximum]as [String : String]
//
//                }
//            }
//            else
//
//            {
//                params = ["type" : "r","ratiningRange":rating]as [String : String]
//
//            }
//            }
        
        
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
        
        print("Filter list para = \(params)")
        ApiHandler.apiDataPostMethod(url: SINGLECATDATAAPI, parameters: params, Header: header) { (response, error) in
            
            if error == nil
            {
                print(response)
                if let dict = response as? NSDictionary
                {
                    if let dataArray = dict.value(forKey: "data") as? NSArray
                    {
                        
                        self.allMarkerArray = dataArray.mutableCopy() as! NSMutableArray
                        if self.allMarkerArray.count>0
                        {
                            self.nodatafoundLbl?.isHidden=true
                        }
                        else
                        
                        {
                            self.nodatafoundLbl?.isHidden=false
                        }
                        
                        self.listMapTable.reloadData()
                    }
                    else
                    
                    {
                        self.nodatafoundLbl?.isHidden=false
                    }
                    
                }
            
            }
            else
            {
                self.nodatafoundLbl.isHidden=false
                self.view.makeToast(error)
            }
        }
    }
    
    
    
    
}
//MARK:- location work

extension MapAndListView:CLLocationManagerDelegate
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
                        let country = firstLocation.country ?? ""
                        self?.Mycoordinate = CLLocation(latitude: latitude, longitude: longitude)
                        let address =   nationality + " , " + country
                        
                        CURRENTLOCATIONLONG=longitude
                                              CURRENTLOCATIONLAT=latitude
                        DEFAULT.set(address, forKey: "CURRENTLOCATION")
                        DEFAULT.synchronize()
                    
                        CURRENTLOCATIONLAT = latitude
                        CURRENTLOCATIONLONG = longitude
                        
                        DEFAULT.set("\(latitude)", forKey: "CURRENTLAT")
                        DEFAULT.set("\(longitude)", forKey: "CURRENTLONG")
                        //  self?.CompanyLocationTF.text! = address
                      //  self?.locLbl.text=address
                        
                        self?.locationManager.stopUpdatingLocation()
                        
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

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }

    func currentTime() -> String
    {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        //OR dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        let currentDateString: String = dateFormatter.string(from: date)
        print("Current date is \(currentDateString)")
        
        return currentDateString
    }
}

extension MapAndListView:UIPopoverPresentationControllerDelegate
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
