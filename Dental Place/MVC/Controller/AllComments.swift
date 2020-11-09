//
//  AllComments.swift
//  Dental Place
//
//  Created by eWeb on 13/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import FloatRatingView
import  SVProgressHUD
class AllComments: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var catData:CategoryModel?
    
    @IBOutlet weak var allcommentTable: UITableView!
    
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var avgRating: UILabel!
    @IBOutlet weak var clinicnmeLbl: UILabel!
    @IBOutlet weak var serviceNem: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    var AllCommentArray = NSMutableArray()
    
    var star_rate = ""
    var clinicId = ""
    var servicename = ""
    var clinicName = ""
    var profile = ""
    var location = ""
    var profileImage = ""
    var yelp_id = ""
    var detailDict = NSDictionary()
    var yelpReviewArray=NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        allcommentTable.register(UINib(nibName: "AllcommentTableCell", bundle: nil), forCellReuseIdentifier: "AllcommentTableCell")
        allcommentTable.rowHeight=100
        allcommentTable.estimatedRowHeight=UITableView.automaticDimension
        
        
        let dict = detailDict
        
        let rating = dict.value(forKey: "reviewsAvg") as? Double ?? 0.0
        
        ratingView.rating = Double(rating)
        avgRating.text = "\(rating.round(to: 2))"
        
        profileImg.layer.cornerRadius=profileImg.frame.height/2
        profileImg.clipsToBounds=true
        
        self.locationLbl.text = location
        self.serviceNem.text = servicename
        
        //let dict = detailDict
        
        
        // avgRating.text = dict.value(forKey: "star_rate") as? String ?? ""
        
        
        //let rating = dict.value(forKey: "star_rate") as? String ?? "1"
        // ratingView.rating = Double(rating)!
        profileImg.layer.cornerRadius=profileImg.frame.height/2
        profileImg.clipsToBounds=true
        
        if let clilicDict = dict.value(forKey: "owner_data") as? NSDictionary
        {
            
            
            clinicnmeLbl.text = clilicDict.value(forKey: "user_name") as? String ?? ""
            
            
            if let url2 = clilicDict.value(forKey: "profile_image") as? String
            {
                let fullurl =  url2
                
                print("Image full url \(fullurl)")
                let url = URL(string: fullurl)
                
                profileImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
            }
            
        }
        
        
        
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.getAllReviewApi()
            //  self.fetchYelpBusinessesReview()
            
        }
        
    }
    
    @IBAction func goback(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.AllCommentArray.count+self.yelpReviewArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllcommentTableCell") as! AllcommentTableCell
        
        if indexPath.row<self.AllCommentArray.count
        {
            let dict = self.AllCommentArray.object(at: indexPath.row) as! NSDictionary
            
            cell.messagelbl.text = dict.value(forKey: "feedback") as? String ?? ""
            cell.avgrating.text = dict.value(forKey: "star_rate") as? String ?? ""
            cell.datelbl.text = self.convertDateFormater(dict.value(forKey: "created_at") as? String ?? "")
            
            let rating = dict.value(forKey: "star_rate") as? String ?? "1"
            cell.ratingView.rating = Double(rating)!
            cell.profileImg.contentMode = .scaleAspectFill
            
            cell.profileImg.layer.cornerRadius=cell.profileImg.frame.height/2
            cell.profileImg.clipsToBounds=true
            
            if let userDataArray = dict.value(forKey: "userData") as? NSArray
            {
                if userDataArray.count>0
                {
                    let dict2=userDataArray.object(at: 0) as! NSDictionary
                    if let url2 = dict2.value(forKey: "profile_image") as? String
                    {
                        let fullurl =   url2
                        
                        print("Image full url \(fullurl)")
                        let url = URL(string: fullurl)
                        
                        cell.profileImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
                    }
                    if let user_name = dict2.value(forKey: "user_name") as? String
                    {
                        cell.username.text = user_name
                    }
                }
            }
        }
        else
            
        {
            
            let index =  indexPath.row-self.AllCommentArray.count
            
            let dict = self.yelpReviewArray.object(at: index) as! NSDictionary
            
            cell.messagelbl.text = dict.value(forKey: "text") as? String ?? ""
            var rating = dict.value(forKey: "rating") as? Int ?? 0
            cell.avgrating.text = "\(rating)"
            cell.datelbl.text = self.convertDateFormater2(dict.value(forKey: "time_created") as? String ?? "")
            
            //let rating = dict.value(forKey: "star_rate") as? String ?? "1"
            cell.ratingView.rating = Double(rating)
            cell.profileImg.layer.cornerRadius=cell.profileImg.frame.height/2
            cell.profileImg.clipsToBounds=true
            cell.profileImg.contentMode = .scaleAspectFill
            
            if let userDict = dict.value(forKey: "user") as? NSDictionary
            {
                let fullurl =  userDict.value(forKey: "image_url") as? String ?? ""
                
                print("Image full url \(fullurl)")
                let url = URL(string: fullurl)
                
                cell.profileImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Mask Group 6"), options: .refreshCached, completed: nil)
                if let user_name = userDict.value(forKey: "name") as? String
                {
                    cell.username.text = user_name
                }
            }
            
            
            
        }
        
        
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    //MARK:- all review Api
    
    func getAllReviewApi()
    {
        var apiKey = "1234"
        if let newuserEmail1 = DEFAULT.value(forKey: "APITOKEN") as? String
        {
            apiKey = "\(newuserEmail1)"
        }
        
        
        let params = ["clinic_Id" : self.clinicId] as [String:String]
        
        SVProgressHUD.show()
        
        
        
        print("para in book appotment = \(params)")
        var DEVICETOKEN = "123456"
        if let device = DEFAULT.value(forKey: "DEVICETOKEN") as? String
        {
            DEVICETOKEN = device
        }
        
        
        let header = ["device-id":DEVICETOKEN,"device-type":"iOS","type":"iOS","api-token":apiKey] as [String:String]
        
        ApiHandler.apiDataPostMethod(url: GETALLREVIEWAPI, parameters: params, Header: header) { (response, error) in
            
            if error == nil
            {
                print(response)
                
                if let dict = response as? NSDictionary
                {
                    if let data = dict.value(forKey: "data") as? NSArray
                    {
                        self.AllCommentArray=data.mutableCopy() as! NSMutableArray
                        //  self.allcommentTable.reloadData()
                        
                    }
                    self.fetchYelpBusinessesReview()
                }
                
                
            }
            else
            {
                SVProgressHUD.dismiss()
                self.allcommentTable.reloadData()
                self.view.makeToast(error)
            }
        }
    }
    
    
    
    
    func convertDateFormater(_ date: String) -> String
    {
        
        //2020-04-20 15:44:45
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
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
    
    func convertDateFormater2(_ date: String) -> String
    {
        
        //2020-04-20 15:44:45
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
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
            return  "June 02, 2020"
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
    
    fileprivate func fetchYelpBusinessesReview()
    {
        SVProgressHUD.show()
        
        let apikey = "JirnDvucDtITkVBEgoR4tmKM0j3FroivAqecvL2UYxYNkXnf3APYUfmdfC2ZF90udn8KFVOeNU-oXZlaS35HAlwPx9NQtZO0D5Ywc_r_JfXXrh02vJBptjolDmTFXnYx"
        let url1 = "https://api.yelp.com/v3/businesses/"+self.yelp_id+"/reviews"
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
                    DispatchQueue.main.sync {
                        self.allcommentTable.reloadData()
                        
                    }
                    SVProgressHUD.dismiss()
                    
                    print(">>>>>", json, #line, "<<<<<<<<<")
                    
                }
                
            } catch {
                SVProgressHUD.dismiss()
                self.allcommentTable.reloadData()
                
                print("caught")
            }
            }.resume()
    }
    
    
    func CatAPI()
    {        var apiKey = "1234"
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
        
        ApiHandler.ModelApiGetMethod(url: CATAPI , Header: header) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.catData = try decoder.decode(CategoryModel.self, from: response!)
                    //self.view.makeToast(self.loginData?.message)
                    
                    
                    if self.catData?.code == "201"
                        
                    {
                        
                    }
                    else
                    {
                        NetworkEngine.commonAlert(message: self.catData?.message ?? "", vc: self)
                    }
                    
                    
                }
                catch let error
                {
                    self.view.makeToast(error.localizedDescription)
                    print(error)
                }
                
            }
            else
            {
                self.view.makeToast(error)
            }
        }
    }
    
}
extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
