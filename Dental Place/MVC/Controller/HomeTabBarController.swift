//
//  HomeTabBarController.swift
//  Dental Place
//
//  Created by eWeb on 12/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
       UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "FiraSans-Regular", size: 12)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "FiraSans-Regular", size: 12)!], for: .selected)
        self.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    
    // UITabBarControllerDelegate
   
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)!
        if selectedIndex == 0
        {
            print("first tab bar was selected")
            DEFAULT.set("first", forKey: "FIRST")
            DEFAULT.synchronize()
                NotificationCenter.default.post(name: Notification.Name("HomePageRefreshNoti"), object: nil)
            
        }
            else  if selectedIndex == 1
            {
                print("SECOND tab bar was selected")
                DEFAULT.set("SECOND", forKey: "SECOND")
                DEFAULT.synchronize()
                    NotificationCenter.default.post(name: Notification.Name("AppointmentPageRefreshNoti"), object: nil)
            }
        else  if selectedIndex == 2
        {
            print("first tab bar was selected")
            DEFAULT.set("THIRD", forKey: "THIRD")
            DEFAULT.synchronize()
            
                NotificationCenter.default.post(name: Notification.Name("ChatPageRefreshNoti"), object: nil)
        }
        else if selectedIndex == 3
        {
            NotificationCenter.default.post(name: Notification.Name("ProfilePageRefreshNoti"), object: nil)
        }
    }
}
