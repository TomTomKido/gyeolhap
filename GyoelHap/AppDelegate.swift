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
            realm.add(StageRealm([22, 16, 18, 3, 25, 12, 7, 14, 23]))
            realm.add(StageRealm([11, 19, 3, 5, 25, 18, 13, 4, 1]))
            realm.add(StageRealm([5, 8, 14, 20, 3, 2, 11, 4, 18]))
            realm.add(StageRealm([0, 1, 4, 3, 18, 9, 13, 25, 8]))
            realm.add(StageRealm([8, 17, 7, 2, 21, 18, 5, 16, 1]))
            realm.add(StageRealm([26, 7, 23, 15, 21, 22, 0, 14, 25]))
            realm.add(StageRealm([14, 17, 6, 12, 4, 0, 8, 1, 20]))
            realm.add(StageRealm([20, 26, 25, 9, 1, 16, 10, 21, 18]))
            realm.add(StageRealm([9, 10, 15, 25, 14, 22, 13, 24, 21]))
            realm.add(StageRealm([17, 10, 6, 24, 26, 11, 9, 21, 13]))
            realm.add(StageRealm([20, 3, 17, 24, 10, 23, 26, 12, 13]))
            realm.add(StageRealm([24, 1, 12, 21, 7, 2, 15, 19, 8]))
            realm.add(StageRealm([8, 14, 7, 10, 1, 0, 23, 17, 19]))
            realm.add(StageRealm([0, 15, 18, 11, 1, 20, 19, 21, 16]))
            realm.add(StageRealm([7, 3, 4, 12, 25, 15, 10, 5, 20]))
            realm.add(StageRealm([2, 5, 10, 13, 19, 9, 14, 8, 23]))
            realm.add(StageRealm([14, 15, 24, 18, 23, 2, 16, 1, 12]))
            realm.add(StageRealm([2, 21, 9, 25, 13, 16, 15, 26, 22]))
            realm.add(StageRealm([18, 1, 4, 24, 12, 21, 14, 17, 9]))
            realm.add(StageRealm([25, 7, 4, 12, 13, 19, 5, 6, 24]))
            realm.add(StageRealm([7, 20, 12, 4, 16, 19, 17, 24, 3]))
            realm.add(StageRealm([5, 26, 23, 25, 2, 7, 1, 22, 14]))
            realm.add(StageRealm([0, 18, 7, 6, 22, 16, 19, 24, 25]))
            realm.add(StageRealm([0, 25, 23, 24, 1, 18, 10, 19, 22]))
            realm.add(StageRealm([21, 18, 3, 6, 5, 24, 16, 22, 26]))
            realm.add(StageRealm([19, 17, 18, 23, 3, 1, 2, 25, 15]))
            realm.add(StageRealm([19, 8, 12, 11, 24, 10, 1, 9, 16]))
            realm.add(StageRealm([15, 8, 4, 6, 7, 2, 0, 26, 5]))
            realm.add(StageRealm([17, 23, 5, 21, 6, 8, 9, 15, 0]))
            realm.add(StageRealm([25, 0, 20, 15, 19, 7, 16, 4, 24]))
            realm.add(StageRealm([9, 1, 26, 17, 19, 10, 13, 2, 4]))
            realm.add(StageRealm([12, 10, 8, 26, 25, 5, 4, 16, 7]))
            realm.add(StageRealm([0, 9, 2, 19, 3, 24, 23, 10, 7]))
            realm.add(StageRealm([14, 21, 20, 19, 11, 26, 25, 0, 22]))
            realm.add(StageRealm([24, 11, 10, 3, 16, 6, 1, 8, 9]))
            realm.add(StageRealm([16, 15, 3, 6, 7, 18, 26, 8, 5]))
            realm.add(StageRealm([25, 8, 20, 23, 12, 9, 10, 1, 18]))
            realm.add(StageRealm([12, 24, 22, 21, 3, 8, 14, 25, 10]))
            realm.add(StageRealm([5, 13, 12, 14, 15, 11, 17, 7, 1]))
            realm.add(StageRealm([11, 7, 2, 19, 3, 6, 26, 22, 17]))
            realm.add(StageRealm([0, 7, 26, 16, 9, 8, 24, 6, 12]))
            realm.add(StageRealm([22, 13, 20, 10, 12, 18, 5, 1, 4]))
            realm.add(StageRealm([19, 20, 16, 9, 0, 12, 4, 8, 1]))
            realm.add(StageRealm([14, 6, 21, 15, 13, 5, 10, 22, 9]))
            realm.add(StageRealm([4, 13, 23, 5, 12, 16, 1, 0, 2]))
            realm.add(StageRealm([12, 23, 0, 2, 26, 10, 19, 22, 1]))
            realm.add(StageRealm([26, 0, 14, 9, 2, 12, 18, 13, 8]))
            realm.add(StageRealm([6, 10, 3, 5, 18, 13, 1, 12, 15]))
            realm.add(StageRealm([6, 5, 24, 11, 8, 15, 7, 3, 16]))
            realm.add(StageRealm([4, 14, 18, 2, 5, 1, 26, 21, 8]))
            realm.add(StageRealm([6, 18, 7, 11, 20, 4, 0, 2, 12]))
            realm.add(StageRealm([19, 16, 10, 5, 25, 7, 17, 12, 0]))
            realm.add(StageRealm([21, 18, 5, 15, 11, 6, 12, 3, 7]))
            realm.add(StageRealm([10, 4, 14, 18, 17, 13, 9, 5, 23]))
            realm.add(StageRealm([18, 1, 8, 19, 15, 17, 12, 22, 2]))
            realm.add(StageRealm([24, 8, 1, 7, 15, 9, 20, 25, 4]))
            realm.add(StageRealm([22, 24, 26, 9, 18, 8, 14, 6, 17]))
            realm.add(StageRealm([8, 4, 7, 21, 26, 11, 13, 3, 15]))
            realm.add(StageRealm([25, 16, 3, 24, 4, 14, 10, 26, 19]))
            realm.add(StageRealm([14, 9, 22, 1, 18, 4, 11, 13, 20]))
            realm.add(StageRealm([12, 5, 9, 18, 0, 11, 2, 19, 13]))
            realm.add(StageRealm([21, 4, 9, 20, 22, 0, 25, 11, 12]))
            realm.add(StageRealm([13, 16, 2, 10, 6, 19, 12, 17, 24]))
            realm.add(StageRealm([16, 22, 18, 3, 4, 19, 7, 25, 10]))
            realm.add(StageRealm([10, 23, 0, 18, 13, 12, 24, 22, 9]))
            realm.add(StageRealm([23, 15, 18, 13, 7, 26, 4, 11, 12]))
            realm.add(StageRealm([6, 17, 15, 11, 14, 2, 5, 9, 4]))
            realm.add(StageRealm([14, 2, 22, 5, 10, 0, 11, 26, 19]))
            realm.add(StageRealm([3, 18, 25, 16, 20, 10, 7, 13, 9]))
            realm.add(StageRealm([0, 17, 11, 15, 26, 25, 10, 2, 5]))
            realm.add(StageRealm([18, 11, 15, 24, 10, 19, 0, 26, 16]))
            realm.add(StageRealm([17, 20, 12, 7, 18, 16, 6, 19, 8]))
            realm.add(StageRealm([11, 12, 5, 15, 21, 4, 24, 3, 0]))
            realm.add(StageRealm([1, 24, 13, 10, 7, 8, 0, 25, 17]))
            realm.add(StageRealm([23, 19, 6, 5, 18, 4, 14, 21, 9]))
            realm.add(StageRealm([24, 21, 5, 6, 9, 7, 11, 1, 13]))
            realm.add(StageRealm([4, 3, 22, 9, 0, 16, 5, 1, 13]))
            realm.add(StageRealm([11, 10, 13, 2, 24, 8, 22, 20, 26]))
            realm.add(StageRealm([0, 16, 11, 15, 13, 12, 2, 14, 6]))
            realm.add(StageRealm([8, 25, 14, 9, 26, 0, 22, 3, 18]))
            realm.add(StageRealm([13, 16, 24, 8, 25, 26, 23, 9, 17]))
            realm.add(StageRealm([1, 21, 10, 19, 2, 22, 24, 20, 15]))
            realm.add(StageRealm([1, 3, 12, 19, 16, 5, 24, 9, 8]))
            realm.add(StageRealm([24, 0, 19, 5, 16, 21, 10, 23, 17]))
            realm.add(StageRealm([22, 2, 25, 14, 13, 23, 16, 11, 21]))
            realm.add(StageRealm([26, 17, 3, 1, 7, 11, 2, 23, 10]))
            realm.add(StageRealm([15, 12, 26, 7, 16, 5, 10, 2, 13]))
            realm.add(StageRealm([16, 1, 11, 17, 15, 20, 24, 7, 12]))
            realm.add(StageRealm([5, 8, 23, 19, 7, 14, 2, 6, 16]))
            realm.add(StageRealm([22, 1, 25, 3, 21, 10, 26, 16, 5]))
            realm.add(StageRealm([0, 14, 10, 12, 6, 4, 13, 22, 21]))
            realm.add(StageRealm([14, 24, 18, 17, 7, 5, 9, 12, 23]))
            realm.add(StageRealm([25, 12, 1, 17, 0, 18, 20, 11, 22]))
            realm.add(StageRealm([17, 0, 25, 23, 16, 1, 10, 7, 4]))

        }
    }
}

