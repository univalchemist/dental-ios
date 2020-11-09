//
//  ListMapTabViewController.swift
//  Dental Place
//
//  Created by eWeb on 17/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import  UIKit
import PageMenu
import SVProgressHUD
import CoreLocation
import MapKit
import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import SVProgressHUD
import FloatRatingView



class ListMapTabViewController: UIViewController
{
    var yelpReviewArray=NSMutableArray()
           var yelp_id = ""
    
    var pageMenu : CAPSPageMenu?
    var controllerArray : [UIViewController] = []
//    @IBOutlet weak var topView: UIImageView!
    var parametersGreen : [CAPSPageMenuOption]!
    var parameters: [CAPSPageMenuOption]!
    var currentPageIndex = 0
   //  @IBOutlet weak var filterSelectedBtn: UIView!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var filterLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    var filterSelected = ""
    var searchId = ""
    var searchedText = ""
     @IBOutlet weak var ClustercollectionView: UICollectionView!
    //MARK:- List work
     @IBOutlet weak var mapViewBtn: UIButton!
       @IBOutlet weak var listViewBtn: UIButton!
    @IBOutlet weak var listlineView: UIView!
    @IBOutlet weak var listUIView: UIView!
    
    @IBOutlet weak var mapLineView: UIView!
    @IBOutlet weak var mapUIVIEW: UIView!
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
    
    
    //MARK:- Map work
    
     var homecell:SearchServiceTableViewCell?
    
    
    @IBOutlet weak var priceview: UIView!
       
       @IBOutlet weak var locaView: UIView!
       
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
       @IBOutlet weak var ratingBtn: UIButton!
       @IBOutlet weak var closeLbl: UILabel!
       @IBOutlet weak var openlbl: UILabel!
       @IBOutlet weak var locLbl: UILabel!
       @IBOutlet weak var nameLbl: UILabel!
       
      // @IBOutlet weak var ratingNumber: UILabel!
       @IBOutlet weak var profileImg: UIImageView!
       
       @IBOutlet weak var ratingShow: UILabel!
       
       
       let currentLocationMarker = GMSMarker()
       var chosenPlace: MyPlace?
       
       let customMarkerWidth: Int = 50
       let customMarkerHeight: Int = 70
       
       var currentLat = ""
       var currentLong = ""
       

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
    override func viewDidLoad()
    {
        super.viewDidLoad()
        filterLbl.sizeToFit()
         priceLbl.sizeToFit()
         ratingLbl.sizeToFit()
        
        self.ClustercollectionView.delegate=self
               self.ClustercollectionView.dataSource=self
               
               self.ClustercollectionView.register(UINib(nibName: "ClusterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ClusterCollectionViewCell")
               
          priceview.layer.cornerRadius = 4
        
              filterLbl.dropShadow(color: .black, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 10, scale: true)
              
              filterLbl.layer.cornerRadius = 10
              filterLbl.clipsToBounds = true
              //Comment here
              
              
              
              locaView.layer.shadowPath = UIBezierPath(rect: priceview.bounds).cgPath
              locaView.layer.shadowRadius = 5
              locaView.layer.shadowOffset = .zero
              locaView.layer.shadowOpacity = 1
              locaView.layer.shadowColor = UIColor.gray.cgColor

              
             // locaView.dropShadow(color: .black, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 20, scale: true)
              
              locaView.layer.cornerRadius = 4
        
        self.mapUIVIEW.isHidden=true
        self.markerDetailView.isHidden=true
        self.ClustercollectionView.isHidden=true
        self.filterLbl.textAlignment = .center
        if let searchedText = DEFAULT.value(forKey: "CategoryName") as? String
        {
           self.filterLbl.text="   "+searchedText+"   "
            self.searchText.text=searchedText
        }
        else
        {
            self.filterLbl.text="  All  "
           
        }
    myMapView.delegate=self
             self.customInfoWindow = MarkerDialog().loadView()
             
             locationManager.delegate = self
             locationManager.requestWhenInUseAuthorization()
             locationManager.startUpdatingLocation()
             locationManager.startMonitoringSignificantLocationChanges()
             
             initGoogleMaps()
        //MARK:- marker work
        if let loc=DEFAULT.value(forKey: "CURRENTLOCATION") as? String
            {
                self.currentLoc.text=loc
            }
        
                   if let avgprice=DEFAULT.value(forKey: "avgprice") as? String
                       {
                        self.avgLbl.isHidden=false

                        
                        self.avgLbl.isHidden=false

            self.avgLbl.isHidden=false
            self.avgLbl.text=" Avg. Price: "+"$"+avgprice + " "
                        
                self.avgLbl.attributedText = self.attributedString(from: self.avgLbl.text!, nonBoldRange: NSRange(location: 0,length: 13))//attributedString
                                        
                                        
                        
                        
                        
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

                      self.priceview.isHidden=false
                      self.priceview.backgroundColor=UIColor.clear
                   }
            customInfoWindow?.removeFromSuperview()
        self.initGoogleMaps()
        
       
        filterLbl.clipsToBounds = true
        
        
               listMapTable.register(UINib(nibName: "ListAndMapTableCell", bundle: nil), forCellReuseIdentifier: "ListAndMapTableCell")

                      listMapTable.register(UINib(nibName: "SearchServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchServiceTableViewCell")

                       self.nodatafoundLbl?.isHidden=true
       
                     
               
        
//        parametersGreen = [
//            .scrollMenuBackgroundColor(UIColor .clear),
//            .viewBackgroundColor(UIColor.clear),
//            .selectionIndicatorColor(UIColor.clear),
//            .bottomMenuHairlineColor(UIColor.clear),
//            .selectedMenuItemLabelColor (APPCOLOL) ,
//            .menuItemFont(UIFont(name: "FiraSans-SemiBold", size: 15.0)!),
//            .menuHeight(40.0),
//            .menuItemWidth(UIScreen.main.bounds.width/2),
//            .centerMenuItems(false),
//            .unselectedMenuItemLabelColor(SELECTEDLINECOLOL)
//        ]
        
       // if UIDevice().userInterfaceIdiom == .phone
//        {
//            switch UIScreen.main.nativeBounds.height
//            {
//            case 1136:
//
//                print("iPhone 5 or 5S or 5C")
//                parametersGreen = [
//                    .scrollMenuBackgroundColor(UIColor .clear),
//                    .viewBackgroundColor(UIColor.clear),
//                    .selectionIndicatorColor(SELECTEDLINECOLOL),
//                    .bottomMenuHairlineColor(UIColor.clear),
//                    .selectedMenuItemLabelColor (APPCOLOL) ,
//                    .menuItemFont(UIFont(name: "FiraSans-Bold", size: 13.0)!),
//                    .menuHeight(50.0),
//                    .menuItemWidth(UIScreen.main.bounds.width/2),
//                    .centerMenuItems(false)
//                ]
//            case 1334:
//                print("iPhone 6/6S/7/8")
//                parametersGreen = [
//                    .scrollMenuBackgroundColor(UIColor .clear),
//                    .viewBackgroundColor(UIColor.clear),
//                    .selectionIndicatorColor(SELECTEDLINECOLOL),
//                    .bottomMenuHairlineColor(UIColor.clear),
//                    .selectedMenuItemLabelColor (APPCOLOL) ,
//                    .menuItemFont(UIFont(name: "FiraSans-Bold", size: 14.0)!),
//                    .menuHeight(50.0),
//                    .menuItemWidth(UIScreen.main.bounds.width/2),
//                    .centerMenuItems(false)
//
//                ]
//            case 1920, 2208:
//                print("iPhone 6+/6S+/7+/8+")
//                parametersGreen = [
//                    .scrollMenuBackgroundColor(UIColor .clear),
//                    .viewBackgroundColor(UIColor.clear),
//                    .selectionIndicatorColor(SELECTEDLINECOLOL),
//                    .bottomMenuHairlineColor(UIColor.clear),
//                    .selectedMenuItemLabelColor (APPCOLOL) ,
//                    .menuItemFont(UIFont(name: "FiraSans-Bold", size: 16.0)!),
//                    .menuHeight(50.0),
//                    .menuItemWidth(UIScreen.main.bounds.width/2),
//
//                    .centerMenuItems(false)
//                ]
//            case 2436:
//                print("iPhone X")
//                parametersGreen = [
//                    .scrollMenuBackgroundColor(UIColor .clear),
//                    .viewBackgroundColor(UIColor.clear),
//                    .selectionIndicatorColor(SELECTEDLINECOLOL),
//                    .bottomMenuHairlineColor(UIColor.clear),
//                    .selectedMenuItemLabelColor (APPCOLOL) ,
//                    .menuItemFont(UIFont(name: "FiraSans-Bold", size: 16.0)!),
//                    .menuHeight(50.0),
//                    .menuItemWidth(UIScreen.main.bounds.width/2),
//
//                    .centerMenuItems(false)
//                ]
//            default:
//                print("unknown")
//                parametersGreen = [
//                    .scrollMenuBackgroundColor(UIColor .clear),
//                    .viewBackgroundColor(UIColor.clear),
//                    .selectionIndicatorColor(SELECTEDLINECOLOL),
//                    .bottomMenuHairlineColor(UIColor.clear),
//                    .selectedMenuItemLabelColor (APPCOLOL) ,
//                    .menuItemFont(UIFont(name: "FiraSans-Bold", size: 16.0)!),
//                    .menuHeight(50.0),
//                    .menuItemWidth(UIScreen.main.bounds.width/2),
//
//                    .centerMenuItems(false)
//                ]
//            }
//        }
        
        
        //        parametersGreen = [
        //            .scrollMenuBackgroundColor(UIColor .white),
        //            .viewBackgroundColor(UIColor.clear),
        //            .selectionIndicatorColor(SELECTEDLINECOLOL),
        //            .bottomMenuHairlineColor(UIColor.clear),
        //            .selectedMenuItemLabelColor (APPCOLOL) ,
        //            .menuItemFont(UIFont(name: "HelveticaNeue", size: 17.0)!),
        //            .menuHeight(50.0),
        //            .menuItemWidth(UIScreen.main.bounds.width/2),
        //            .menuItemWidthBasedOnTitleTextWidth (true),
        //            .centerMenuItems(true)
        //        ]
        
//        let controller : UIViewController = self.storyboard?.instantiateViewController(withIdentifier:"MapAndListView")as! MapAndListView
//
//        controller.title = "List View"
//        controllerArray.append(controller)
//
//        let controller2 : UIViewController = self.storyboard?.instantiateViewController(withIdentifier:"MapViewController")as! MapViewController
//
//        controller2.title = "Map View"
//        controllerArray.append(controller2)
//
//
//        var val = CGRect()
//        parameters = [
//            .menuItemSeparatorWidth(4.3),
//            .useMenuLikeSegmentedControl(true),
//            .menuItemSeparatorPercentageHeight(0.1)
//        ]
//        let height = 95+UIApplication.shared.statusBarFrame.height
//        val = CGRect(x: 0, y: height, width: self.view.frame.width, height: self.view.frame.height-height)
//        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: val, pageMenuOptions: parametersGreen)
//
//
      //  self.addChild(pageMenu!)
      //  self.view.addSubview(pageMenu!.view)
        
    }
    func attributedString(from string: String, nonBoldRange: NSRange?) -> NSAttributedString {
        let fontSize = UIFont.systemFontSize
        let attrs = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize),
            NSAttributedString.Key.foregroundColor: APPCOLOL
        ]
        let nonBoldAttribute = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
        ]
        let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
        if let range = nonBoldRange {
            attrStr.setAttributes(nonBoldAttribute, range: range)
        }
        return attrStr
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
       
             self.nodatafoundLbl?.isHidden=true
             
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
        print("currentPageIndex = \(currentPageIndex)")
        if let rating = DEFAULT.value(forKey: "SELECTEDFILTER") as? String
                     {
                        if rating == "0"
                        {
                            self.ratingLbl.textColor=UIColor.clear
                        self.ratingLbl.backgroundColor=UIColor.clear
                        self.ratingLbl.isHidden=false
                        }
                        else
                        {
                            self.ratingLbl.text="  "+rating+"+ Stars"
                            ratingLbl.dropShadow(color: .black, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 20, scale: true)
                                   ratingLbl.layer.cornerRadius = 15
                                   ratingLbl.clipsToBounds = true
                            self.ratingLbl.isHidden=false
                        }
                        

                     }
                        else
                            {
                                self.ratingLbl.textColor=UIColor.clear
                                self.ratingLbl.backgroundColor=UIColor.clear
                                self.ratingLbl.isHidden=false
                                
                                 self.filterLbl.text="  All  "//"   "+searchedText+"   "
                                self.searchText.text=""//"  All  "
                                
        }
                         if let minimum = DEFAULT.value(forKey: "minimum") as? String
                         {
                             if let maximum = DEFAULT.value(forKey: "maximum") as? String
                             {
                                 self.priceLbl.text=" $"+"\(minimum)"+"-"+"$"+"\(maximum)"+" "
                                priceLbl.dropShadow(color: .black, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 20, scale: true)
                                priceLbl.layer.cornerRadius = 15
                                priceLbl.clipsToBounds = true
                                
                             }
                             else
                             {
                                 self.priceLbl.textColor=UIColor.clear
                                 self.priceLbl.backgroundColor=UIColor.clear
                             }
                         }
                     else
                     {
                         self.priceLbl.textColor=UIColor.clear
                        self.priceLbl.backgroundColor=UIColor.clear

                     }
//        if let searchedText = DEFAULT.value(forKey: "CategoryName") as? String
//               {
//                  self.filterLbl.text="   "+searchedText+"   "
//                   self.searchText.text=searchedText
//               }
//               else
//               {
//                   self.filterLbl.text="  All  "
//               }
             DEFAULT.set(self.filterLbl.text!,forKey: "currentCat")
             DEFAULT.synchronize()
                     
    }
    
    @IBAction func filterBtn(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchBtn(_ sender: UIButton)
      {
          let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchView") as! SearchView
          self.navigationController?.pushViewController(vc, animated: true)
      }
    
    @IBAction func listViewBtnAct(_ sender: UIButton)
    {
        self.mapUIVIEW.isHidden=true
        
       self.listUIView.isHidden=false
        self.listViewBtn.setTitleColor(APPCOLOL, for: .normal)
            self.mapViewBtn.setTitleColor(SELECTEDLINECOLOL, for: .normal)
        
        
        
        self.listlineView.backgroundColor=APPCOLOL
        self.mapLineView.backgroundColor=SELECTEDLINECOLOL
    }
    
    @IBAction func mapViewAction(_ sender: UIButton)
    {
        self.listlineView.backgroundColor=SELECTEDLINECOLOL
        self.listViewBtn.setTitleColor(SELECTEDLINECOLOL, for: .normal)
        self.mapViewBtn.setTitleColor(APPCOLOL, for: .normal)
        self.mapLineView.backgroundColor=APPCOLOL
        self.mapUIVIEW.isHidden=false
        self.listUIView.isHidden=false
        
    }
}
extension ListMapTabViewController:UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return self.allMarkerArray.count//self.singleCatDat?.data?.count ?? 0 //5
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "ListAndMapTableCell") as! ListAndMapTableCell
             let cell = tableView.dequeueReusableCell(withIdentifier: "SearchServiceTableViewCell") as! SearchServiceTableViewCell
            self.homecell=cell
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
                                let avgprice=DEFAULT.value(forKey: "avgprice") as? String ?? ""
                                       
                            if value == "  All  "
                                       
                            {
//                                cell.serviceView.isHidden=true
//                                                                                cell.searviceNamelbl.text=""
//                                                    cell.serviceCostLbl.text=""
//                                                            cell.topConst.constant=13
//
//
                                if avgprice == ""
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
                            cell.serviceCostLbl.text="$"+(dict.value(forKey: "servicePrice") as? String ?? "")
                                                                       cell.topConst.constant=73
                                                                        cell.serviceView.isHidden=false
                                                                       break
                            }
                        }
                                
                                
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
                        var openTime = openDict.value(forKey: dayOfWeak) as? String ?? "00:00"
                      //  {
                         print("open time = \(openTime)")
                            if openTime.contains("00:00")
                    {
                            cell.openlbl.isHidden = true
                            cell.closeLbl.isHidden=false
                         cell.closeLbl.text = "Closed"
                                }
                            else
                                                
                        {
                        if let openDict = vendor_metaDict.value(forKey: "close") as? NSDictionary
                            {
                            var closeTime = openDict.value(forKey: dayOfWeak) as? String ?? "00:00"
                            
                                print("close time = \(openTime)")
                        cell.openlbl.text = "\(dayOfWeak)"+" "+openTime+"-"+closeTime
                        cell.closeLbl.text = "Open"
     
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
                                             if self.isOpenClinic(OpenTime: openTime) == true
                                                                   {
                                                                     
                                                                        cell.closeLbl.text = "Open"
                                                                       if self.isClosedClinic(closetime: closeTime) == true
                                                                       {
                                                                          cell.closeLbl.text = "Closed"
                                                                       }
                                                                       else if self.isClosedClinic(closetime: closeTime) == false
                                                                       {
                                                                              cell.closeLbl.text = "Open"
                                                                       }
                                                                       else
                                                                       {
                                                                          cell.closeLbl.text = ""//"Open"
                                                                       }

                                                                   }
                                                                   else
                                                                   {
                                                                        cell.closeLbl.text = "Closed"
                                                                }
                                                              
//                                                              if self.isClosedClinic(closetime: closeTime) == true
//                                                              {
//                                                                 cell.closeLbl.text = "Closed"
//                                                              }
//                                                                 else if self.isClosedClinic(closetime: closeTime) == false
//                                                                  {
//                                                                     cell.closeLbl.text = "Open"
//                                                                  }
//                                                              else
//                                                              {
//                                                                  cell.closeLbl.text = ""//"Open"
//                                                              }
                                
                                
                    cell.openlbl.isHidden=false
                    cell.closeLbl.isHidden=false
                    
                               
                    }
                    }
                       // }
                        
                       
                        
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
                  cell.ratingNumber.text = str
                }
                else
                {
                    cell.ratingNumber.text = str+".0"
                    
                }
                cell.ratingV.rating = Double(review)
                cell.ratingV.isUserInteractionEnabled=false
            }
            else
            {
                   cell.ratingV.rating = Double(0)
                cell.ratingNumber.text = "0"

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
            
            else
            {
                              let add = "("+"0" + " Review" + ")"
                                   //cell.ratingLbl.setTitle(add, for: .normal)
                                   let attributeString = NSMutableAttributedString(string: add,attributes: yourAttributes)
                cell.ratingLbl.setAttributedTitle(attributeString, for: .normal)
            }
            if let vendor_metaArray = dict.value(forKey: "vendor_meta") as? NSArray
                
            {
                if vendor_metaArray.count>0
                    
                {
                    
                    let vendor_metaDict = vendor_metaArray.object(at: 0) as! NSDictionary
                    
                    let city =  vendor_metaDict.value(forKey: "state") as? String ?? ""
                    let country =  vendor_metaDict.value(forKey: "country") as? String ?? ""
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
                            yelprating =  Double(Int(yelp_avg_Rating2)/self.yelpReviewArray.count)
                        }
                         else{
                            yelprating =  Double(yelp_avg_Rating2)
                        }
                       
                    let userrating = dict.value(forKey: "reviewsAvg") as? Double ?? 0.0
                        var totalvg = 0.0
                      if userrating == 0.0 || userrating == 0
                      {
                         totalvg = (yelprating)

                    }
                    else if yelprating == 0
                      {
                        totalvg = (userrating)
                        }
                        else
                      {
                         totalvg = (yelprating+userrating)/2

                    }
                                                                
                    cell.ratingNumber.text = String(totalvg.round(to: 2))
                    cell.ratingV.rating = Double(totalvg)
                    let userReview = dict.value(forKey: "reviewsCount") as? Int ?? 0
                    let yelpReview = self.yelpReviewArray.count
                    let totalReview = (userReview+yelpReview)


                                                                
                      
                                                    if totalReview == 0 || totalReview == 1
                                                                    {
                                                                        let add = "("+"\(totalReview)" + " Review" + ")"
                                                                        //cell.ratingLbl.setTitle(add, for: .normal)
                                                                        let attributeString = NSMutableAttributedString(string: add,attributes: self.yourAttributes)
                                                                        cell.ratingLbl.setAttributedTitle(attributeString, for: .normal)
                                                                    }
                                                                    else
                                                                    {
                                                                        let add = "("+"\(totalReview)" + " Reviews" + ")"
                                                                        let attributeString = NSMutableAttributedString(string: add,attributes: self.yourAttributes)
                                                                        cell.ratingLbl.setAttributedTitle(attributeString, for: .normal)
                                                                        
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
              vc.closeOpenStatus = self.homecell?.closeLbl.text! ?? "Closed"
            self.navigationController?.pushViewController(vc, animated: true)

            
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
           
          //  let value=DEFAULT.value(forKey: "currentCat") as? String ?? ""
            let value=DEFAULT.value(forKey: "currentCat") as? String ?? ""
                       let avgprice=DEFAULT.value(forKey: "avgprice") as? String ?? ""
                       
                       if value == "  All  "
                       {
                           if avgprice == ""
                           {
                               return 280
                           }
                           else
                               
                           {
                               return 340
                           }
                           
                       }
                       else
                       {
                           return 340
                           
                       }
            
//            if value == "  All  "
//            {
//               return 280
//            }
//            else
//            {
//                return 340
//
//            }
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
           @objc func BookAction(_ sender:UIButton)
           {
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
               let dict = self.allMarkerArray.object(at: sender.tag) as! NSDictionary
                      
                      print(dict)
           
                      let id = dict.value(forKey: "id") as? Int ?? 0
                      
                      vc.clinicId="\(id)"
                   vc.closeOpenStatus = self.homecell?.closeLbl.text! ?? "Closed"
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
    
    
    
    
    
    @objc func BookAction2(_ sender:UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        let dict = self.allMarkerArray.object(at: sender.tag) as! NSDictionary
               
               print(dict)
    
               let id = dict.value(forKey: "id") as? Int ?? 0
               
               vc.clinicId="\(id)"
            vc.closeOpenStatus = self.homecell?.closeLbl.text! ?? "Closed"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func TimeTableAction2(_ sender:UIButton)
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
    
    
    
    @IBAction func MapbookApp(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
      let dict=self.allMarkerArray.object(at: self.selectedMarkerIndex) as! NSDictionary
        let id = dict.value(forKey: "id") as? Int ?? 0
               
               vc.clinicId="\(id)"
        vc.closeOpenStatus = self.homecell?.closeLbl.text! ?? "Closed"
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func MapTimeTableAction(_ sender:UIButton)
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


extension ListMapTabViewController
{
    //MARK:- catlist Api
    
    func CategoryBasedDataAPI()
    {
        
        
        var params = ["type" : "a"] as [String:String]
        let servicesId = DEFAULT.value(forKey: "CategoryId") as? String ?? "0"
        let rating = DEFAULT.value(forKey: "SELECTEDFILTER") as? String ?? "-1"
        let minimum = DEFAULT.value(forKey: "minimum") as? String ?? "0"
        let maximum = DEFAULT.value(forKey: "maximum") as? String ?? "1000"
        let CURRENTLAT = DEFAULT.value(forKey: "CURRENTLAT") as? String ?? "32.3534"
        let CURRENTLONG = DEFAULT.value(forKey: "CURRENTLONG") as? String ?? "76.4545"
               
        
        //lat:32.3534
       // long:76.4545
       
    
     if servicesId != "" && servicesId != "0" && rating != "" && rating != "-1" && minimum != "" && minimum != "0" && maximum != "" && maximum != "0"
                         {
                            params = ["servicesId":servicesId,"type" : "a","ratiningRange":rating,"minimum" : minimum,"maximum":maximum,"lat":CURRENTLAT,"long":CURRENTLONG]
                            
                         }
                         else  if  servicesId != "" && servicesId != "0" &&  minimum != "" && minimum != "0" && maximum != "" && maximum != "0"
                           {
                       params = ["servicesId":servicesId,"type" : "a","ratiningRange":rating,"minimum" : minimum,"maximum":maximum,"lat":CURRENTLAT,"long":CURRENTLONG]

                                   }
               
                          else if servicesId != "" && servicesId != "0" && rating != "" && rating != "-1"
                                            {
                                            params = ["servicesId":servicesId,"type" : "a","ratiningRange":rating,"minimum" : minimum,"maximum":maximum,"lat":CURRENTLAT,"long":CURRENTLONG]

                                            }
                           
                 //            else if rating != "" && rating != "-1"
                 //                              {
                 //                              params = ["type" : "a","ratiningRange":rating,"minimum" : minimum,"maximum":maximum]
                 //                              }
                            else if servicesId != "" && servicesId != "0"
                                    {
                                        params = ["type" : "a","servicesId":servicesId,"lat":CURRENTLAT,"long":CURRENTLONG]
                                    }
                                   
                         else
                         
                         {
                             params = ["type" : "a","lat":CURRENTLAT,"long":CURRENTLONG]
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
                        self.showPartyMarkers()
                        self.ClustercollectionView.reloadData()
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
                             //customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "MarkerImage"), for: .normal)
                            
                             customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "selectedmarker"), for: .normal)
                             if let vendor_servicesArray = dict.value(forKey: "vendor_services") as? NSArray
                                                   {
                                                        if vendor_servicesArray.count>0
                                                        {
                                                             customInfoWindow?.groupName.isHidden=false
                                                            let vendor_metaDict = vendor_servicesArray.object(at: 0) as! NSDictionary
                                                           
//                                                            customInfoWindow?.groupName.text  = " $"+(servicePrice ?? "100")+" "
                                                     
                //  marker.title=" $"+(servicePrice ?? "100")+" "
                                                           //  marker.snippet = " $"+(servicePrice ?? "100")+" "
                             if DEFAULT.value(forKey: "avgprice") != nil
                             {
                                 customInfoWindow?.groupName.isHidden=false
                                 let servicePrice = vendor_metaDict.value(forKey: "servicePrice") as? String
                                customInfoWindow?.groupName.text  = " $"+(servicePrice ?? "100")+" "
//                                 customInfoWindow?.groupName.text  = " $"+(DEFAULT.value(forKey: "avgprice") as? String ?? "100")+" "
                                
                                marker.iconView = customInfoWindow
                                                           
                                                          
                                                          // customInfoWindow?.groupName.isHidden=true
                                                           
                                markers.append(marker)
                                marker.map = self.myMapView
                                
                                return
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
//MARK:- location work

extension ListMapTabViewController:CLLocationManagerDelegate
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
extension ListMapTabViewController:UIPopoverPresentationControllerDelegate
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

extension ListMapTabViewController
{
        //MARK:- Map init code
        func initGoogleMaps() {
    //        let camera = GMSCameraPosition.camera(withLatitude: CURRENTLOCATIONLAT, longitude: CURRENTLOCATIONLONG, zoom: 17.0)
            
            let camera = GMSCameraPosition.camera(withLatitude: CURRENTLOCATIONLAT, longitude: CURRENTLOCATIONLONG, zoom: 6.0)
            self.myMapView.camera = camera
            self.myMapView.delegate = self
            self.myMapView.settings.compassButton = true
            self.myMapView.settings.myLocationButton=true
            self.myMapView.isMyLocationEnabled = true
            showPartyMarkers()
        }
}



extension ListMapTabViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
       
            return self.allMarkerArray.count
        
       
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
    
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClusterCollectionViewCell", for: indexPath) as! ClusterCollectionViewCell
         

                      cell.bookAppBtn.layer.cornerRadius = 6
                      
                      cell.bookAppBtn.tag=indexPath.row
                      
                      cell.bookAppBtn.addTarget(self, action: #selector(BookAction2), for: .touchUpInside)
                      cell.seeAllBtn.tag=indexPath.row
                      
                      cell.seeAllBtn.addTarget(self, action: #selector(TimeTableAction2), for: .touchUpInside)
                      
                      
//                      cell.mainview.layer.cornerRadius = 12
//                      cell.mainview.layer.shadowColor = UIColor.lightGray.cgColor
//                      cell.mainview.layer.shadowOpacity = 1
//                      cell.mainview.layer.shadowOffset = .zero
//                      cell.mainview.layer.shadowRadius = 3
//
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
                                  
                                  let avgprice=DEFAULT.value(forKey: "avgprice") as? String ?? ""
                                  
                                  if value == "  All  "
                                      
                                  {
                                      if avgprice == ""
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
                                      }
                                      
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
                                  var openTime = openDict.value(forKey: dayOfWeak) as? String ?? "00:00 "
                                  print("open time = \(openTime)")
                                  
                                  if openTime.contains("00:00")
                                  {
                                      cell.openlbl.isHidden = true
                                       cell.closeLbl.text = "Closed"
                                      cell.closeLbl.isHidden=false
                                  }
                                  else
                                      
                                  {
                                      if let openDict = vendor_metaDict.value(forKey: "close") as? NSDictionary
                                      {
                                          var closeTime = openDict.value(forKey: dayOfWeak) as? String ?? "00:00"
                                          print("close time = \(openTime)")
                                          cell.openlbl.text = "\(dayOfWeak)"+" "+openTime+"-"+closeTime
                                          
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
                                          
                                          if self.isOpenClinic(OpenTime: openTime) == true
                                          {
                                              
                                              cell.closeLbl.text = "Open"
                                              if self.isClosedClinic(closetime: closeTime) == true
                                              {
                                                  cell.closeLbl.text = "Closed"
                                              }
                                              else if self.isClosedClinic(closetime: closeTime) == false
                                              {
                                                  cell.closeLbl.text = "Open"
                                              }
                                              else
                                              {
                                                  cell.closeLbl.text = ""//"Open"
                                              }
                                              
                                          }
                                          else
                                          {
                                              cell.closeLbl.text = "Closed"
                                              //                                        if self.isClosedClinic(closetime: closeTime) == true
                                              //                                           {
                                              //                                              cell.closeLbl.text = "Closed"
                                              //                                           }
                                              //                                           else if self.isClosedClinic(closetime: closeTime) == false
                                              //                                           {
                                              //                                                  cell.closeLbl.text = "Open"
                                              //                                           }
                                              //                                           else
                                              //                                           {
                                              //                                              cell.closeLbl.text = ""//"Open"
                                              //                                           }
                                              
                                          }
                                          
                                          
                                          
                                          
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
                            cell.ratingShow.text = str
                          }
                          else
                          {
                              cell.ratingShow.text = str+".0"
                              
                          }
                          cell.ratingV.rating = Double(review)
                          cell.ratingV.isUserInteractionEnabled=false
                      }
        else
                        
                      {
                         cell.ratingV.rating = Double(0)
                        cell.ratingShow.text = "0"
                        
           }
                      if let  review = dict.value(forKey: "reviewsCount") as? Int
                      {
                          if review == 0 || review == 1
                          {
                              let add = "("+"\(review)" + " Review" + ")"
                              //cell.ratingLbl.setTitle(add, for: .normal)
                let attributeString = NSMutableAttributedString(string: add,attributes: yourAttributes)
                            cell.ratingBtn.setAttributedTitle(attributeString, for: .normal)
                          }
                          else
                          {
                              let add = "("+"\(review)" + " Reviews" + ")"
                              let attributeString = NSMutableAttributedString(string: add,attributes: yourAttributes)
                              cell.ratingBtn.setAttributedTitle(attributeString, for: .normal)
                              
                          }
                          
                      }
                      
                      if let vendor_metaArray = dict.value(forKey: "vendor_meta") as? NSArray
                          
                      {
                          if vendor_metaArray.count>0
                              
                          {
                              
                              let vendor_metaDict = vendor_metaArray.object(at: 0) as! NSDictionary
                              
                              let city =  vendor_metaDict.value(forKey: "state") as? String ?? ""
                              let country =  vendor_metaDict.value(forKey: "country") as? String ?? ""
                              
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
                                             var yelprating = 0
                                                if self.yelpReviewArray.count != 0
                                                {
                                                   yelprating =  Int(yelp_avg_Rating2)/self.yelpReviewArray.count
                                               }
                                                else{
                                                    yelprating =  Int(yelp_avg_Rating2)
                                                                                        }
                                                                                        
                                               let userrating = dict.value(forKey: "reviewsAvg") as? Int ?? 0
                                                   var totalvg = 0
                                                 if userrating == 0
                                                 {
                                                    totalvg = (yelprating)

                                               }
                                               else
                                                 {
                                                    totalvg = (yelprating+userrating)/2

                                               }
                                                                                           
                                                                                        cell.ratingShow.text = String(totalvg)
                                               cell.ratingV.rating = Double(totalvg)
                                               let userReview = dict.value(forKey: "reviewsCount") as? Int ?? 0
                                               let yelpReview = self.yelpReviewArray.count
                                               let totalReview = (userReview+yelpReview)


                                                                                           
                                                 
                                                                                               if totalReview == 0 || totalReview == 1
                                                                                               {
                                                                                                   let add = "("+"\(totalReview)" + " Review" + ")"
                                                                                                   //cell.ratingLbl.setTitle(add, for: .normal)
                                                                                                   let attributeString = NSMutableAttributedString(string: add,attributes: self.yourAttributes)
                                                            cell.ratingBtn.setAttributedTitle(attributeString, for: .normal)
                                                                                               }
                                                                                               else
                                                                                               {
                                                                                                   let add = "("+"\(totalReview)" + " Reviews" + ")"
                                                                                                   let attributeString = NSMutableAttributedString(string: add,attributes: self.yourAttributes)
                                                                                                   cell.ratingBtn.setAttributedTitle(attributeString, for: .normal)
                                                                                                   
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
                                               
                                               
                            
                            
                            
                            
                            
                            
                            
                              cell.locLbl.text = city+" , "+country
                          }
                          else
                          {
                              cell.locLbl.text = "Mohali, Punjab"
                          }
                      }
                      
                      
                      return cell
            
            
            return cell
       
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == self.ClustercollectionView
        {
            
            let value=DEFAULT.value(forKey: "currentCat") as? String ?? ""
                    let avgprice=DEFAULT.value(forKey: "avgprice") as? String ?? ""
                    
                    if value == "  All  "
                    {
                        if avgprice == ""
                        {
                            return CGSize(width: SCREENWIDTH, height: 280)
                        }
                        else
                            
                        {
                            return CGSize(width: SCREENWIDTH, height: 340)
                        }
                        
                 }
            else
                    {
                      return CGSize(width: 375, height: 340)
                }
        
        }
        else
        {
         return CGSize(width: SCREENWIDTH, height: SCREENHEIGHT-100)
        }
    }
    
   
       
          func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
              return 1.0
          }

          func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
              return 1.0
          }
}



//MARK:- Map Work

extension ListMapTabViewController:GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate
{
    // MARK: CLLocation Manager Delegate
    
    
    
    //MARK:-  Marker tap
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        NSLog("marker was tapped")
        tappedMarker = marker
        
       // self.markerDetailView.isHidden=false
        self.ClustercollectionView.isHidden=false
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
            else
                    
                {
                    ratingShow.text="0"
                    ratingV.rating = Double(0)

                    
            }
                if let  review = dict.value(forKey: "reviewsCount") as? Int
                {
                    if review == 0 || review == 1
                    {
                        let add = "("+"\(review)" + " Review" + ")"
                        //cell.ratingLbl.setTitle(add, for: .normal)
                        let attributeString = NSMutableAttributedString(string: add,attributes: yourAttributes)
                        ratingBtn.setAttributedTitle(attributeString, for: .normal)
                    }
                    else
                    {
                        let add = "("+"\(review)" + " Reviews" + ")"
                        let attributeString = NSMutableAttributedString(string: add,attributes: yourAttributes)
                        ratingBtn.setAttributedTitle(attributeString, for: .normal)
                        
                    }
                    
                }
                
            
//
//            if let vendor_servicesArray = dict.value(forKey: "vendor_services") as? NSArray
//
//                          {
//                              if vendor_servicesArray.count>0
//
//                              {
//                                for dict1 in vendor_servicesArray
//                                {
//                                   let dict=dict1 as! NSDictionary
//                                   let serviceName1 = dict.value(forKey: "serviceName") as? String ?? ""
//                                   let serviceName2 = DEFAULT.value(forKey: "CategoryName") as? String ?? ""
//                                   if serviceName1.lowercased()==serviceName2.lowercased()
//                                   {
//                                    self.searviceNamelbl.text=serviceName2
//                                       self.serviceCostLbl.text="$"+(dict.value(forKey: "servicePrice") as? String ?? "")
//                                       self.topConst.constant=73
//                                    self.detalHeightConst.constant=320
//
//                                        self.serviceView.isHidden=false
//                                    break
//                                   }
//                                    else if avgLbl.isHidden==false
//                                   {
//                                    self.searviceNamelbl.text=serviceName1
//                                                        self.serviceCostLbl.text="$"+(dict.value(forKey: "servicePrice") as? String ?? "")
//                                                                          self.topConst.constant=73
//                                                                       self.detalHeightConst.constant=320
//
//                                                                           self.serviceView.isHidden=false
//                                    }
//
//                                   else
//
//                                   {
//                                        self.serviceView.isHidden=true
//                                      self.searviceNamelbl.text=""
//                                       self.serviceCostLbl.text=""
//                                       self.topConst.constant=13
//                                    self.detalHeightConst.constant=260
//
//                                   }
//                                 }
//
//                             }
//                           else
//
//                                                  {
//                                                   self.serviceView.isHidden=true
//
//                                                     self.searviceNamelbl.text=""
//                                                      self.serviceCostLbl.text=""
//
//                                        self.topConst.constant=13
//                                        self.detalHeightConst.constant=260
//                                                  }
//                      }
//
            
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
                                             if avgLbl.isHidden==false
                                             {
                                                 self.searviceNamelbl.text=serviceName1
                                                                                       self.serviceCostLbl.text="$"+(dict.value(forKey: "servicePrice") as? String ?? "")
                                                                                       self.topConst.constant=73
                                                                                       self.detalHeightConst.constant=320

                                                                                        self.serviceView.isHidden=false
                                                                                    break
                                             }
                                            
                                            }
                                            else if avgLbl.isHidden==false
                                                     {
                                             self.searviceNamelbl.text=serviceName1
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
                        
                        let city = vendor_metaDict.value(forKey: "state") as? String ?? ""
                                                             
                        let county = vendor_metaDict.value(forKey: "country") as? String ?? ""
                            self.locLbl.text = city+" ,"+county
                        

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
        self.openlbl.text =  "\(dayOfWeak)"+" "+openTime+"-"+closeTime
                                                
                                                
                                                self.closeLbl.text = "Open"
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
                                                    
                                                                                  
//                                                                                  if self.isClosedClinic(closetime: closeTime) == true
//                                                                                  {
//                                                                                     self.closeLbl.text = "Closed"
//                                                                                  }
//                                                                                     else if self.isClosedClinic(closetime: closeTime) == false
//                                                                                      {
//                                                                                         self.closeLbl.text = "Open"
//                                                                                      }
//                                                                                  else
//                                                                                  {
//                                                                                     self.closeLbl.text = ""//"Open"
//                                                                                  }
                                                   
                                               self.openlbl.isHidden=false
                                               self.closeLbl.isHidden=false
                                               }
                                           }
                                           
                                       }
                        
                        
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
            customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "selectedmarker"), for: .normal)
            
            print(marker)
        }
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        marker.icon = GMSMarker.markerImage(with: YELLOWMARKERCOLOL)
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
      customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "selectedmarker"), for: .normal)
        self.markerDetailView.isHidden = true
        self.ClustercollectionView.isHidden=true
        
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
           // customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "MarkerImage"), for: .normal)
            customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "selectedmarker"), for: .normal)
        }
        
    }
    
    
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker)
    {
        print("amar d gh h df")
        if let marker =  mapView.selectedMarker
        {
customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "selectedmarker"), for: .normal)
            
        }
        
    }
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView?
    {
        let imageIcon = UIButton(frame: CGRect(x: 25, y: 0, width: 50, height: 50))
        imageIcon.setBackgroundImage(UIImage(named: "AppIcon-2"), for: .normal)
        
customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "selectedmarker"), for: .normal)
        //view.addSubview(imageIcon)
        
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return nil }
        // let data = previewDemoData[customMarkerView.tag]
        //restaurantPreviewView.setData(img:UIImage(named: "AppIcon-2")!)
        return UIView()//restaurantPreviewView
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker)
    {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "selectedmarker"), for: .normal)
        
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        
        //marker.icon = GMSMarker.markerImage(with: YELLOWMARKERCOLOL)
        customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "selectedmarker"), for: .normal)
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
    func  isClosedClinic(closetime:String) -> Bool
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let now1 = Date()
        
        let enteredDate = dateFormatter.date(from: closetime)!
        let now2 = dateFormatter.string(from: now1)
        let now = dateFormatter.date(from: now2)!
        let endOfMonth = Calendar.current.date(byAdding: .minute, value: 5, to: enteredDate)!
        
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
    
       func  isOpenClinic(OpenTime:String) -> Bool
       {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "hh:mm a"
           let now1 = Date()
           
           let enteredDate = dateFormatter.date(from: OpenTime)!
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

//extension ListMapTabViewController:CAPSPageMenuDelegate
//{
//    func willMoveToPage(_ controller: UIViewController, index: Int)
//    {
//        self.currentPageIndex = index
//        print("currentPageIndex = \(index)")
//
//
//         print("currentPageIndex = \(currentPageIndex)")
//             if let rating = DEFAULT.value(forKey: "SELECTEDFILTER") as? String
//                          {
//                             self.ratingLbl.text="  "+rating+"+ Stars"
//                            if rating == "0"
//                            {
//                                 self.ratingLbl.textColor=UIColor.clear
//                                                                    self.ratingLbl.backgroundColor=UIColor.clear
//                                                                   self.ratingLbl.isHidden=false
//
//                            }
//                            else
//                            {
//                                ratingLbl.dropShadow(color: .black, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 20, scale: true)
//                                       ratingLbl.layer.cornerRadius = 15
//                                       ratingLbl.clipsToBounds = true
//                                self.ratingLbl.isHidden=false
//                            }
//
//                          }
//                             else
//                                 {
//                                     self.ratingLbl.textColor=UIColor.clear
//                                     self.ratingLbl.backgroundColor=UIColor.clear
//                                    self.ratingLbl.isHidden=false
//                                                                       self.filterLbl.text="  All  "
//
//
//                                 }
//                              if let minimum = DEFAULT.value(forKey: "minimum") as? String
//                              {
//                                  if let maximum = DEFAULT.value(forKey: "maximum") as? String
//                                  {
//                                      self.priceLbl.text=" $"+"\(minimum)"+"-"+"$"+"\(maximum)"+" "
//                                     priceLbl.dropShadow(color: .black, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 20, scale: true)
//                                     priceLbl.layer.cornerRadius = 15
//                                     priceLbl.clipsToBounds = true
//
//                                  }
//                                  else
//                                  {
//                                      self.priceLbl.textColor=UIColor.clear
//                                      self.priceLbl.backgroundColor=UIColor.clear
//                                  }
//                              }
//                          else
//                          {
//                              self.priceLbl.textColor=UIColor.clear
//                             self.priceLbl.backgroundColor=UIColor.clear
//
//                          }
//
//
////               if let name=DEFAULT.value(forKey: "CategoryName") as? String
////               {
////                  self.filterLbl.text="  "+name+"  "
////                   self.searchText.text=name
////               }
////               else
////               {
////                   self.filterLbl.text="  All  "
////                   self.searchText.text=""
////               }
////
////               DEFAULT.removeObject(forKey: "CategoryId")
////               DEFAULT.removeObject(forKey: "CategoryName")
////               DEFAULT.removeObject(forKey: "CategorySelected")
////               DEFAULT.synchronize()
//
//        DEFAULT.set(self.filterLbl.text!,forKey: "currentCat")
//        DEFAULT.synchronize()
//
////
//    }
//
//    func didMoveToPage(_ controller: UIViewController, index: Int)
//    {
//        self.currentPageIndex = index
//        print("currentPageIndex = \(index)")
//
//
//
////        if let name=DEFAULT.value(forKey: "CategoryName") as? String
////        {
////           self.filterLbl.text="  "+name+"  "
////            self.searchText.text=name
////        }
////        else
////        {
////            self.filterLbl.text="  All  "
////            self.searchText.text=""
////        }
////
////        DEFAULT.removeObject(forKey: "CategoryId")
////        DEFAULT.removeObject(forKey: "CategoryName")
////        DEFAULT.removeObject(forKey: "CategorySelected")
////        DEFAULT.synchronize()
////
//
//    }
//}


