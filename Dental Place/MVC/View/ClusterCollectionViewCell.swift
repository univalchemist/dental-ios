//
//  ClusterCollectionViewCell.swift
//  Dental Place
//
//  Created by AMARENDRA on 07/05/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
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

class ClusterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tutView: UIView!
       
       //@IBOutlet weak var view1: UIView!
       
       //@IBOutlet weak var view2: UIView!
       
       @IBOutlet weak var tabView: UIView!
       
       @IBOutlet weak var CollectionView: UICollectionView!
       @IBOutlet weak var scrView: UIScrollView!
       
       @IBOutlet weak var locLbl: UILabel!
       
       @IBOutlet weak var userLbl: UILabel!
       @IBOutlet weak var pageCont: UIPageControl!
       // @IBOutlet weak var view3: UIView!
       
       @IBOutlet weak var roundview: UIView!
       
       @IBOutlet weak var catTable: UITableView!
       
       var tabBarItem1: UITabBarItem = UITabBarItem()
       var tabBarItem2: UITabBarItem = UITabBarItem()
       var tabBarItem3: UITabBarItem = UITabBarItem()
       var tabBarItem4: UITabBarItem = UITabBarItem()
       
       var catData:CategoryModel?
       
       var homecell:SearchServiceTableViewCell?
       //PageMenu
       
       @IBOutlet weak var searchText: UITextField!
       
       
       var currentPageIndex = 0
       
       
       var filterSelected = ""
       
       
       @IBOutlet weak var backBiew: UIView!
       //MARK:- Location
       // For location
       let manager = CLLocationManager()
       var zipCode = ""
       
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
       
       @IBOutlet weak var priceLbl2: UILabel!
       @IBOutlet weak var locaionLbl2: UILabel!
       
       @IBOutlet weak var filterLbl: UILabel!
       @IBOutlet weak var priceLbl: UILabel!
       @IBOutlet weak var ratingLbl: UILabel!
       
       
       
       //MARK:- List work
       @IBOutlet weak var LISTMAPUIVIEW: UIView!
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
       //   @IBOutlet weak var locLbl: UILabel!
       @IBOutlet weak var nameLbl: UILabel!
       
       // @IBOutlet weak var ratingNumber: UILabel!
       @IBOutlet weak var profileImg: UIImageView!
       
       @IBOutlet weak var ratingShow: UILabel!
       
       
       let currentLocationMarker = GMSMarker()
       var chosenPlace: MyPlace?
       
       let customMarkerWidth: Int = 50
       let customMarkerHeight: Int = 70
       
       
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
       @IBOutlet weak var currentLoc2: UILabel!
       @IBOutlet weak var currentLoc3: UILabel!
       var  vendor_metaDict=NSDictionary()
       
       // @IBOutlet weak var avgPriceLbl: UILabel!
    @IBOutlet weak var seeAllBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
