//
//  AppDelegate.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 14.09.17.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import UIKit
import RealmSwift



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var utils = Utils()
    
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Вфзов обновления данных в фоне \(Date())")
        if utils.lastUpdate != nil, abs(utils.lastUpdate!.timeIntervalSinceNow) < 30 {
            print ("Фоновое обновление не требуется, т.к. крайний раз данные обновлялись \(abs(utils.lastUpdate!.timeIntervalSinceNow)) секунд назад (меньше 30)")
            completionHandler(.noData)
            return
        }
        
        utils.timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        utils.timer?.scheduleRepeating(deadline: .now(), interval: .seconds(29), leeway: .seconds(1))
        utils.timer?.setEventHandler{ [weak self] in
            print("Говорим системе что не смогли зпгрузить данные")
            completionHandler(.failed)
            return
        }
        
        utils.timer?.resume()
        let newsService = VKNewsFeed()
        let group = newsService.groups
        
        
        utils.fetchCitiesWeatherGroup.notify(queue: DispatchQueue.main){
            print("Все данные загружены в фоне")
            self.utils.timer = nil
            self.utils.lastUpdate = Date()
            completionHandler(.newData)
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
    
    /*func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        VKSdk.processOpen(url, fromApplication: options[UIApplicationOpenURLOptionsKey])
    }*/
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

        return true
    }


}

