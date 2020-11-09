//
//  DirectionViewController.swift
//  Dental Place
//
//  Created by AMARENDRA on 03/04/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import SVProgressHUD
import FloatRatingView
import Alamofire
import SwiftyJSON

class DirectionViewController: UIViewController {

    
    
    var singleCatDat:CatListModel?
    let yourAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.init(red: 106/255, green: 134/255, blue: 165/255, alpha: 1),
        .underlineStyle: NSUnderlineStyle.single.rawValue]
    

    var selectedMarkerIndex=0
    
    
    
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
    

    var destLat="30.7054"
    var destLong="76.7178"
    
    var sourceLat="30.7044"
    var sourceLong="76.7179"
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
         myMapView.delegate=self
        
        self.customInfoWindow = MarkerDialog().loadView()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
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
    
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true

        print("distance=")
        print("distance= ".distance(lat1: Double(30.7044), lon1: Double(76.7179), lat2: Double(30.5044), lon2: Double(76.7199), unit: "K"), "Km")
        if let loc=DEFAULT.value(forKey: "CURRENTLOCATION") as? String

        {
          //  self.currentLoc.text=loc
        }
        customInfoWindow?.removeFromSuperview()
        myMapView.delegate=self
        self.customInfoWindow = MarkerDialog().loadView()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        initGoogleMaps()
        
      
        
    }
    
    @IBAction func goback(_ sender: Any)
      {
        
          self.navigationController?.popViewController(animated: true)
      }
    
    
    //MARK:- Map init code
    func initGoogleMaps() {
//        let camera = GMSCameraPosition.camera(withLatitude: CURRENTLOCATIONLAT, longitude: CURRENTLOCATIONLONG, zoom: 17.0)
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(destLat)!, longitude: Double(destLong)!, zoom: 12.0)
        let marker = GMSMarker()

        marker.position = CLLocationCoordinate2D(latitude: Double(destLat)!, longitude: Double(destLat)!)
         marker.title = "Mobiloitte"
         marker.snippet = "India"
        marker.map = self.myMapView
        
        self.myMapView.camera = camera
        self.myMapView.delegate = self
        self.myMapView.settings.compassButton = true
        self.myMapView.settings.myLocationButton=true
        self.myMapView.isMyLocationEnabled = true
        
        
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: Double(sourceLat)!, longitude: Double(sourceLong)!)
//                marker.title = "Mobiloitte"
//                marker.snippet = "India"
//               marker.map = myMapView
//
//                //28.643091, 77.218280
//                let marker1 = GMSMarker()
//                marker1.position = CLLocationCoordinate2D(latitude: Double(destLat)!, longitude: Double(destLong)!)
//                marker1.title = "NewDelhi"
//                marker1.snippet = "India"
//                marker1.map = myMapView
//        //Setting the start and end location
//         let origin = "\(28.524555),\(77.275111)"
//         let destination = "\(28.643091),\(77.218280)"
         /*
         
         let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyCIP5XpjREmM2JXWNg4CiKnK2-56xekAd4"
         
         //Rrequesting Alamofire and SwiftyJSON
         Alamofire.request(url).responseJSON { response in
             print(response.request as Any)  // original URL request
             print(response.response as Any) // HTTP URL response
             print(response.data as Any)     // server data
             print(response.result)   // result of response serialization
            do
             {
                let json = try JSON(data: response.data!)
                print(json)
                           let routes = json["routes"].arrayValue
                           
                           for route in routes
                           {
                               let routeOverviewPolyline = route["overview_polyline"].dictionary
                               let points = routeOverviewPolyline?["points"]?.stringValue
                               let path = GMSPath.init(fromEncodedPath: points!)
                               let polyline = GMSPolyline.init(path: path)
                               polyline.strokeColor = UIColor.blue
                               polyline.strokeWidth = 2
                               polyline.map = self.myMapView
                           }
            }
            catch let error
            {
                print(error)
            }
           
         }
*/
         
          // Creates a marker in the center of the map.
        
        
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
      vc.cellData=self.allMarkerArray.object(at: self.selectedMarkerIndex) as! NSDictionary
        
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    

}
//MARK:- Mapm Work

extension DirectionViewController:CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate
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
        CURRENTLOCATIONLONG=long
                              CURRENTLOCATIONLAT=lat
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(long))
                marker.title = "Mobiloitte"
                marker.snippet = "India"
               marker.map = myMapView
                
                //28.643091, 77.218280
                let marker1 = GMSMarker()
                marker1.position = CLLocationCoordinate2D(latitude: Double(destLat)!, longitude: Double(destLong)!)
                marker1.title = "NewDelhi"
                marker1.snippet = "India"
                marker1.map = myMapView
        
        self.myMapView.animate(to: camera)
        
        // showPartyMarkers(lat: lat, long: long)
    }
    
    //MARK:-  Marker tap
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        NSLog("marker was tapped")
        tappedMarker = marker
   
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
       // marker.icon = GMSMarker.markerImage(with: YELLOWMARKERCOLOL)
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        if let marker =  mapView.selectedMarker
        {
           // marker.icon = GMSMarker.markerImage(with: YELLOWMARKERCOLOL)
        }
        
        
       // customInfoWindow?.removeFromSuperview()
    }
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        let position = tappedMarker?.position
        if position != nil
        {
            customInfoWindow?.center = mapView.projection.point(for: position!)
            customInfoWindow?.center.y -= 100
        }
        if let marker =  mapView.selectedMarker
        {
            //.icon = GMSMarker.markerImage(with: YELLOWMARKERCOLOL)
        }
        
    }
    
    
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker)
    {
        print("amar d gh h df")
        if let marker =  mapView.selectedMarker
        {
          //  marker.icon = GMSMarker.markerImage(with: YELLOWMARKERCOLOL)
        }
        
    }
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView?
    {
        let imageIcon = UIButton(frame: CGRect(x: 25, y: 0, width: 50, height: 50))
        imageIcon.setBackgroundImage(UIImage(named: "AppIcon-2"), for: .normal)
        
       // marker.icon = GMSMarker.markerImage(with: YELLOWMARKERCOLOL)
        //view.addSubview(imageIcon)
        
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return nil }
        // let data = previewDemoData[customMarkerView.tag]
        //restaurantPreviewView.setData(img:UIImage(named: "AppIcon-2")!)
        return UIView()//restaurantPreviewView
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker)
    {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        marker.icon = GMSMarker.markerImage(with: YELLOWMARKERCOLOL)
        
        
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        
        marker.icon = GMSMarker.markerImage(with: YELLOWMARKERCOLOL)
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
