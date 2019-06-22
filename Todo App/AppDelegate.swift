//
//  AppDelegate.swift
//  Todo App
//
//  Created by Osama Fahim on 18/06/2019.
//  Copyright © 2019 Osama Fahim. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
       // print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        do{
            _ = try Realm()
        }
        catch{
            print("Error in relam \(error)")
        }
        
        
        return true
    }
    
}
