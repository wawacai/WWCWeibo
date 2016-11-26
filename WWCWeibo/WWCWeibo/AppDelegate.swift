//
//  AppDelegate.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/22.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
        setupRootVc()
        NotificationCenter.default.addObserver(self, selector: #selector(switchRootVc), name: NSNotification.Name(rawValue: MFSwitchRootVc), object: nil)
        window?.makeKeyAndVisible()
        
        return true
    }
    // 判断是否已经登录过，如果有则进入欢迎界面，如果没有则进入访客界面
    func setupRootVc() {
        if MFUserAccountViewModel.sharedTools.isLoagin {
            window?.rootViewController = MFWelcomeViewController()
        } else {
            window?.rootViewController = MFMainViewController()
        }
    }
    // 根据object来区分是从欢迎控制器来的还是访客界面来到
    func switchRootVc(noti: NSNotification) {
        if noti.object == nil {
            window?.rootViewController = MFWelcomeViewController()
            return
        }
        window?.rootViewController = MFMainViewController()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    }


}

