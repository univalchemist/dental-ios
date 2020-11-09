//
//  DatePopupViewController.swift
//  Dental Place
//
//  Created by AMARENDRA on 16/04/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
protocol datePopUpDataProtocol
{
    func dateInputData(data:Date)
}

class DatePopupViewController: UIViewController {
     @IBOutlet weak var btn2: UIButton!
       
       @IBOutlet weak var btn1: UIButton!
     @IBOutlet weak var datePickr: UIDatePicker!
       var delegate:datePopUpDataProtocol? = nil
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor
                   .black.withAlphaComponent(0.5)
         datePickr.timeZone = NSTimeZone.local
        let dateFormatter: DateFormatter = DateFormatter()
       datePickr.minimumDate = Calendar.current.date(byAdding: .hour, value: 0, to: Date())
        
               // Set date format
               dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        // Do any additional setup after loading the view.
    }

    
     @IBAction func btn2Action(_ sender: UIButton)
     {
         //"Check Delegate nil"
         if(delegate != nil)
         {
            print(datePickr.date)
            delegate?.dateInputData(data: datePickr.date ?? Date())
             self.view.removeFromSuperview()
             
             
         }
     }
     
     @IBAction func btn1Action(_ sender: UIButton)
     {
//         if from=="Send push notification"
//         {
//             delegate?.dateInputData(data: sender.titleLabel?.text! ?? "NO")
//         }
         
         self.view.removeFromSuperview()
     }
}
