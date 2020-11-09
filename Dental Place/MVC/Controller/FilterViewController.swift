//
//  FilterViewController.swift
//  Dental Place
//
//  Created by eWeb on 17/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import RangeSeekSlider
import FloatRatingView

class FilterViewController: UIViewController,RangeSeekSliderDelegate {

    @IBOutlet weak var rangeLbl: UILabel!
    
    var sliderChange = "no"
    
    // UI views
    
    var ratingSelected = "0"
    
     @IBOutlet weak var MainView: UIView!
    
    
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var TwoStarView: UIView!
    @IBOutlet weak var threeStarView: UIView!
    @IBOutlet weak var fourStarView: UIView!
    
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var twoPlus: UILabel!
    @IBOutlet weak var threePlus: UILabel!
    @IBOutlet weak var fourPlus: UILabel!
    
    @IBOutlet weak var costRange: RangeSeekSlider!
    
    // Star Images
    
    
    @IBOutlet weak var twoStarImg: UIImageView!
    @IBOutlet weak var ThreeStarImg: UIImageView!
    @IBOutlet weak var fourStarImg: UIImageView!
    
    // two star
    
    @IBOutlet weak var two1: UIImageView!
    
    @IBOutlet weak var two2: UIImageView!
    
    //three star
    
    @IBOutlet weak var three1: UIImageView!
    
    @IBOutlet weak var three2: UIImageView!
    
    @IBOutlet weak var three3: UIImageView!
    
    
    //four star
    
    @IBOutlet weak var four1: UIImageView!
    @IBOutlet weak var four2: UIImageView!
    
    @IBOutlet weak var four3: UIImageView!
    @IBOutlet weak var four4: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        costRange.delegate=self
        
        
        // All View
        
        self.allView.layer.borderWidth = 0.5
        //        self.allView.layer.cornerRadius = 6
        self.allView.layer.borderColor = UIColor.lightGray.cgColor
        
      
        
        // 2 View
        
        self.TwoStarView.layer.borderWidth =  0.5
        //        self.TwoStarView.layer.cornerRadius = 6
        self.TwoStarView.layer.borderColor = UIColor.lightGray.cgColor
        self.twoPlus.textColor = UIColor(red: 211/255.0, green: 219/255.0, blue: 227/255.0, alpha: 1)
        // 3 View
        
        self.threeStarView.layer.borderWidth =  0.5
        //        self.threeStarView.layer.cornerRadius = 6
        self.threeStarView.layer.borderColor = UIColor.lightGray.cgColor
        
        // 4 view
        
        self.fourStarView.layer.borderWidth =  0.5
        //        self.fourStarView.layer.cornerRadius = 6
        self.fourStarView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        self.allView.backgroundColor = UIColor.white
        self.TwoStarView.backgroundColor = UIColor(red: 35/255.0, green: 165/255.0, blue: 151/255.0, alpha: 1)
        self.threeStarView.backgroundColor = UIColor.white
        self.fourStarView.backgroundColor = UIColor.white
//        self.twoStarImg.image = #imageLiteral(resourceName: "2 stars")
//        self.ThreeStarImg.image = #imageLiteral(resourceName: "ThreeFillStar")
//        self.fourStarImg.image = #imageLiteral(resourceName: "FourFillStar")
//        
//        allView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 5)
//        fourStarView.roundCorners(corners: [.topRight, .bottomRight], radius: 5)
//
        self.MainView.layer.borderWidth =  0.5
        //        self.fourStarView.layer.cornerRadius = 6
        self.MainView.layer.borderColor = UIColor.lightGray.cgColor
        self.MainView.layer.cornerRadius = 5
        self.MainView.clipsToBounds = true
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        if let min = DEFAULT.value(forKey: "minimum") as? String
        {
            let value = Int(min)!
            self.costRange.selectedMinValue = CGFloat(value)
            
        
          if let max = DEFAULT.value(forKey: "maximum") as? String
               {
                let value = Int(max)!
                self.costRange.selectedMaxValue = CGFloat(value)
                 self.rangeLbl.text = "$"+"\(min)"+"-"+"$"+"\(max)"
             }
          }
        if let rating = DEFAULT.value(forKey: "SELECTEDFILTER") as? String
               {
                  if rating=="2"
                  {
                    self.two1.image=#imageLiteral(resourceName: "whiteStar2")
                           self.two2.image=#imageLiteral(resourceName: "whiteStar2")
                           self.three1.image=#imageLiteral(resourceName: "GreenStar")
                           self.three2.image=#imageLiteral(resourceName: "GreenStar")
                           self.three3.image=#imageLiteral(resourceName: "GreenStar")
                           self.four1.image=#imageLiteral(resourceName: "GreenStar")
                           self.four2.image=#imageLiteral(resourceName: "GreenStar")
                           self.four3.image=#imageLiteral(resourceName: "GreenStar")
                           self.four4.image=#imageLiteral(resourceName: "GreenStar")
                    self.allView.backgroundColor = UIColor.white
                    self.TwoStarView.backgroundColor = UIColor(red: 35/255.0, green: 165/255.0, blue: 151/255.0, alpha: 1)
                    self.threeStarView.backgroundColor = UIColor.white
                    self.fourStarView.backgroundColor = UIColor.white
                  }
                else if rating=="3"
                  {
                    self.two1.image=#imageLiteral(resourceName: "GreenStar")
                         self.two2.image=#imageLiteral(resourceName: "GreenStar")
                         self.three1.image=#imageLiteral(resourceName: "whiteStar2")
                         self.three2.image=#imageLiteral(resourceName: "whiteStar2")
                         self.three3.image=#imageLiteral(resourceName: "whiteStar2")
                         self.four1.image=#imageLiteral(resourceName: "GreenStar")
                         self.four2.image=#imageLiteral(resourceName: "GreenStar")
                         self.four3.image=#imageLiteral(resourceName: "GreenStar")
                         self.four4.image=#imageLiteral(resourceName: "GreenStar")
                         
        self.allView.backgroundColor = UIColor.white
            self.TwoStarView.backgroundColor = UIColor.white
            self.threeStarView.backgroundColor = UIColor(red: 35/255.0, green: 165/255.0, blue: 151/255.0, alpha: 1)
            self.fourStarView.backgroundColor = UIColor.white
            }
            else if rating=="4"
            {
        self.allView.backgroundColor = UIColor.white
        self.TwoStarView.backgroundColor = UIColor.white
        self.threeStarView.backgroundColor = UIColor.white
        self.fourStarView.backgroundColor = UIColor(red: 35/255.0, green: 165/255.0, blue: 151/255.0, alpha: 1)
                self.two1.image=#imageLiteral(resourceName: "GreenStar")
                     self.two2.image=#imageLiteral(resourceName: "GreenStar")
                     self.three1.image=#imageLiteral(resourceName: "GreenStar")
                     self.three2.image=#imageLiteral(resourceName: "GreenStar")
                     self.three3.image=#imageLiteral(resourceName: "GreenStar")
                     self.four1.image=#imageLiteral(resourceName: "whiteStar2")
                     self.four2.image=#imageLiteral(resourceName: "whiteStar2")
                     self.four3.image=#imageLiteral(resourceName: "whiteStar2")
                     self.four4.image=#imageLiteral(resourceName: "whiteStar2")
        }
        else
        {
        self.allView.backgroundColor = UIColor(red: 35/255.0, green: 165/255.0, blue: 151/255.0, alpha: 1)
        self.TwoStarView.backgroundColor = UIColor.white
            self.threeStarView.backgroundColor = UIColor.white
        self.fourStarView.backgroundColor = UIColor.white
                                 self.two1.image=#imageLiteral(resourceName: "GreenStar")
                                    self.two2.image=#imageLiteral(resourceName: "GreenStar")
                                    self.three1.image=#imageLiteral(resourceName: "GreenStar")
                                    self.three2.image=#imageLiteral(resourceName: "GreenStar")
                                    self.three3.image=#imageLiteral(resourceName: "GreenStar")
                                    self.four1.image=#imageLiteral(resourceName: "GreenStar")
                                    self.four2.image=#imageLiteral(resourceName: "GreenStar")
                                    self.four3.image=#imageLiteral(resourceName: "GreenStar")
                                    self.four4.image=#imageLiteral(resourceName: "GreenStar")
                }
    }
        else
        {
        self.allView.backgroundColor = UIColor(red: 35/255.0, green: 165/255.0, blue: 151/255.0, alpha: 1)
        self.TwoStarView.backgroundColor = UIColor.white
            self.threeStarView.backgroundColor = UIColor.white
        self.fourStarView.backgroundColor = UIColor.white
            self.two1.image=#imageLiteral(resourceName: "GreenStar")
               self.two2.image=#imageLiteral(resourceName: "GreenStar")
               self.three1.image=#imageLiteral(resourceName: "GreenStar")
               self.three2.image=#imageLiteral(resourceName: "GreenStar")
               self.three3.image=#imageLiteral(resourceName: "GreenStar")
               self.four1.image=#imageLiteral(resourceName: "GreenStar")
               self.four2.image=#imageLiteral(resourceName: "GreenStar")
               self.four3.image=#imageLiteral(resourceName: "GreenStar")
               self.four4.image=#imageLiteral(resourceName: "GreenStar")
        }
    }
    
    @IBAction func filterBtn(_ sender: UIButton)
      {
          let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchView") as! SearchView
          //self.present(vc, animated: true, completion: nil)
          self.navigationController?.pushViewController(vc, animated: true)
      }
    
    @IBAction func AllBtnAct(_ sender: UIButton)
    {
         self.allBtn.setTitleColor(UIColor.white, for: .normal)
        self.allView.backgroundColor = UIColor(red: 35/255.0, green: 165/255.0, blue: 151/255.0, alpha: 1)
        self.TwoStarView.backgroundColor = UIColor.white
        self.threeStarView.backgroundColor = UIColor.white
        self.fourStarView.backgroundColor = UIColor.white
        self.ratingSelected = "0"
    
        
        self.two1.image=#imageLiteral(resourceName: "GreenStar")
        self.two2.image=#imageLiteral(resourceName: "GreenStar")
        self.three1.image=#imageLiteral(resourceName: "GreenStar")
        self.three2.image=#imageLiteral(resourceName: "GreenStar")
        self.three3.image=#imageLiteral(resourceName: "GreenStar")
        self.four1.image=#imageLiteral(resourceName: "GreenStar")
        self.four2.image=#imageLiteral(resourceName: "GreenStar")
        self.four3.image=#imageLiteral(resourceName: "GreenStar")
        self.four4.image=#imageLiteral(resourceName: "GreenStar")
        
//        self.twoStarImg.image = #imageLiteral(resourceName: "2 stars")
//        self.ThreeStarImg.image = #imageLiteral(resourceName: "3 stars")
//        self.fourStarImg.image = #imageLiteral(resourceName: "4 stars")
        
    }
    @IBAction func TwoStarAct(_ sender: UIButton)
    {
        self.allBtn.setTitleColor(APPTEXTCOLOL, for: .normal)
        self.allView.backgroundColor = UIColor.white
        self.TwoStarView.backgroundColor = UIColor(red: 35/255.0, green: 165/255.0, blue: 151/255.0, alpha: 1)
        self.threeStarView.backgroundColor = UIColor.white
        self.fourStarView.backgroundColor = UIColor.white
//        self.twoStarImg.image = #imageLiteral(resourceName: "2 stars")
//        self.ThreeStarImg.image = #imageLiteral(resourceName: "ThreeFillStar")
//        self.fourStarImg.image = #imageLiteral(resourceName: "FourFillStar")
        self.ratingSelected="2"
//               DEFAULT.set("2", forKey: "SELECTEDFILTER")
//               DEFAULT.synchronize()
//
        self.two1.image=#imageLiteral(resourceName: "whiteStar2")
        self.two2.image=#imageLiteral(resourceName: "whiteStar2")
        self.three1.image=#imageLiteral(resourceName: "GreenStar")
        self.three2.image=#imageLiteral(resourceName: "GreenStar")
        self.three3.image=#imageLiteral(resourceName: "GreenStar")
        self.four1.image=#imageLiteral(resourceName: "GreenStar")
        self.four2.image=#imageLiteral(resourceName: "GreenStar")
        self.four3.image=#imageLiteral(resourceName: "GreenStar")
        self.four4.image=#imageLiteral(resourceName: "GreenStar")
    }
    @IBAction func ThreeStar(_ sender: UIButton)
    {
         self.allBtn.setTitleColor(APPTEXTCOLOL, for: .normal)
        self.allView.backgroundColor = UIColor.white
        self.TwoStarView.backgroundColor = UIColor.white
        self.threeStarView.backgroundColor = UIColor(red: 35/255.0, green: 165/255.0, blue: 151/255.0, alpha: 1)
        self.fourStarView.backgroundColor = UIColor.white
        self.ratingSelected="3"
//               DEFAULT.set("3", forKey: "SELECTEDFILTER")
//               DEFAULT.synchronize()
        self.two1.image=#imageLiteral(resourceName: "GreenStar")
        self.two2.image=#imageLiteral(resourceName: "GreenStar")
        self.three1.image=#imageLiteral(resourceName: "whiteStar2")
        self.three2.image=#imageLiteral(resourceName: "whiteStar2")
        self.three3.image=#imageLiteral(resourceName: "whiteStar2")
        self.four1.image=#imageLiteral(resourceName: "GreenStar")
        self.four2.image=#imageLiteral(resourceName: "GreenStar")
        self.four3.image=#imageLiteral(resourceName: "GreenStar")
        self.four4.image=#imageLiteral(resourceName: "GreenStar")
        
        
        //self.twoStarImg.image = #imageLiteral(resourceName: "Group 158")
        //self.ThreeStarImg.image = #imageLiteral(resourceName: "3 stars")
       // self.fourStarImg.image = #imageLiteral(resourceName: "FourFillStar")
    }
    @IBAction func fourStar(_ sender: UIButton)
    {
         self.allBtn.setTitleColor(APPTEXTCOLOL, for: .normal)
        self.allView.backgroundColor = UIColor.white
        self.TwoStarView.backgroundColor = UIColor.white
        self.threeStarView.backgroundColor = UIColor.white
//        self.twoStarImg.image = #imageLiteral(resourceName: "Group 158")
//        self.ThreeStarImg.image = #imageLiteral(resourceName: "ThreeFillStar")
//        self.fourStarImg.image = #imageLiteral(resourceName: "4 stars")
        
        self.ratingSelected="4"
              
        self.two1.image=#imageLiteral(resourceName: "GreenStar")
        self.two2.image=#imageLiteral(resourceName: "GreenStar")
        self.three1.image=#imageLiteral(resourceName: "GreenStar")
        self.three2.image=#imageLiteral(resourceName: "GreenStar")
        self.three3.image=#imageLiteral(resourceName: "GreenStar")
        self.four1.image=#imageLiteral(resourceName: "whiteStar2")
        self.four2.image=#imageLiteral(resourceName: "whiteStar2")
        self.four3.image=#imageLiteral(resourceName: "whiteStar2")
        self.four4.image=#imageLiteral(resourceName: "whiteStar2")
        
        self.fourStarView.backgroundColor = UIColor(red: 35/255.0, green: 165/255.0, blue: 151/255.0, alpha: 1)
        
    }
    
    
    
    
    @IBAction func ApplyFilter(_ sender: UIButton)
    {
        let SearchView = self.storyboard?.instantiateViewController(withIdentifier: "ListMapTabViewController") as! ListMapTabViewController
        //self.navigationController?.popViewController(animated: true)
        let min = Int(self.costRange.selectedMinValue)
      let max = Int(self.costRange.selectedMaxValue)
        let avgPrice=(min+max)/2
        
//        if DEFAULT.value(forKey: "SELECTEDFILTER") == nil
//        {
//            DEFAULT.set("0", forKey: "SELECTEDFILTER")
//                   DEFAULT.synchronize()
//        }
        DEFAULT.set(ratingSelected, forKey: "SELECTEDFILTER")
        DEFAULT.synchronize()
        
        DEFAULT.set("\(min)", forKey: "minimum")
         DEFAULT.set("\(max)", forKey: "maximum")
        DEFAULT.set("\(avgPrice)", forKey: "avgprice")
        DEFAULT.synchronize()
        self.navigationController?.pushViewController(SearchView, animated: true)

        //APPDEL.loadHomeView()
    }
    @IBAction func clearFilter(_ sender: UIButton)
      {
         
        DEFAULT.removeObject(forKey: "maximum")
        DEFAULT.removeObject(forKey: "minimum")
        DEFAULT.removeObject(forKey: "avgprice")
        DEFAULT.removeObject(forKey: "SELECTEDFILTER")
        DEFAULT.removeObject(forKey: "CategoryId")
        DEFAULT.removeObject(forKey: "CategoryName")
        DEFAULT.removeObject(forKey: "CategorySelected")
      
        DEFAULT.synchronize()
          
        APPDEL.loadHomeView()
      }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        
       let min = Int(minValue)
        let max = Int(maxValue)
       // self.rangeLbl.text = "\(min)"+"-"+"\(max)"
         self.rangeLbl.text = "$"+"\(min)"+"-"+"$"+"\(max)"
        self.sliderChange = "yes"
    }
    
}
