//
//  AppDelegate.swift
//  GyoelHap
//
//  Created by Terry Lee on 2020/12/21.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initializeRealm()
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
    
    
    private func initializeRealm() {
//        let realm = try! Realm()
        let realm = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
        guard realm.isEmpty else { return }
        try! realm.write{
            realm.add(StageRealm([15, 0, 13, 25, 5, 20, 2, 8, 10]))
            realm.add(StageRealm([15, 26, 17, 14, 5, 22, 16, 18, 10]))
            realm.add(StageRealm([2, 26, 5, 17, 24, 13, 25, 6, 11]))
            realm.add(StageRealm([7, 24, 1, 17, 22, 23, 21, 6, 25]))
            realm.add(StageRealm([22, 9, 2, 13, 25, 10, 5, 26, 17]))
            realm.add(StageRealm([9, 2, 25, 18, 15, 14, 7, 13, 22]))
        }
    }
}

