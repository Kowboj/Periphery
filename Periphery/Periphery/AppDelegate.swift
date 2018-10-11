//
//  AppDelegate.swift
//  Periphery
//
//  Created by NoGravity DEV on 11.10.2018.
//  Copyright © 2018 Kowboj. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window?.rootViewController = UINavigationController(rootViewController: CoordinatesViewController())
        window?.makeKeyAndVisible()
        
        return true
    }
}

