//
//  AppDelegate.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/19.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private lazy var rootController: UINavigationController = UINavigationController()
    private lazy var applicationCoordinator: ApplicationCoordinator = {
        return ApplicationCoordinator(router: RouterImpl(rootController: self.rootController), coordinatorFactory: CoordinatorFactoryImpl())
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = rootController
        applicationCoordinator.start()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        switch shortcutItem.type {
        case "item":
            applicationCoordinator.start(option: .item("dc2ff32fa2be6b78ea86"))
        case "tag":
            applicationCoordinator.start(option: .tag("iOS"))
        case "myAccount":
            applicationCoordinator.start(option: .myAccount)
        case _:
            return
        }
        
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

