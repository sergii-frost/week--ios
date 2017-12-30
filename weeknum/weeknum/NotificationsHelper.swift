//
//  NotificationsHelper.swift
//  Week#
//
//  Created by Sergii Frost on 2017-12-30.
//  Copyright © 2017 FrostDigital. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsHelper {
    
    private init() {
        //Avoid public instantiation
    }
    
    static func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                askForNotificationAuthorization()
            case .authorized:
                scheduleBadgeUpdateNotifications()
            case .denied:
                clearScheduledNotifications()
            }
        }
    }
    
    /// If user has not allowed/denied Push yet, there will be no app in iOS Settings yet.
    /// That is why additional check is needed.
    /// In case if user has not yet determined if to allow or not, we will show same alert again.
    /// Otherwise navigate to Settings
    static func handleAppSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                askForNotificationAuthorization(forceAsk: true)
            } else {
                openAppSettings()
            }
        }
    }
    
    fileprivate static func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
    }
    
    fileprivate static func askForNotificationAuthorization(forceAsk: Bool = false) {
        if SettingsUtils.wasBadgeNotificationAuthorizationPrompted() && !forceAsk {
            return //No need to annoy user with same prompt if it was asked before
        }
        let alertController = UIAlertController(
            title: "Alert.Push.Authorization.Title".localized,
            message: "Alert.Push.Authorization.Message".localized, preferredStyle: .alert)
        alertController.view.tintColor = UIColor.weekNumMainColor()
        alertController.addAction(UIAlertAction(title: "Alert.Push.Authorization.Button.Negative".localized, style: .cancel, handler: { _ in
            SettingsUtils.markBadgeNotificationAuthorizationAsPrompted()
        }))
        alertController.addAction(UIAlertAction(title: "Alert.Push.Authorization.Button.Positive".localized, style: .default, handler: { _ in
            SettingsUtils.markBadgeNotificationAuthorizationAsPrompted()
            requestBadgeAuthorization()
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate static func requestBadgeAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { (granted: Bool, error: Error?) in
            if let error = error {
                print("Error when requesting authorization for badge: \(error.localizedDescription)")
            }
            if granted {
                scheduleBadgeUpdateNotifications()
            }
        }
    }
    
    
    /// This function allows to schedule recurring silent local notifications
    /// in order to update badge number on app icon.
    /// There are limitations from Apple side for amount of local notifications
    /// scheduled from one app - up to 64. Recurring notification is counted as one.
    /// But it should be OK in our case as we have max 53 weeks in the year.
    /// So current function will shedule 53 recurring notifications, one for each week.
    fileprivate static func scheduleBadgeUpdateNotifications() {
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
    
    fileprivate static func clearScheduledNotifications() {
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.removeAllDeliveredNotifications()
        userNotificationCenter.removeAllPendingNotificationRequests()
    }
}
