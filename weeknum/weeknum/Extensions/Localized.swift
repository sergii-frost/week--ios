//
//  Localized.swift
//  weeknum
//
//  Created by Sergii Nezdolii on 02/07/16.
//  Copyright © 2016 FrostDigital. All rights reserved.
//

import Foundation

public extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

public extension NSString {
    var localized: NSString {
        return NSLocalizedString(self as String, tableName: nil, bundle: Bundle.main, value: "", comment: "") as NSString
    }
}
