//
//  SettingsUtils.swift
//  Week#
//
//  Created by Sergii Frost on 2017-12-30.
//  Copyright © 2017 FrostDigital. All rights reserved.
//

import Foundation

class SettingsUtils {
    
    fileprivate static let kBadgeNotificationAuthorizationWasPromptedKey = "BadgeNotificationAuthorizationWasPromptedKey"
    
    private init() {
        //Avoid public instantitation
    }
    
    static func wasBadgeNotificationAuthorizationPrompted() -> Bool {
        guard let _ = UserDefaults.standard.object(forKey: kBadgeNotificationAuthorizationWasPromptedKey) else {
            return false
        }
        
        return UserDefaults.standard.bool(forKey: kBadgeNotificationAuthorizationWasPromptedKey)
    }
    
    static func markBadgeNotificationAuthorizationAsPrompted() {
        UserDefaults.standard.set(true, forKey: kBadgeNotificationAuthorizationWasPromptedKey)
    }
}
