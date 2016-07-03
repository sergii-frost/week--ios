//
//  FormatterUtils.swift
//  weeknum
//
//  Created by Sergii Nezdolii on 03/07/16.
//  Copyright © 2016 FrostDigital. All rights reserved.
//

import Foundation

class FormatterUtils {
    static let kDateFormat = "EEE, dd MMM yyyy"
    static let kShortDateFormat = "dd MMM"
    
    private static func dateFormatter(dateFormat: String) -> NSDateFormatter {
        let df = NSDateFormatter()
        df.locale = NSLocale.currentLocale()
        df.dateFormat = dateFormat
        return df
    }
    
    static func formattedDate(date: NSDate?, dateFormat: String = kDateFormat) -> String? {
        guard let date = date else {return nil}
        return dateFormatter(dateFormat).stringFromDate(date)
    }
    
    static func getWeekInfo(date: NSDate?, shortDateFormat: String = kShortDateFormat) -> String? {
        guard
            let date = date,
            let weekStart = formattedDate(date.thisWeekStart(), dateFormat: shortDateFormat),
            let weekEnd = formattedDate(date.nextWeekStart()?.dayBefore(), dateFormat: shortDateFormat)
        else {return nil}
        
        return "\(weekStart) - \(weekEnd)"
    }
}
