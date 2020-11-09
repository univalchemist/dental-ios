//
//  AppDelegate.swift
//  Moocher
//
//  Created by administrator on 08/05/19.
//  Copyright © 2019 administrator. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps
import UserNotifications
import UserNotificationsUI
import RangeSeekSlider
import FBSDKCoreKit

import FBSDKLoginKit
import FBSDKCoreKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate
{
    
    var window: UIWindow?
      let manager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
//        if let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as? UIView
//        {
//            statusBar.backgroundColor = STATUSBARCOLOR//UIColor.init(red: 205.0/255.0, green: 73.0/255.0, blue: 146.0/255.0, alpha: 1)
//
//        }
        manager.delegate=self
        
        DEFAULT.removeObject(forKey: "last_name")
         DEFAULT.removeObject(forKey: "first_name")
        DEFAULT.set("STARTAPP", forKey: "STARTAPP")
        DEFAULT.synchronize()
     
        //amr sir key : AIzaSyCiwuCSudERBUHjj16C85dvRiN62LCFqYA
        // place api key : AIzaSyC2GzUZv1c5z5Id7l0bZTGexLL5E0SLFvo
        
        //AIzaSyCIP5XpjREmM2JXWNg4CiKnK2-56xekAd4
        
        GMSPlacesClient.provideAPIKey("AIzaSyC2GzUZv1c5z5Id7l0bZTGexLL5E0SLFvo")
        GMSServices.provideAPIKey("AIzaSyC2GzUZv1c5z5Id7l0bZTGexLL5E0SLFvo")
        
//        GMSPlacesClient.provideAPIKey("AIzaSyCIP5XpjREmM2JXWNg4CiKnK2-56xekAd4")
//               GMSServices.provideAPIKey("AIzaSyCIP5XpjREmM2JXWNg4CiKnK2-56xekAd4")
        //fb  .sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Git application
        
        if (DEFAULT.value(forKey: "APITOKEN") as? String) != nil
        {

         loadHomeView()

        }
        else
        {
          loadLoginView()
        }
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        UIFont.familyNames.forEach({ familyName in
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            print(familyName, fontNames)
        })
        
        registerForRemoteNotification()
        return true
    }
    
    override init() {
        super.init()
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "FiraSans-Bold", size: 21)!]
        UIFont.overrideInitialize()
    }
    
   
    
//    func application(_ app: UIApplication, open url: URL, options:[UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
//    {
//        let handled: Bool = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
//        return handled
//    }
    
    //MARK:-- remote notifications methods---
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *)
        {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil
                {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            // For iOS 10 data message (sent via FCM
            //            Messaging.messaging().delegate = self
            
        }
        else
        {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
    }
    //MARK:-- remote notifications methods---
    func UnregisterForRemoteNotification() {
        if #available(iOS 10.0, *)
        {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: []) { (granted, error) in
                if error == nil
                {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            // For iOS 10 data message (sent via FCM
            //            Messaging.messaging().delegate = self
            
        }
        else
        {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
    }
    
    func notificationBlock()
    {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    //MARK:- Notification Methods------
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        print(notification.request.content.userInfo)
        
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        
        if DEFAULT.value(forKey: "NOTION") != nil
        {
            if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
            {
                
                if let dict = info["0"] as? NSDictionary
                {
                    let noti_type = dict.value(forKey: "type") as? String
                    
                    if noti_type == "22"
                    {
                        completionHandler([])
                    }
                    else
                    {
                        completionHandler([.alert, .badge, .sound])
                    }
                }
                else
                {
                    completionHandler([.alert, .badge, .sound])
                }
            }
            else
            {
                completionHandler([.alert, .badge, .sound])
            }
        }
        else
        {
            completionHandler([.alert, .badge, .sound])
        }
        
        
        
        //completionHandler([.alert, .badge, .sound])
    }
    //Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let storyBoard = UIStoryboard.init(name: "Main", bundle:Bundle.main)
        
        print("Notification Data = \(userInfo)")
        
        if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
        {
            
            let dict = info["0"] as! NSDictionary
            //       print(dict.value(forKey: "notificationType"))
            //            if dict.value(forKey: "notificationType") as! String == "Addpost"
            //
            //            {
            //
            //                let tabObject = storyBoard.instantiateViewController(withIdentifier: "TaskDetailsViewController") as! not
            //
            //
            //                tabObject.PostId = dict.value(forKey: "post_id") as! String
            //                tabObject.boolValue = true
            //
            //                self.window?.rootViewController = tabObject
            //                self.window?.makeKeyAndVisible();
            //
            //}
            
            
            let noti_type = dict.value(forKey: "type") as? String
            
            
            
            
            
            if noti_type == "10" || noti_type == "11"
            {
                
                let vc = storyBoard.instantiateViewController(withIdentifier: "NaviRetailerNotiViewController") as! UINavigationController //NotificationTabViewController
                // let group_id = dict.value(forKey: "group_id") as? String ?? ""
                
                //  vc.group_id = group_id
                
                DEFAULT.set("FROMNOTI", forKey: "FROMNOTI")
                DEFAULT.synchronize()
                
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible();
                
            }
            else  if noti_type == "22"
            {
                
                let vc = storyBoard.instantiateViewController(withIdentifier: "NaviChatTabViewController") as! UINavigationController //NotificationTabViewController
                // let group_id = dict.value(forKey: "group_id") as? String ?? ""
                
                //  vc.group_id = group_id
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible();
                
            }
            else
            {
                
                let vc = storyBoard.instantiateViewController(withIdentifier: "NavigationNotificationTabViewController") as! UINavigationController //NotificationTabViewController
                // let group_id = dict.value(forKey: "group_id") as? String ?? ""
                
                //  vc.group_id = group_id
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible();
                
            }
            /*
             else if noti_type == "10"
             {
             let vc = storyBoard.instantiateViewController(withIdentifier: "RetailerDetailsTabViewController") as! RetailerDetailsTabViewController
             
             
             let owner_id = dict.value(forKey: "owner_id") as? String ?? ""
             
             vc.EventId = owner_id
             
             DEFAULT.set("\(owner_id)", forKey: "EVENTUSERID")
             self.window?.rootViewController = vc
             self.window?.makeKeyAndVisible();
             }
             else if noti_type == "13"
             {
             let vc = storyBoard.instantiateViewController(withIdentifier: "RetailerDetailsTabViewController") as! RetailerDetailsTabViewController
             
             
             let owner_id = dict.value(forKey: "owner_id") as? String ?? ""
             
             vc.EventId = owner_id
             
             DEFAULT.set("\(owner_id)", forKey: "EVENTUSERID")
             self.window?.rootViewController = vc
             self.window?.makeKeyAndVisible();
             }
             */
            
            
        }
        
        
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    //--MARK:--Get Token-----
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count
        {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("device token =  \(token)")
        
        UserDefaults.standard.setValue(token, forKey: "DEVICETOKEN")
        UserDefaults.standard.synchronize()
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Moocher")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
  
    
   
    
    
    func loadLoginView()
    {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "nav") as! UINavigationController
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    func loadHomeView()
    {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            }
            catch
            {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
extension AppDelegate:CLLocationManagerDelegate
{
    // MARK: CLLocation Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        manager.delegate = nil
        manager.stopUpdatingLocation()
        let location = locations.last
        let lat = (location?.coordinate.latitude)!
        let long = (location?.coordinate.longitude)!
                  CURRENTLOCATIONLONG=long
                CURRENTLOCATIONLAT=lat
        
        // showPartyMarkers(lat: lat, long: long)
    }
    
}

// MARK: UIApplication extensions

extension UIApplication {
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
