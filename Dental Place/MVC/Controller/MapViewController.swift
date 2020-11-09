//
//  MapViewController.swift
//  Dental Place
//
//  Created by eWeb on 17/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import SVProgressHUD
import FloatRatingView

struct MyPlace {
    var name: String
    var lat: Double
    var long: Double
}


class MapViewController: UIViewController {

    @IBOutlet weak var priceview: UIView!
    
    @IBOutlet weak var locaView: UIView!
    var Mycoordinate = CLLocation(latitude: CURRENTLOCATIONLAT, longitude: CURRENTLOCATIONLONG)
    var singleCatDat:CatListModel?
    let yourAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.init(red: 106/255, green: 134/255, blue: 165/255, alpha: 1),
        .underlineStyle: NSUnderlineStyle.single.rawValue]
    
    @IBOutlet weak var serviceView: UIView!
    @IBOutlet weak var serviceCostLbl: UILabel!
    @IBOutlet weak var searviceNamelbl: UILabel!
    @IBOutlet weak var topConst: NSLayoutConstraint!
     @IBOutlet weak var detalHeightConst: NSLayoutConstraint!
    var selectedMarkerIndex=0
    
    @IBOutlet weak var mainview: UIView!
    @IBOutlet weak var bookAppBtn: UIButton!
    @IBOutlet weak var ratingV: FloatRatingView!
    
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var ratingLbl: UIButton!
    @IBOutlet weak var closeLbl: UILabel!
    @IBOutlet weak var openlbl: UILabel!
    @IBOutlet weak var locLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
   // @IBOutlet weak var ratingNumber: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var ratingShow: UILabel!
    
    
    let currentLocationMarker = GMSMarker()
    var locationManager = CLLocationManager()
    var chosenPlace: MyPlace?
    
    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70
    
    var currentLat = ""
    var currentLong = ""
    
    var allMarkerArray = NSMutableArray()
    var allMarkerArray2 = NSMutableArray()
    
    var markers = [GMSMarker]()
    
    var customInfoWindow : MarkerDialog?
    var tappedMarker : GMSMarker?
    

    //MARK:- for marker details show
    
    @IBOutlet weak var myMapView: GMSMapView!
    
   // @IBOutlet var markerCollection: UICollectionView!
    
  //  @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var markerDetailView: UIView!
    
    var fromMyEvent = ""
    
    @IBOutlet weak var avgLbl: UILabel!
    @IBOutlet weak var currentLoc: UILabel!
    
     var  vendor_metaDict=NSDictionary()
    
    @IBOutlet weak var avgPriceLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
       // priceview.dropShadow(color: .black, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 20, scale: true)
        
        priceview.layer.cornerRadius = 4
  
        
        //Comment here
        
        
        
        locaView.layer.shadowPath = UIBezierPath(rect: priceview.bounds).cgPath
        locaView.layer.shadowRadius = 5
        locaView.layer.shadowOffset = .zero
        locaView.layer.shadowOpacity = 1
        locaView.layer.shadowColor = UIColor.gray.cgColor

        
       // locaView.dropShadow(color: .black, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 20, scale: true)
        
        locaView.layer.cornerRadius = 4
       // locaView.clipsToBounds = true
        
        
         myMapView.delegate=self
        self.markerDetailView.isHidden = true
        
        self.customInfoWindow = MarkerDialog().loadView()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
      //  self.markerCollection.register(UINib(nibName: "clusterDetailCell", bundle: nil), forCellWithReuseIdentifier: "clusterDetailCell")
       
        
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus()
            {
            case .notDetermined, .restricted, .denied:
                print("No access")
                
                let alertController = UIAlertController(title: "Enable GPS", message: "GPS is not enable.Do you want to go setting menu.", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
                let settingsAction = UIAlertAction(title: "SETTING", style: .default) { (UIAlertAction) in
                    UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                }
                
                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                self.present(alertController, animated: true, completion: nil)
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        }
        else {
            print("Location services are not enabled")
            let alertController = UIAlertController(title: "Enable GPS", message: "GPS is not enable.Do you want to go setting menu.", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
            let settingsAction = UIAlertAction(title: "SETTING", style: .default) { (UIAlertAction) in
                UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        DispatchQueue.main.async
            {
                
                
                self.initGoogleMaps()
        
        }
                
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(true)
        print("distance=")
        print("distance= ".distance(lat1: Double(30.7044), lon1: Double(76.7179), lat2: Double(30.5044), lon2: Double(76.7199), unit: "K"), "Km")
        if let loc=DEFAULT.value(forKey: "CURRENTLOCATION") as? String
        {
            self.currentLoc.text=loc
        }
    
               if let avgprice=DEFAULT.value(forKey: "avgprice") as? String
                   {
                    self.avgLbl.isHidden=false

                    self.avgPriceLbl.isHidden=false
                       self.avgPriceLbl.text="$"+avgprice
                       self.priceview.isHidden=false
                         priceview.layer.shadowPath = UIBezierPath(rect: priceview.bounds).cgPath
                      priceview.layer.shadowRadius = 5
                      priceview.layer.shadowOffset = .zero
                      priceview.layer.shadowOpacity = 1
                      locaView.layer.shadowColor = UIColor.gray.cgColor

                      priceview.layer.cornerRadius = 4
                   }
               else
               {
                self.avgLbl.isHidden=true

                self.avgPriceLbl.isHidden=true
                  self.priceview.isHidden=false
                  self.priceview.backgroundColor=UIColor.clear
               }
        customInfoWindow?.removeFromSuperview()
      /*
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus()
            {
            case .notDetermined, .restricted, .denied:
                print("No access")
                
                let alertController = UIAlertController(title: "Enable GPS", message: "GPS is not enable.Do you want to go setting menu.", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
                let settingsAction = UIAlertAction(title: "SETTING", style: .default) { (UIAlertAction) in
                    UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                }
                
                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                self.present(alertController, animated: true, completion: nil)
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        }
        else {
            print("Location services are not enabled")
            let alertController = UIAlertController(title: "Enable GPS", message: "GPS is not enable.Do you want to go setting menu.", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
            let settingsAction = UIAlertAction(title: "SETTING", style: .default) { (UIAlertAction) in
                UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        */

        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.CategoryBasedDataAPI()
        }
        myMapView.delegate=self
        self.customInfoWindow = MarkerDialog().loadView()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        initGoogleMaps()
        
     // showPartyMarkers2()
        
    }
    //MARK:- Map init code
    func initGoogleMaps() {
//        let camera = GMSCameraPosition.camera(withLatitude: CURRENTLOCATIONLAT, longitude: CURRENTLOCATIONLONG, zoom: 17.0)
        
        let camera = GMSCameraPosition.camera(withLatitude: CURRENTLOCATIONLAT, longitude: CURRENTLOCATIONLONG, zoom: 15.0)
        self.myMapView.camera = camera
        self.myMapView.delegate = self
        self.myMapView.settings.compassButton = true
        self.myMapView.settings.myLocationButton=true
        self.myMapView.isMyLocationEnabled = true
        showPartyMarkers()
    }
   func showPartyMarkers2()
    {
        myMapView.clear()
        if markers.count>0
        {
            self.markers.removeAll()
        }

//        for i in 0...5//<self.allMarkerArray.count
//        {
          //  let dict = self.allMarkerArray.object(at: i) as! NSDictionary
            let marker=GMSMarker()
            let marker2=GMSMarker()
        let marker3=GMSMarker()
        let marker4=GMSMarker()
        let marker5=GMSMarker()
             marker.position = CLLocationCoordinate2D(latitude: 30.7046, longitude: 76.7179)
             marker2.position = CLLocationCoordinate2D(latitude: 30.4079, longitude: 76.5031)
            marker3.position = CLLocationCoordinate2D(latitude: 30.6079, longitude: 74.8031)
            marker4.position = CLLocationCoordinate2D(latitude: 30.9079, longitude: 76.9031)
            marker5.position = CLLocationCoordinate2D(latitude: 30.8079, longitude: 76.6031)

            //  let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: UIImage(named: "NewYellowMarker2")!, borderColor: UIColor.clear, tag: i)

            // marker.iconView=customMarker

           // let lat = Double(dict.value(forKey: "event_lat") as! String)
           // let long = Double(dict.value(forKey: "event_lng") as! String)

//            if lat != nil || long != nil
//            {
//              //  marker.position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
//              //  let item = MoccherPOIItem(position: CLLocationCoordinate2DMake(lat!, long!), name: "\(i)", Tb_Type: "event")
//               // clusterManager.add(item)
//            }

            // marker.icon = GMSMarker.markerImage(with: YELLOWMARKERCOLOL)
           // marker.icon  = #imageLiteral(resourceName: "MarkerImage")

//         marker2.icon  =  #imageLiteral(resourceName: "MarkerImage")
//         marker3.icon  =  #imageLiteral(resourceName: "MarkerImage")
//         marker4.icon  =  #imageLiteral(resourceName: "MarkerImage")
//         marker5.icon  =  #imageLiteral(resourceName: "MarkerImage")

       // customInfoWindow?.markerBtn.layer.cornerRadius = 40
      //  customInfoWindow?.markerBtn.clipsToBounds = true

        customInfoWindow?.groupName.layer.cornerRadius = 5
        customInfoWindow?.groupName.text  = " $100  "
      //  customInfoWindow?.groupName.textColor =

        customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "MarkerImage"), for: .normal)
        customInfoWindow?.frame = CGRect(x: 0, y: 0, width: 124, height: 76)

//                let opaqueWhite = UIColor(white: 1, alpha: 0.85)
//                customInfoWindow?.layer.backgroundColor = opaqueWhite.cgColor
//                customInfoWindow?.layer.cornerRadius = 8
      //  customInfoWindow?.groupName.textColor = APPCOLOL

        marker.iconView = customInfoWindow
         marker2.iconView = customInfoWindow
         marker3.iconView = customInfoWindow
         marker4.iconView = customInfoWindow
         marker5.iconView = customInfoWindow

            markers.append(marker)
            marker.map = self.myMapView
         marker2.map = self.myMapView
        marker3.map = self.myMapView
        marker4.map = self.myMapView
        marker5.map = self.myMapView

       // }
  }
    
    @IBAction func bookApp(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
      let dict=self.allMarkerArray.object(at: self.selectedMarkerIndex) as! NSDictionary
        let id = dict.value(forKey: "id") as? Int ?? 0
               
               vc.clinicId="\(id)"
        self.navigationController?.pushViewController(vc, animated: true)

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
    

}
//MARK:- Map Work

extension MapViewController:CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate
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
        self.currentLat = "\((location?.coordinate.latitude)!)"
        self.currentLong = "\((location?.coordinate.longitude)!)"
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        self.Mycoordinate = CLLocation(latitude: lat, longitude: long)
        self.myMapView.animate(to: camera)
        
        // showPartyMarkers(lat: lat, long: long)
    }
    
    //MARK:-  Marker tap
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        NSLog("marker was tapped")
        tappedMarker = marker
        
        self.markerDetailView.isHidden=false
//        if let selectedMarker = mapView.selectedMarker
//        {
//            //selectedMarker.icon = GMSMarker.markerImage(with: YELLOWMARKERCOLOL)
//            customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "selectedmarker"), for: .normal)
//        }
//        else
//        {
//  customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "MarkerImage"), for: .normal)
//
//        }

        
        
        
        marker.icon = GMSMarker.markerImage(with: YELLOWMARKERCOLOL)
        //get position of tapped marker
        let position = marker.position
        mapView.animate(toLocation: position)
        let point = mapView.projection.point(for: position)
        let newPoint = mapView.projection.coordinate(for: point)
        let camera = GMSCameraUpdate.setTarget(newPoint)
        mapView.animate(with: camera)
        
        let opaqueWhite = UIColor(white: 1, alpha: 0.85)
        customInfoWindow?.layer.backgroundColor = opaqueWhite.cgColor
        customInfoWindow?.layer.cornerRadius = 8
        customInfoWindow?.center = mapView.projection.point(for: position)
        customInfoWindow?.center.y -= 100
        
        customInfoWindow?.backgroundColor = UIColor.clear
        
//        customInfoWindow?.markerBtn.layer.cornerRadius = 40
//        customInfoWindow?.markerBtn.clipsToBounds = true
        if let index = markers.index(of: marker)
        {
            self.selectedMarkerIndex=index
            
//            for i in 0..<self.allMarkerArray.count
//
//            {
//
            let dict = self.allMarkerArray.object(at: self.selectedMarkerIndex) as! NSDictionary
                if let url2 = dict.value(forKey: "profile_image") as? String
                {
                    let fullurl =   url2
                    
                    print("Image full url \(fullurl)")
                    let url = URL(string: fullurl)
                    
                    profileImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
                }
                if let user_name = dict.value(forKey: "user_name") as? String
                {
                    nameLbl.text = user_name
                }
                
                
                if let  review = dict.value(forKey: "reviewsAvg") as? Int
                {
                    let str = "\(review)"
                    
                    if str.contains(".")
                    {
                         ratingShow.text = str
                    }
                    else
                    {
                        ratingShow.text = str+".0"
                        
                    }
                    ratingV.rating = Double(review)
                    ratingV.isUserInteractionEnabled=false

                }
                if let  review = dict.value(forKey: "reviewsCount") as? Int
                {
                    if review == 0 || review == 1
                    {
                        let add = "("+"\(review)" + " Review" + ")"
                        //cell.ratingLbl.setTitle(add, for: .normal)
                        let attributeString = NSMutableAttributedString(string: add,attributes: yourAttributes)
                        ratingLbl.setAttributedTitle(attributeString, for: .normal)
                    }
                    else
                    {
                        let add = "("+"\(review)" + " Reviews" + ")"
                        let attributeString = NSMutableAttributedString(string: add,attributes: yourAttributes)
                        ratingLbl.setAttributedTitle(attributeString, for: .normal)
                        
                    }
                    
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
                                   if serviceName1.lowercased()==serviceName2.lowercased()
                                   {
                                    self.searviceNamelbl.text=serviceName2
                                       self.serviceCostLbl.text="$"+(dict.value(forKey: "servicePrice") as? String ?? "")
                                       self.topConst.constant=73
                                    self.detalHeightConst.constant=320

                                        self.serviceView.isHidden=false
                                   }
                                   else
                                   
                                   {
                                        self.serviceView.isHidden=true
                                      self.searviceNamelbl.text=""
                                       self.serviceCostLbl.text=""
                                       self.topConst.constant=13
                                    self.detalHeightConst.constant=260

                                   }
                                 }
                               
                             }
                           else
                                                  
                                                  {
                                                   self.serviceView.isHidden=true

                                                     self.searviceNamelbl.text=""
                                                      self.serviceCostLbl.text=""

                                        self.topConst.constant=13
                                        self.detalHeightConst.constant=260
                                                  }
                      }
            
            
                if let vendor_metaArray = dict.value(forKey: "vendor_meta") as? NSArray
                    
                {
                    if vendor_metaArray.count>0
                        
                    {
                        
                        let vendor_metaDict = vendor_metaArray.object(at: 0) as! NSDictionary
                        self.vendor_metaDict=vendor_metaDict
                       locLbl.text = vendor_metaDict.value(forKey: "address1") as? String
                        
                        
                        if let lat2 = vendor_metaDict.value(forKey: "Latitude") as? String
                        {
                         if let long2 = vendor_metaDict.value(forKey: "Longitude") as? String
                          {
                            
                                                    let lat3 = Double(lat2)!
                                                    let long3=Double(long2)!
                                                    
                                               let distance = self.Mycoordinate.distance(from: CLLocation(latitude: lat3, longitude: long3)) / 1000
                                            distanceLbl.text = String(format: "%.01fKm", distance) + " away"
                                                    
                                                    print(String(format: "The distance to my buddy is %.01fkm", distance))


                                                   
                                                   
                                           
                        }
                        }
                        

                        
                    }
                    else
                    {
                        locLbl.text = "Mohali, Punjab"
                    }
                    
                    
                    
                }
// customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "selectedmarker"), for: .normal)
       
        }
        else
        
        {
            customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "MarkerImage"), for: .normal)
            
            print(marker)
        }
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        marker.icon = GMSMarker.markerImage(with: YELLOWMARKERCOLOL)
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
      customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "MarkerImage"), for: .normal)
        self.markerDetailView.isHidden = true
        
       // customInfoWindow?.removeFromSuperview()
    }
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        let position = tappedMarker?.position
      //  customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "MarkerImage"), for: .normal)
        if position != nil
        {
            customInfoWindow?.center = mapView.projection.point(for: position!)
            customInfoWindow?.center.y -= 100
        }
        if let marker =  mapView.selectedMarker
        {

            customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "selectedmarker"), for: .normal)
        }
        else
        {
            customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "MarkerImage"), for: .normal)
        }
        
    }
    
    
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker)
    {
        print("amar d gh h df")
        if let marker =  mapView.selectedMarker
        {
customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "MarkerImage"), for: .normal)
            
        }
        
    }
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView?
    {
        let imageIcon = UIButton(frame: CGRect(x: 25, y: 0, width: 50, height: 50))
        imageIcon.setBackgroundImage(UIImage(named: "AppIcon-2"), for: .normal)
        
customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "MarkerImage"), for: .normal)
        //view.addSubview(imageIcon)
        
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return nil }
        // let data = previewDemoData[customMarkerView.tag]
        //restaurantPreviewView.setData(img:UIImage(named: "AppIcon-2")!)
        return UIView()//restaurantPreviewView
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker)
    {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "MarkerImage"), for: .normal)
        
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        
        //marker.icon = GMSMarker.markerImage(with: YELLOWMARKERCOLOL)
        customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "MarkerImage"), for: .normal)
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.darkGray, tag: customMarkerView.tag)
        marker.iconView = customMarker
    }
    
    
    // MARK: GOOGLE AUTO COMPLETE DELEGATE
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        
        // showPartyMarkers(lat: lat, long: long)
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        myMapView.camera = camera
        //  txtFieldSearch.text=place.formattedAddress
        chosenPlace = MyPlace(name: place.formattedAddress!, lat: lat, long: long)
        let marker=GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = "\(place.name)"
        marker.snippet = "\(place.formattedAddress!)"
        marker.map = myMapView
        
        self.dismiss(animated: true, completion: nil) // dismiss after place selected
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension MapViewController
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
        
        var apiKey = "1234"
        if let newuserEmail1 = DEFAULT.value(forKey: "APITOKEN") as? String
        {
            apiKey = "\(newuserEmail1)"
        }
        let header = ["device-id":"123456","device-type":"iOS","type":"iOS","api-token":apiKey] as [String:String]
        
        ApiHandler.apiDataPostMethod(url: SINGLECATDATAAPI, parameters: params, Header: header) { (response, error) in
            
            if error == nil
            {
                print(response)
                if let dict = response as? NSDictionary
                {
                    if let dataArray = dict.value(forKey: "data") as? NSArray
                    {
                        
                        self.allMarkerArray = dataArray.mutableCopy() as! NSMutableArray
                        
                        
                    }
                    
                }
                self.showPartyMarkers()
            }
            else
            {
                self.view.makeToast(error)
            }
        }
    }
    
    
    
    // MARK: show all Markers method setup
    
    func showPartyMarkers()
    {
        myMapView.clear()
        if markers.count>0
        {
            self.markers.removeAll()
        }
        for i in 0..<self.allMarkerArray.count
        {
            let dict = self.allMarkerArray.object(at: i) as! NSDictionary
           
            if let vendor_metaArray = dict.value(forKey: "vendor_meta") as? NSArray
            {
                 if vendor_metaArray.count>0
                 {
                    let vendor_metaDict = vendor_metaArray.object(at: 0) as! NSDictionary
                    let marker=GMSMarker()
                    //  let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: UIImage(named: "NewYellowMarker2")!, borderColor: UIColor.clear, tag: i)
                    
                    // marker.iconView=customMarker
                    
                    
                    
                    if let lat2 = vendor_metaDict.value(forKey: "Latitude") as? String
                    {
                        let lat = Double(lat2)
                        if let long2 = vendor_metaDict.value(forKey: "Longitude") as? String
                        {
                            let long = Double(long2)
                            
                              marker.position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
                          //  marker.position = CLLocationCoordinate2D(latitude: 30.7046, longitude: 76.7179)
                            customInfoWindow?.groupName.layer.cornerRadius = 5
                            
                            //  customInfoWindow?.groupName.textColor =
                            
                            customInfoWindow?.frame = CGRect(x: 0, y: 0, width: 124, height: 76)
                            customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "MarkerImage"), for: .normal)
                            if let vendor_servicesArray = dict.value(forKey: "vendor_services") as? NSArray
                                                  {
                                                       if vendor_servicesArray.count>0
                                                       {
                                                            customInfoWindow?.groupName.isHidden=false
                                                           let vendor_metaDict = vendor_servicesArray.object(at: 0) as! NSDictionary
                                                           let servicePrice = vendor_metaDict.value(forKey: "servicePrice") as? String
                                                           customInfoWindow?.groupName.text  = " $"+(servicePrice ?? "100")+" "
                                                    
               //  marker.title=" $"+(servicePrice ?? "100")+" "
                                                          //  marker.snippet = " $"+(servicePrice ?? "100")+" "
                            if DEFAULT.value(forKey: "avgprice") != nil
                            {
                                customInfoWindow?.groupName.isHidden=false
                                customInfoWindow?.groupName.text  = " $"+(DEFAULT.value(forKey: "avgprice") as? String ?? "100")+" "
                            }
                                  else
                            {
                                customInfoWindow?.groupName.isHidden=true
                                
                                }
                                                
                                                        
                                }
                                                   else
                                                       {
                                                           customInfoWindow?.groupName.isHidden=true//  = " $"+(servicePrice ?? "100")+" "
                                                      }
                                                }
                                       else
                                        {
                                            customInfoWindow?.groupName.isHidden=true//  = " $"+(servicePrice ?? "100")+" "
                                       }
                            marker.iconView = customInfoWindow
                            
                           
                           // customInfoWindow?.groupName.isHidden=true
                            
                            markers.append(marker)
                            marker.map = self.myMapView
                        }
                    }
                  
            
                    
                }
            }
            
            
          
        }
    }
    
    
}
extension String
{
    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / M_PI
    }
    func deg2rad(deg:Double) -> Double {
        return deg * M_PI / 180
    }

    func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double, unit:String) -> Double {
        let theta = lon1 - lon2
        var dist = sin(rad2deg(rad: lat1)) * sin(deg2rad(deg: lat2)) + cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) * cos(deg2rad(deg: theta))
        dist = acos(dist)
        dist = rad2deg(rad: dist)
        dist = dist * 60 * 1.1515
        if (unit == "K") {
            dist = dist * 1.609344
        }
        else if (unit == "N") {
            dist = dist * 0.8684
        }
        return dist
    }
    
}
extension MapViewController:UIPopoverPresentationControllerDelegate
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
