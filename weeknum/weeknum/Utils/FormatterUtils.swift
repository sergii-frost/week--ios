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
    
    fileprivate static func dateFormatter(_ dateFormat: String) -> DateFormatter {
        let df = DateFormatter()
        df.locale = Locale.current
        df.dateFormat = dateFormat
        return df
    }
    
    static func formattedDate(_ date: Date?, dateFormat: String = kDateFormat) -> String? {
        guard let date = date else {return nil}
        return dateFormatter(dateFormat).string(from: date)
    }
    
    static func dateFromString(_ string: String, dateFormat: String) -> Date? {
        return dateFormatter(dateFormat).date(from: string)
    }
    
    static func getWeekInfo(_ date: Date?, shortDateFormat: String = kShortDateFormat) -> String? {
        guard
            let date = date,
            let weekStart = formattedDate(date.thisWeekStart(), dateFormat: shortDateFormat),
            let weekEnd = formattedDate(date.nextWeekStart()?.dayBefore(), dateFormat: shortDateFormat)
        else {return nil}
        
        return "\(weekStart) - \(weekEnd)"
    }
}
