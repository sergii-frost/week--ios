//
//  DateTools.swift
//  weeknum
//
//  Created by Sergii Nezdolii on 02/07/16.
//  Copyright © 2016 FrostDigital. All rights reserved.
//

import Foundation

enum WeekDays: Int {
    case Sunday = 1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
    
    var name: String {
        switch self {
        case .Monday:       return "Mon".localized
        case .Tuesday:      return "Tue".localized
        case .Wednesday:    return "Wed".localized
        case .Thursday:     return "Thu".localized
        case .Friday:       return "Fri".localized
        case .Saturday:     return "Sat".localized
        case .Sunday:       return "Sun".localized
        }
    }
}

extension NSDate {
    func dayOfWeek() -> Int? {
        guard
            let cal: NSCalendar = NSCalendar.currentCalendar(),
            let comp: NSDateComponents = cal.components(.Weekday, fromDate: self)
            else { return nil }
        
        return comp.weekday
    }
    
    func weekNumber() -> Int? {
        guard
            let cal: NSCalendar = NSCalendar(identifier: NSCalendarIdentifierISO8601),
            let comp: NSDateComponents = cal.components(.WeekOfYear, fromDate: self)
            else { return nil }
        
        return comp.weekOfYear
    }
    
    func formatted(dateFormat: String = "dd MMM yyyy") -> String {
        let df = NSDateFormatter()
        df.locale = NSLocale.currentLocale()
        df.dateFormat = dateFormat
        return df.stringFromDate(self)
    }
}