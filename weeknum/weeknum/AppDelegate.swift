//
//  AppDelegate.swift
//  weeknum
//
//  Created by Sergii Nezdolii on 02/07/16.
//  Copyright © 2016 FrostDigital. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        updateAppBadge(application)
        checkNotificationStatus()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

//MARK: - Local notifications and badge update
extension AppDelegate {
    
    //MARK: - Helper methods
    
    fileprivate func updateAppBadge(_ application: UIApplication) {
        guard let weekNumber = Date().weekNumber() else {
            return
        }
        application.applicationIconBadgeNumber = weekNumber
    }
    
    fileprivate func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.askForNotificationAuthorization()
            case .authorized:
                self.scheduleBadgeUpdateNotifications()
            case .denied:
                self.clearScheduledNotifications()
            }
        }
    }
    
    fileprivate func askForNotificationAuthorization() {
        let alertController = UIAlertController(
            title: "Wanna badge?",
            message: "Hey, do you want to see current week # as badge on the app icon? \nI need you to allow app to do that :) \nPS: You can always change it in Settings", preferredStyle: .alert)
        alertController.view.tintColor = UIColor.weekNumMainColor()
        alertController.addAction(UIAlertAction(title: "Nah", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yeah, sure!", style: .default, handler: { [weak self] _ in
            self?.requestBadgeAuthorization()
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func requestBadgeAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { (granted: Bool, error: Error?) in
            if let error = error {
                print("Error when requesting authorization for badge: \(error.localizedDescription)")
            }
            if granted {
                self.scheduleBadgeUpdateNotifications()
            }
        }
    }
    
    
    /// This function allows to schedule recurring silent local notifications
    /// in order to update badge number on app icon.
    /// There are limitations from Apple side for amount of local notifications
    /// scheduled from one app - up to 64. Recurring notification is counted as one.
    /// But it should be OK in our case as we have max 53 weeks in the year.
    /// So current function will shedule 53 recurring notifications, one for each week. 
    fileprivate func scheduleBadgeUpdateNotifications() {
        clearScheduledNotifications()
        guard let weeksRange = Date().weeksRangeInYear() else {
            return
        }
        for week in weeksRange {
            var dateComponents = DateComponents()
            dateComponents.weekOfYear = week
            dateComponents.weekday = Calendar.current.firstWeekday
            dateComponents.hour = 0
            dateComponents.minute = 0
            dateComponents.second = 0
            let content = UNMutableNotificationContent()
            content.badge = NSNumber(value: week)
            UNUserNotificationCenter.current().add(
            UNNotificationRequest(
                identifier: "Week# \(week)",
                content: content,
                trigger: UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            )) { error in
                if let error = error {
                    print("Error scheduling local notification: \(error.localizedDescription)")
                }
            }
        }
    }
    
    fileprivate func clearScheduledNotifications() {
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.removeAllDeliveredNotifications()
        userNotificationCenter.removeAllPendingNotificationRequests()
    }
}
