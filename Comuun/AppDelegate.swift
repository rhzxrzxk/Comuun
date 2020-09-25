//
//  AppDelegate.swift
//  Comuun
//
//  Created by 田中尊 on 2018/05/28.
//  Copyright © 2018年 田中尊. All rights reserved.
//

import UIKit
import LineSDK
import FBSDKCoreKit



//UserDefaultsを使ってフラグを保持する
let userDefault = UserDefaults.standard
//"firstLaunch"をキーに、Bool型の値を保持する
let dictionary = [
    "beforeLoginLaunch": true,
//    "profileName": "",
//    "sampleFileName": ""
    ] as [String : Any]



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var settingNavigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //デフォルト値登録（すでに値が更新されていた場合は、更新後の値のままになる）
        userDefault.register(defaults: dictionary)
        //ログイン前の場合の処理
        if userDefault.bool(forKey: "beforeLoginLaunch") {
            //画面遷移
            let first: LoginUIViewController = LoginUIViewController()
            settingNavigationController = UINavigationController(rootViewController: first)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = settingNavigationController
            self.window?.makeKeyAndVisible()
            FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
            return true
        } else {
            //ログインした後の処理
            if UserDefaults.standard.object(forKey: "profileName") != nil {
                profileName = UserDefaults.standard.object(forKey: "profileName") as? String
                profileId = UserDefaults.standard.object(forKey: "profileId") as? String
            }
            let path = UserDefaults.standard.url(forKey: "filePath")
            let path2 = UserDefaults.standard.url(forKey: "filePath2")
            let path3 = UserDefaults.standard.url(forKey: "filePath3")
            if path != nil && path2 != nil && path3 != nil {
                let path = path?.path
                let path2 = path2?.path
                let path3 = path3?.path
                let image = UIImage(contentsOfFile: path!)
                let imageView = UIImageView(image: image)
                let image2 = UIImage(contentsOfFile: path2!)
                let imageView2 = UIImageView(image: image2)
                let image3 = UIImage(contentsOfFile: path3!)
                let imageView3 = UIImageView(image: image3)
                basicProfileImageView = imageView
                expandedProfileImageView = imageView2
                acountProfileImageView = imageView3
                
            } else {
                print("指定されたファイルが見つかりません")
            }
            //画面遷移
            let first: SettingUIViewController = SettingUIViewController()
            settingNavigationController = UINavigationController(rootViewController: first)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = settingNavigationController
            self.window?.makeKeyAndVisible()
            FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
            return true
        }
    }
    
    //MARK: - for Line
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return LineSDKLogin.sharedInstance().handleOpen(url)
    }
    
    //MARK: - for Facebook
    func application(_ application: UIApplication,open url: URL,sourceApplication: String?,annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
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
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
