//
//  AppDelegate.swift
//  Weather
//
//  Created by Amr Fawaz on 1/7/20.
//  Copyright © 2020 amrfawaz. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let realm = try! Realm()
        
        let cities = realm.objects(CityRealm.self)
        if cities.count == 0 {
            _ = loadJson(fileName: "cities")
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    
    func loadJson(fileName: String) -> [CityRealm]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            let realm = try! Realm()
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let cities = try decoder.decode([CityRealm].self, from: data)
                try! realm.write {
                    realm.add(cities)
                }
                return cities
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }


}

