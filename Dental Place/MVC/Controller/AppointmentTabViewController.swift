//
//  AppointmentTabViewController.swift
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
import MapKit

class AppointmentTabViewController: UIViewController
{
    let yourAttributes: [NSAttributedString.Key: Any] = [
               .font: UIFont.systemFont(ofSize: 14),
               .foregroundColor: UIColor.init(red: 106/255, green: 134/255, blue: 165/255, alpha: 1),
               .underlineStyle: NSUnderlineStyle.single.rawValue]
    var yelpReviewArray=NSMutableArray()
    var yelp_id = ""
    @IBOutlet weak var myAppointmentTable: UITableView!
    @IBOutlet weak var historytable: UITableView!
    
    //MARK:- my appoint work
    @IBOutlet weak var mapViewBtn: UIButton!
    @IBOutlet weak var listViewBtn: UIButton!
    @IBOutlet weak var listlineView: UIView!
    @IBOutlet weak var nodtaFoundLbl: UILabel!
    @IBOutlet weak var notfoundView: UIView!
    
    var headerClick = -1
    var  vendor_metaDict=NSDictionary()
    
    @IBOutlet weak var MyAppointView: UIView!
    @IBOutlet weak var HistoryView: UIView!
    @IBOutlet weak var mapLineView: UIView!
    var venueLat:NSString = ""
    var venueLng:NSString  = ""
    var venueAddress:String  = ""
    var venderServiceArray=NSArray()
    var appointMentArray = NSMutableArray()
    var HistoryArray = NSMutableArray()
    var bookingId = ""
    
    var selectedService = -1
    
    var serviceId = ""
    var serviceName = ""
    var servicePrice = ""
    var time = ""
    var appoinment_date = ""
    
    
    var catData:CategoryModel?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        self.HistoryView.isHidden=true
        myAppointmentTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0); //values
        self.notfoundView.isHidden=true
        
        // Do any additional setup after loading the view.
        myAppointmentTable.register(UINib(nibName: "MyAppointmentTableViewCell", bundle: nil), forCellReuseIdentifier: "MyAppointmentTableViewCell")
        historytable.register(UINib(nibName: "HistoryTableCell", bundle: nil), forCellReuseIdentifier: "HistoryTableCell")
        historytable.register(UINib(nibName: "GiveRatingTableViewCell", bundle: nil), forCellReuseIdentifier: "GiveRatingTableViewCell")
        historytable.register(UINib(nibName: "HistoryClinicTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryClinicTableViewCell")
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.GetAppointmentAPI()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.AppointmentPageRefreshNoti), name: Notification.Name("AppointmentPageRefreshNoti"), object: nil)
    }
    
    @objc func AppointmentPageRefreshNoti()
    {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.selectedIndex = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.notfoundView.isHidden=true
        self.nodtaFoundLbl.isHidden=true
        
        
        
        if self.MyAppointView.isHidden==false
        {
            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
            {
                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
            }
            else
            {
                self.GetAppointmentAPI()
            }
        }
        else
        {
            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
            {
                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
            }
            else
            {
                self.GetHistoryAPI()
            }
        }
        
    }
    @IBAction func listViewBtnAct(_ sender: UIButton)
    {
        
        self.MyAppointView.isHidden=false
        self.HistoryView.isHidden=true
        self.notfoundView.isHidden=true
        self.listViewBtn.setTitleColor(APPCOLOL, for: .normal)
        self.mapViewBtn.setTitleColor(SELECTEDLINECOLOL, for: .normal)
        
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.GetAppointmentAPI()
        }
        self.listlineView.backgroundColor=APPCOLOL
        self.mapLineView.backgroundColor=SELECTEDLINECOLOL
    }
    
    @IBAction func mapViewAction(_ sender: UIButton)
    {
        self.listlineView.backgroundColor=SELECTEDLINECOLOL
        self.listViewBtn.setTitleColor(SELECTEDLINECOLOL, for: .normal)
        self.mapViewBtn.setTitleColor(APPCOLOL, for: .normal)
        self.mapLineView.backgroundColor=APPCOLOL
        self.MyAppointView.isHidden=true
        self.HistoryView.isHidden=false
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.GetHistoryAPI()
        }
        
    }
    
    @IBAction func filterBtn(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension AppointmentTabViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView==self.historytable
        {
            if self.headerClick != -1
            {
                if section == self.headerClick
                {
                    return 1
                }
                else
                {
                    return 0
                }
            }
            else
                
            {
                return 0
            }
            
        }
        else
            
        {
            return 0//self.appointMentArray.count
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView==self.historytable
        {
            return 246
        }
        else
        {
            return 0//385
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if tableView==self.historytable
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryClinicTableViewCell") as! HistoryClinicTableViewCell
            cell.backView.layer.cornerRadius = 8
            cell.backView.layer.shadowColor = UIColor.lightGray.cgColor
            cell.backView.layer.shadowOpacity = 1
            cell.backView.layer.shadowOffset = .zero
            cell.backView.layer.shadowRadius = 3
            
            let dict = self.HistoryArray.object(at: indexPath.section) as! NSDictionary
            cell.clinicname.text = dict.value(forKey: "serviceName") as? String ?? ""
            cell.servceName.text = dict.value(forKey: "serviceName") as? String ?? ""
            
            cell.dateLbl.text = self.convertDateFormater(dict.value(forKey: "appoinment_date") as? String ?? "")
            cell.timelbl.text = dict.value(forKey: "time") as? String ?? ""
            
            
            if let clinic_data = dict.value(forKey: "clinic_data") as? NSDictionary
            {
                let city =  clinic_data.value(forKey: "state") as? String ?? ""
                let country =  clinic_data.value(forKey: "country") as? String ?? ""
                
                cell.locationLbl.text = city+" , "+country
            }
            if let clilicDict = dict.value(forKey: "owner_data") as? NSDictionary
            {
                
                
                cell.clinicname.text = clilicDict.value(forKey: "user_name") as? String ?? ""
                
                
                if let url2 = clilicDict.value(forKey: "profile_image") as? String
                {
                    let fullurl =  url2
                    
                    print("Image full url \(fullurl)")
                    let url = URL(string: fullurl)
                    
                    cell.profileImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
                }
                
            }
            
            
            
            //cell.rateBtn.tag = indexPath.row
            // cell.rateBtn.layer.cornerRadius = 6
            // cell.rateBtn.addTarget(self, action: #selector(rateBtnAct(_:)), for: .touchUpInside)
            
            /*
             cell.ratePopup.isHidden = true
             cell.allReviewPopup.isHidden = true
             
             
             if indexPath.row == 0
             {
             cell.ratePopup.isHidden = true
             cell.allReviewPopup.isHidden = true
             }
             else if indexPath.row == 1
             {
             cell.ratePopup.isHidden = false
             cell.allReviewPopup.isHidden = true
             cell.rateBtn.tag = indexPath.row
             cell.rateBtn.layer.cornerRadius = 6
             cell.rateBtn.addTarget(self, action: #selector(rateBtnAct(_:)), for: .touchUpInside)
             
             }
             else if indexPath.row == 2
             {
             cell.ratePopup.isHidden = true
             cell.allReviewPopup.isHidden = false
             cell.allReviewBtn.tag = indexPath.row
             cell.allReviewBtn.layer.cornerRadius = 6
             cell.allReviewBtn.addTarget(self, action: #selector(AllComment(_:)), for: .touchUpInside)
             }
             else if indexPath.row == 3
             {
             cell.allReviewPopup.isHidden = true
             cell.ratePopup.isHidden = true
             }
             
             */
            return cell
        }
        else
            
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyAppointmentTableViewCell") as! MyAppointmentTableViewCell
            cell.threeDotsBtn.tag = indexPath.row
            cell.threeDotsBtn.addTarget(self, action: #selector(threeDotsBtnAction), for: .touchUpInside)
            cell.seeDirectionBtn.isEnabled=true
            cell.seeDirectionBtn.isUserInteractionEnabled=true
            cell.seeDirectionBtn.tag = indexPath.row
            cell.seeDirectionBtn.addTarget(self, action: #selector(seeDirectionsBtnAction), for: .touchUpInside)
            
            
            let dict = self.appointMentArray.object(at: indexPath.row) as! NSDictionary
            cell.clinicNameLbl.text = dict.value(forKey: "serviceName") as? String ?? ""
            cell.servicenamelbl.text = dict.value(forKey: "serviceName") as? String ?? ""
            
            cell.dateLbl.text = self.convertDateFormater(dict.value(forKey: "appoinment_date") as? String ?? "")
            cell.timeLbl.text = dict.value(forKey: "time") as? String ?? ""
            
            
            if let clinic_data = dict.value(forKey: "clinic_data") as? NSDictionary
            {
                let city =  clinic_data.value(forKey: "state") as? String ?? ""
                let country =  clinic_data.value(forKey: "country") as? String ?? ""
                
                cell.locLbl.text = city+" , "+country
            }
            if let clilicDict = dict.value(forKey: "owner_data") as? NSDictionary
            {
                
                
                cell.clinicNameLbl.text = clilicDict.value(forKey: "user_name") as? String ?? ""
                
                
                if let url2 = clilicDict.value(forKey: "profile_image") as? String
                {
                    let fullurl =  url2
                    
                    print("Image full url \(fullurl)")
                    let url = URL(string: fullurl)
                    
                    cell.profileImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
                }
                
            }
            
            //            if let url2 = dict.value(forKey: "profile_image") as? String
            //            {
            //                let fullurl =   url2
            //
            //                print("Image full url \(fullurl)")
            //                let url = URL(string: fullurl)
            //
            //                cell.profileImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
            //            }
            
            return cell
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView==self.historytable
        {
            return self.HistoryArray.count//4
        }
        else
        {
            return self.appointMentArray.count
        }
    }
    
    private func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> CGFloat?
    {
        
        if tableView==self.historytable
        {
            
            let dict = self.HistoryArray.object(at: section) as! NSDictionary
            
            let reviewStatus =  dict.value(forKey: "reviewStatus") as? String ?? ""
            if reviewStatus == "0"
            {
                return 162
            }
            else
            {
                return 200
            }
            
        }
        else
        {
            return 385//0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if tableView==self.historytable
        {
            let dict = self.HistoryArray.object(at: section) as! NSDictionary
            
            let reviewStatus =  dict.value(forKey: "reviewStatus") as? String ?? ""
            if reviewStatus == "0"
            {
                return 197
            }
            else
            {
                return 200
            }
            
            
            
            
        }
        else
        {
            return 385
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if tableView==self.historytable
        {
            
            let dict = self.HistoryArray.object(at: section) as! NSDictionary
            
            let reviewStatus =  dict.value(forKey: "reviewStatus") as? String ?? ""
            if reviewStatus == "0"
            {
                let cell = Bundle.main.loadNibNamed("GiveRatingTableViewCell", owner: self, options: nil)?.first as! GiveRatingTableViewCell
                cell.serviceName.text = dict.value(forKey: "serviceName") as? String ?? ""
                cell.backView.layer.cornerRadius = 8
                cell.backView.layer.shadowColor = UIColor.lightGray.cgColor
                cell.backView.layer.shadowOpacity = 1
                cell.backView.layer.shadowOffset = .zero
                cell.backView.layer.shadowRadius = 3
                
                cell.dateLbl.text = self.convertDateFormater(dict.value(forKey: "appoinment_date") as? String ?? "")
                cell.timeLbl.text = dict.value(forKey: "time") as? String ?? ""
                
                
                cell.rateBtn.tag = section
                cell.rateBtn.layer.cornerRadius = 6
                cell.rateBtn.addTarget(self, action: #selector(rateBtnAct(_:)), for: .touchUpInside)
                cell.expandBtn.tag = section
                cell.expandBtn.layer.cornerRadius = 6
                cell.expandBtn.addTarget(self, action: #selector(expandBtnAction), for: .touchUpInside)
                
                
                
                
                return cell
            }
            else
            {
                let cell = Bundle.main.loadNibNamed("HistAllRatingTableViewCell", owner: self, options: nil)?.first as! HistAllRatingTableViewCell
                cell.backview.layer.cornerRadius = 8
                cell.backview.layer.shadowColor = UIColor.lightGray.cgColor
                cell.backview.layer.shadowOpacity = 1
                cell.backview.layer.shadowOffset = .zero
                cell.backview.layer.shadowRadius = 3
                cell.allreviewBtn.tag = section
                cell.allreviewBtn.layer.cornerRadius = 6
                let dict = self.HistoryArray.object(at: section) as! NSDictionary
                cell.servicename.text = dict.value(forKey: "serviceName") as? String ?? ""
                let rating = dict.value(forKey: "reviewsAvg") as? Double ?? 0.0
                
                cell.ratingV.rating = Double(rating)
                cell.ratinglbl.text = "\(rating.round(to: 2))"
                var yelp_avg_Rating2 = 0.0

                let yelp_id =  vendor_metaDict.value(forKey: "yelp_id") as? String ?? ""
                                       
                                     // print("yelp id at = \(self.fetchYelpBusinessesReview(yelp_id: yelp_id))")
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
                            yelprating =  yelp_avg_Rating2
                            }
                       let userrating = dict.value(forKey: "reviewsAvg") as? Double ?? 0.0
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
                                                                   
                    cell.ratinglbl.text = String(totalvg.round(to: 2))
                       cell.ratingV.rating = Double(totalvg)
                       let userReview = dict.value(forKey: "reviewsCount") as? Int ?? 0
                       let yelpReview = self.yelpReviewArray.count
                       let totalReview = (userReview+yelpReview)


                                                                   
                         
                                                                       if totalReview == 0 || totalReview == 1
                                                                       {
                                                                           let add = "("+"\(totalReview)" + " Review" + ")"
                                                                           //cell.ratingLbl.setTitle(add, for: .normal)
                                                                           let attributeString = NSMutableAttributedString(string: add,attributes: self.yourAttributes)
                                                                           //cell.ratingLbl.setAttributedTitle(attributeString, for: .normal)
                                                                       }
                                                                       else
                                                                       {
                                                                           let add = "("+"\(totalReview)" + " Reviews" + ")"
                                                                           let attributeString = NSMutableAttributedString(string: add,attributes: self.yourAttributes)
                                                                           //cell.ratingLbl.setAttributedTitle(attributeString, for: .normal)
                                                                           
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
                
                
                
                cell.allreviewBtn.addTarget(self, action: #selector(AllComment(_:)), for: .touchUpInside)
                return cell
            }
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyAppointmentTableViewCell") as! MyAppointmentTableViewCell
            cell.threeDotsBtn.tag = section
            cell.threeDotsBtn.addTarget(self, action: #selector(threeDotsBtnAction), for: .touchUpInside)
            cell.seeDirectionBtn.isEnabled=true
            cell.seeDirectionBtn.isUserInteractionEnabled=true
            cell.seeDirectionBtn.tag = section
            cell.seeDirectionBtn.addTarget(self, action: #selector(seeDirectionsBtnAction), for: .touchUpInside)
            
            
            let dict = self.appointMentArray.object(at: section) as! NSDictionary
            cell.clinicNameLbl.text = dict.value(forKey: "serviceName") as? String ?? ""
            cell.servicenamelbl.text = dict.value(forKey: "serviceName") as? String ?? ""
            
            cell.dateLbl.text = self.convertDateFormater( dict.value(forKey: "appoinment_date") as? String ?? "")
            cell.timeLbl.text = dict.value(forKey: "time") as? String ?? ""
            
            
            if let clinic_data = dict.value(forKey: "clinic_data") as? NSDictionary
            {
                let city =  clinic_data.value(forKey: "state") as? String ?? ""
                let country =  clinic_data.value(forKey: "country") as? String ?? ""
                
                cell.locLbl.text = city+" , "+country
            }
            if let clilicDict = dict.value(forKey: "owner_data") as? NSDictionary
            {
                
                
                cell.clinicNameLbl.text = clilicDict.value(forKey: "user_name") as? String ?? ""
                
                
                if let url2 = clilicDict.value(forKey: "profile_image") as? String
                {
                    let fullurl =  url2
                    
                    print("Image full url \(fullurl)")
                    let url = URL(string: fullurl)
                    
                    cell.profileImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
                }
                
            }
            
            //            if let url2 = dict.value(forKey: "profile_image") as? String
            //            {
            //                let fullurl =   url2
            //
            //                print("Image full url \(fullurl)")
            //                let url = URL(string: fullurl)
            //
            //                cell.profileImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
            //            }
            
            return cell
        }
    }
    @objc func rateBtnAct(_ sender: UIButton)
    {
        let RatingViewController = self.storyboard?.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
        
        let dict = self.HistoryArray.object(at: sender.tag) as! NSDictionary
        RatingViewController.clinicId = dict.value(forKey: "clinicId") as? String ?? ""
        RatingViewController.servicename = dict.value(forKey: "serviceName") as? String ?? ""
        
        RatingViewController.servicename = dict.value(forKey: "serviceName") as? String ?? ""
        
        
        if let clinic_data = dict.value(forKey: "clinic_data") as? NSDictionary
        {
            let city =  clinic_data.value(forKey: "state") as? String ?? ""
            let country =  clinic_data.value(forKey: "country") as? String ?? ""
            
            RatingViewController.location = city+" , "+country
        }
        RatingViewController.detailDict=dict
        
        
        
        self.navigationController?.pushViewController(RatingViewController, animated: true)
        
    }
    @objc func expandBtnAction(_ sender: UIButton)
    {
        
        if sender.tag == self.headerClick
        {
            self.headerClick = -1
        }
        else
        {
            self.headerClick = sender.tag
        }
        
        self.historytable.reloadData()
        
    }
    
    
    
    @IBAction func BookAppoitment(_ sender: UIButton)
    {
        APPDEL.loadHomeView()
        
    }
    
    @objc func AllComment(_ sender: UIButton)
    {
        let RatingViewController = self.storyboard?.instantiateViewController(withIdentifier: "AllComments") as! AllComments
        
        let dict = self.HistoryArray.object(at: sender.tag) as! NSDictionary
        RatingViewController.clinicId = dict.value(forKey: "clinicId") as? String ?? ""
        RatingViewController.servicename = dict.value(forKey: "serviceName") as? String ?? ""
        //                var star_rate = ""
        //                      var clinicId = ""
        //                      var servicename = ""
        //                    var clinicName = ""
        //                      var profile = ""
        //                       var location = ""
        //                    var profileImage = ""
        //
        //
        if let clinic_data = dict.value(forKey: "clinic_data") as? NSDictionary
        {
            let city =  clinic_data.value(forKey: "state") as? String ?? ""
            let country =  clinic_data.value(forKey: "country") as? String ?? ""
            
            let yelp_id =  clinic_data.value(forKey: "yelp_id") as? String ?? ""

            RatingViewController.yelp_id = yelp_id

            RatingViewController.location = city+" , "+country
        }
        
        RatingViewController.detailDict=dict
        
        
        
        self.navigationController?.pushViewController(RatingViewController, animated: true)
        
    }
    
    //MARK:- Three dot  Button Act
    
    @objc func threeDotsBtnAction(_ sender:UIButton)
    {
        
        
        let dict = self.appointMentArray.object(at: sender.tag) as! NSDictionary
        let id = dict.value(forKey: "id") as? Int ?? 0
        
      
        
        if let clinic_data = dict.value(forKey: "clinic_data") as? NSDictionary
            
        {
            //            if vendor_metaArray.count>0
            //
            //            {
            //
            //                let vendor_metaDict = vendor_metaArray.object(at: 0) as! NSDictionary
            self.vendor_metaDict=clinic_data
            
            //  }
        }
        self.bookingId = "\(id)"
      //  self.tabBarController?.tabBar.selectedItem.=UIColor.red
        
        let contentCV = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentPopupViewController") as! AppointmentPopupViewController
        
        contentCV.modalPresentationStyle = UIModalPresentationStyle.popover // 13
        let popPC = contentCV.popoverPresentationController // 14
        contentCV.delegate=self
        
        popPC?.backgroundColor = UIColor.clear
        
        contentCV.preferredContentSize = CGSize(width:140,height:90)
        contentCV.popoverPresentationController?.sourceRect =  (sender as! UIButton).bounds
        contentCV.popoverPresentationController?.sourceView = sender as? UIButton // button
        popPC?.delegate = self // 18
        present(contentCV, animated: true, completion: nil)
        
    }
    
    
    @objc func seeDirectionsBtnAction(_ sender:UIButton)
    {
        let dict = self.appointMentArray.object(at: sender.tag) as! NSDictionary
        
        if let clinic_data = dict.value(forKey: "clinic_data") as? NSDictionary
        {
            let Latitude =  clinic_data.value(forKey: "Latitude") as? String ?? ""
            let Longitude =  clinic_data.value(forKey: "Longitude") as? String ?? ""
            self.venueAddress=clinic_data.value(forKey: "address1") as? String ?? "India"
            self.venueLat=Latitude as NSString
            self.venueLng=Longitude as NSString
            openMapForPlace()
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
    
    
}
extension AppointmentTabViewController:AppoitnmentpopUpDataProtocol
{
    func inputData(data: String) {
        print("click three option = \(data)")
        self.dismiss(animated: false, completion: nil)
        
        
        if data.lowercased() == "cancel"
        {
            let alert=UIAlertController(title: "Alert!", message: "Are you sure want to cancel this appointment?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (UIAlertAction) in
                
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
                if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                {
                    NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
                }
                else
                {
                    self.CancelAppointmentAPI()
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else
            
        {
            let popUpVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePopupViewController") as! DatePopupViewController
            //Don't forget initialize protocal deletage
            // EditOrDelete = "Delete"
            //  popUpVc.from = "Delete"
            popUpVc.delegate = self
            self.addChild(popUpVc)
            popUpVc.view.frame = self.view.frame
            self.view.addSubview(popUpVc.view)
            popUpVc.didMove(toParent: self)
        }
        
    }
    
    
}

extension AppointmentTabViewController:datePopUpDataProtocol
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
                                self.ReschedulAppointmentAPI()
                                
                            }
                            
                        }
                        else
                        {
                            print("due in exactly a week (to the second, this will rarely happen in practice)")
                            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                            {
                                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
                            }
                            else
                            {
                                self.ReschedulAppointmentAPI()
                                
                            }
                            
                            
                            //                                let alert=UIAlertController(title: "Alert!", message: "please choose time between \(openTime) to \(closeTime)", preferredStyle: .alert)
                            //
                            //                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
                            //
                            //                                }))
                            //                                self.present(alert, animated: true) {
                            //
                            //                                }
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
                                self.ReschedulAppointmentAPI()
                                
                            }
                            
                        }
                        else
                        {
                            print("due in exactly a week (to the second, this will rarely happen in practice)")
                            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                            {
                                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
                            }
                            else
                            {
                                self.ReschedulAppointmentAPI()
                                
                            }
                            
                            
                            //                                let alert=UIAlertController(title: "Alert!", message: "please choose time between \(openTime) to \(closeTime)", preferredStyle: .alert)
                            //
                            //                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
                            //
                            //                                }))
                            //                                self.present(alert, animated: true) {
                            //
                            //                                }
                        }
                        
                        
                        
                        
                        
                    }
                    
                }
            }
            
        }
        
        
        
        
        print("Selected value \(selectedDate)")
        
        
        
        
        /*
         print(data)
         let dateFormatter: DateFormatter = DateFormatter()
         
         // Set date format
         dateFormatter.dateFormat = "MMMM d yyyy"
         
         // Apply date format
         let selectedDate: String = dateFormatter.string(from: data)
         self.appoinment_date=selectedDate
         
         
         let dateFormatter2: DateFormatter = DateFormatter()
         
         // Set date format
         dateFormatter2.dateFormat = "hh:mm a"
         
         // Apply date format
         let selectedDate2: String = dateFormatter2.string(from: data)
         
         
         self.time=selectedDate2
         
         if !(NetworkEngine.networkEngineObj.isInternetAvailable())
         {
         NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
         }
         else
         {
         self.ReschedulAppointmentAPI()
         }
         print("Selected value \(selectedDate)")
         
         */
        
    }
    
    
}

extension AppointmentTabViewController
{
    func GetAppointmentAPI()
    {
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
        
        ApiHandler.apiDataGetMethod2(url: GETBOOKAPPOINTMENTAPI, parameters: ["":""] , Header: header) { (response, error) in
            
            if error == nil
            {
                if let dict = response as? NSDictionary
                {
                    if let dataArray = dict.value(forKey: "data") as? NSArray
                    {
                        
                        self.appointMentArray = (dataArray.reversed() as! NSArray).mutableCopy() as! NSMutableArray
                        
                        if self.appointMentArray.count == 0
                        {
                            self.notfoundView.isHidden=false
                        }
                        else
                            
                        {
                            self.notfoundView.isHidden=true
                        }
                        self.myAppointmentTable.reloadData()
                    }
                    else
                    {
                        if self.appointMentArray.count>0
                        {
                            self.appointMentArray.removeAllObjects()
                        }
                        self.myAppointmentTable.reloadData()
                        self.notfoundView.isHidden=false
                    }
                    
                    SVProgressHUD.dismiss()
                }
                else
                {
                    if self.appointMentArray.count>0
                    {
                        self.appointMentArray.removeAllObjects()
                    }
                    self.myAppointmentTable.reloadData()
                    SVProgressHUD.dismiss()
                    self.view.makeToast(error)
                }
            }
            else
            {
                if self.appointMentArray.count>0
                {
                    self.appointMentArray.removeAllObjects()
                }
                self.myAppointmentTable.reloadData()
                SVProgressHUD.dismiss()
                self.view.makeToast(error)
            }
        }
    }
    func GetHistoryAPI()
    {
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
        
        ApiHandler.apiDataGetMethod2(url: HISTORYAPI, parameters: ["":""] , Header: header) { (response, error) in
            
            if error == nil
            {
                if let dict = response as? NSDictionary
                {
                    if let dataArray = dict.value(forKey: "data") as? NSArray
                    {
                        
                        self.HistoryArray = (dataArray.reversed() as! NSArray).mutableCopy() as! NSMutableArray
                        
                        
                        self.historytable.reloadData()
                    }
                    else
                    {
                        if self.HistoryArray.count>0
                        {
                            self.HistoryArray.removeAllObjects()
                        }
                        self.historytable.reloadData()
                        self.notfoundView.isHidden=false
                    }
                    if self.HistoryArray.count == 0
                    {
                        self.nodtaFoundLbl.isHidden=false
                    }
                    else
                    {
                        self.nodtaFoundLbl.isHidden=true
                    }
                    
                    SVProgressHUD.dismiss()
                }
                else
                {
                    if self.HistoryArray.count>0
                    {
                        self.HistoryArray.removeAllObjects()
                    }
                    self.historytable.reloadData()
                    SVProgressHUD.dismiss()
                    self.view.makeToast(error)
                }
            }
            else
            {
                if self.HistoryArray.count>0
                {
                    self.HistoryArray.removeAllObjects()
                }
                self.historytable.reloadData()
                SVProgressHUD.dismiss()
                self.view.makeToast(error)
            }
        }
    }
    
    
    
    func CancelAppointmentAPI()
    {
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
        let para = ["bookingId":self.bookingId] as [String:String]
        
        print("heder =  \(header) and para =  \(para)")
        ApiHandler.ModelApiPostMethod(url: CANCELAPPOINTMENTAPI, parameters: para , Header: header) { (response, error) in
            
            if error == nil
            {
                self.GetAppointmentAPI()
            }
            else
            {
                SVProgressHUD.dismiss()
                self.view.makeToast(error)
            }
        }
    }
    func ReschedulAppointmentAPI()
    {
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
        let para = ["bookingId":self.bookingId,
                    "appoinment_date":self.appoinment_date,"time":self.time,
            ] as [String:String]
        
        print("heder =  \(header) and para =  \(para)")
        ApiHandler.ModelApiPostMethod(url: RESCHEDULEAPPOINTMENTAPI, parameters: para , Header: header) { (response, error) in
            
            if error == nil
            {
                self.GetAppointmentAPI()
            }
            else
            {
                SVProgressHUD.dismiss()
                self.view.makeToast(error)
            }
        }
    }
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let date2 = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMMM d, yyyy"
        if date2 != nil
        {
            return  dateFormatter.string(from: date2!)
        }
        else
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            let date3 = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "MMMM d, yyyy"
            return  "June 06,2020"//dateFormatter.string(from: date3!)
        }
        
        //                    if date2 != nil
        //
        //                    {
        //                        return  dateFormatter.string(from: date2!)
        //                    }
        //                     else
        //                    {
        //                        let dateFormatter = DateFormatter()
        //                        dateFormatter.dateFormat = "MMMM d, yyyy"
        //                        let date = dateFormatter.date(from: date)
        //                        dateFormatter.dateFormat = "MMMM d, yyyy")
        //                         return  dateFormatter.string(from: date2!)
        //                    }
        
    }
    
}

extension AppointmentTabViewController:UIPopoverPresentationControllerDelegate
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
    
    //===MARK:---- calculate difference
    func UTCToLocal(date:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        
        return dateFormatter.string(from: dt!)
    }
    
    
    func dateDiff(dateStr:String) -> String
    {
        let f:DateFormatter = DateFormatter()
        f.timeZone = NSTimeZone.local
        //        f.dateFormat = "yyyy-M-dd'T'HH:mm:ss.SSSZZZ"
        //"2020-01-10 09:59:12.973910"
        
        f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        let now = f.string(from: NSDate() as Date)
        let startDate = f.date(from: dateStr)
        let endDate = f.date(from: now)
        let calendar: NSCalendar = NSCalendar.current as NSCalendar
        
        let calendarUnits:NSCalendar.Unit = [.weekOfMonth,.day, .hour, .minute, .second]
        let dateComponents = calendar.components(calendarUnits, from: startDate!, to: endDate!, options: [])
        let weeks = abs(Int32(dateComponents.weekOfMonth!))
        let days = abs(Int32(dateComponents.day!))
        let hours = abs(Int32(dateComponents.hour!))
        let min = abs(Int32(dateComponents.minute!))
        let sec = abs(Int32(dateComponents.second!))
        
        var timeAgo = ""
        
        
        if (sec > 0)
        {
            if (sec > 1)
            {
                timeAgo = "\(sec) Seconds Ago"
            } else {
                timeAgo = "\(sec) Second Ago"
            }
        }
        
        if (min > 0){
            if (min > 1) {
                timeAgo = "\(min) Minutes Ago"
            } else {
                timeAgo = "\(min) Minute Ago"
            }
        }
        
        if(hours > 0){
            if (hours > 1) {
                timeAgo = "\(hours) Hours Ago"
            } else {
                timeAgo = "\(hours) Hour Ago"
            }
        }
        
        if (days > 0) {
            
            if days == 1
            {
                timeAgo = "\(days) Day Ago"
            }
            else
            {
                timeAgo = "\(days) Days Ago"
            }
        }
        
        if(weeks > 0){
            if (weeks > 1) {
                timeAgo = "\(weeks) Weeks Ago"
            }
            else
            {
                timeAgo = "\(weeks) Weeks Ago"
            }
        }
        
        
        
        
        print("timeAgo is===> \(timeAgo)")
        return timeAgo;
    }
    
}


