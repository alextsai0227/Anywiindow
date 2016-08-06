//
//  AppDelegate.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/6/29.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import Alamofire
import SwiftyJSON
import AVKit
import AVFoundation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application,
                                                              didFinishLaunchingWithOptions: launchOptions)
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if user == nil {
                // User isnot signed in.
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("WelcomCollectionViewController")
                application.windows.first?.rootViewController = loginViewController
            }else{
                print("user是誰\(user)")

            }
        }
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().translucent = true
        return true
    }
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        
        let localNotification = UILocalNotification()
        let now = NSDate()
        let notiDate = now.dateByAddingTimeInterval(0)
        localNotification.fireDate = notiDate
        localNotification.alertBody = "工作時間到了，跟著任意窗一起去休息吧"
        localNotification.soundName =
        UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
            //Read movie URL
            let avPlayerViewController = AVPlayerViewController()
            var avMoviePlayer: AVPlayer?
            let movieUrl:NSURL? = NSURL(string: "http://techslides.com/demos/sample-videos/small.mp4")
            if let url = movieUrl{
                avMoviePlayer = AVPlayer(URL: url)
                avPlayerViewController.player = avMoviePlayer
            }
//            let stroyBoard = UIStoryboard(name: "Main", bundle: nil)
//            let breakViewController = stroyBoard.instantiateViewControllerWithIdentifier("BreakViewController") as! BreakViewController
//            let viewController = stroyBoard.instantiateViewControllerWithIdentifier("ViewController") as!
//                ViewController
//        let mapviewController = stroyBoard.instantiateViewControllerWithIdentifier("MapViewController") as!
//        MapViewController
//            application.windows.first?.rootViewController = mapviewController
//            viewController.presentViewController(breakViewController, animated: false, completion: nil)
    }
    func application(application:UIApplication,openURL url: NSURL, sourceApplication:String?, annotation:AnyObject) -> Bool{
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        return handled
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()

    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print(deviceToken)
        
        NSUserDefaults.standardUserDefaults().setValue("\(deviceToken)", forKey: "UserPushToken")
        print("deviceToken\(deviceToken)")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

}

