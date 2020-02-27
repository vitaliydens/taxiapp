//
//  AppDelegate.swift
//  TaxiApp
//
//  Created by Developer on 25.02.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyDM6Zh39pShzr7JlTmiQ9MUtXzR6Yn489s")
//        GMSPlacesClient.provideAPIKey("AIzaSyDM6Zh39pShzr7JlTmiQ9MUtXzR6Yn489s")
        return true
    }
}

