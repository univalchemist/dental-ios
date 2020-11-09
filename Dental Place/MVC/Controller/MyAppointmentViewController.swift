//
//  MyAppointmentViewController.swift
//  Dental Place
//
//  Created by eWeb on 17/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class MyAppointmentViewController: UIViewController {

    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var myAppointmentTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if DEFAULT.value(forKey: "STARTAPP") != nil
//        {
//            DEFAULT.removeObject(forKey: "STARTAPP")
//            DEFAULT.synchronize()
//
//            self.topConst.constant = -30
//        }
//        else
//        {
//            self.topConst.constant = 0
//        }
       
        myAppointmentTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0); //values

        
        // Do any additional setup after loading the view.
        myAppointmentTable.register(UINib(nibName: "MyAppointmentTableViewCell", bundle: nil), forCellReuseIdentifier: "MyAppointmentTableViewCell")
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
}
extension MyAppointmentViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 385
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAppointmentTableViewCell") as! MyAppointmentTableViewCell
        cell.threeDotsBtn.tag = indexPath.row
        cell.threeDotsBtn.addTarget(self, action: #selector(threeDotsBtnAction), for: .touchUpInside)
        
        return cell
    }
    
    
    //MARK:- Three dot  Button Act
    
    @objc func threeDotsBtnAction(_ sender:UIButton)
    {
      //  self.threeDotIndex = sender.tag
        
       // let dict = self.homeDataArray.object(at: sender.tag) as! NSDictionary//self.NewHomePageModelData?.data?.reversed()[sender.tag]
        
     //   self.deletePostId = dict.value(forKey: "id") as? String ?? "0"//dict?.id ?? "0"
        
        
        
        let contentCV = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentPopupViewController") as! AppointmentPopupViewController
        
        contentCV.modalPresentationStyle = UIModalPresentationStyle.popover // 13
        let popPC = contentCV.popoverPresentationController // 14
        
        popPC?.backgroundColor = UIColor.white
        
        contentCV.preferredContentSize = CGSize(width:90,height:100)
        contentCV.popoverPresentationController?.sourceRect =  (sender as! UIButton).bounds
        contentCV.popoverPresentationController?.sourceView = sender as? UIButton // button
        popPC?.delegate = self // 18
        present(contentCV, animated: true, completion: nil)
        
    }
    
    
    
}
extension MyAppointmentViewController:UIPopoverPresentationControllerDelegate
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
