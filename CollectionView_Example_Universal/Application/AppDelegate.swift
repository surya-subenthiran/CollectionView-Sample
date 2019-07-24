//
//  AppDelegate.swift
//  CollectionView_Example_Universal
//
//  Created by Surya Subendran on 21/07/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var rootController: UINavigationController {
        return self.window!.rootViewController as! UINavigationController
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        launchApp()
        return true
    }
    
    func launchApp() {
        let storyboard = UIStoryboard.main
        let damageAreaViewController = storyboard.instantiateViewController(withIdentifier: DamageAreaViewController.nameOfClass) as! DamageAreaViewController
        self.rootController.setViewControllers([damageAreaViewController], animated: false)
    }
}

