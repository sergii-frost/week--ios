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
    
    var daysLeftTillNextWeek: Double {
        switch self {
        case .Monday:   return 7
        case .Tuesday:  return 6
        case .Wednesday:return 5
        case .Thursday: return 4
        case .Friday:   return 3
        case .Saturday: return 2
        case .Sunday:   return 1
        }
    }
}

let DAY: NSTimeInterval = 60*60*24
let WEEK: NSTimeInterval = DAY*7

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
    
    private func startOfDay() -> NSDate? {
        guard
            let cal: NSCalendar = NSCalendar.currentCalendar()
            else { return nil }
        
        cal.timeZone = NSTimeZone.systemTimeZone()
        return cal.startOfDayForDate(self)
    }
    
    func dayBefore() -> NSDate? {
        guard let startOfDay = self.startOfDay() else { return nil }
        return startOfDay.dateByAddingTimeInterval(-DAY)
    }

    
    func dayeAfter() -> NSDate? {
        guard let startOfDay = self.startOfDay() else { return nil }
        return startOfDay.dateByAddingTimeInterval(DAY)
    }
    
    func nextWeekStart() -> NSDate? {
        guard
            let cal: NSCalendar = NSCalendar.currentCalendar(),
            let comp: NSDateComponents = cal.components(.Weekday, fromDate: self)
            else { return nil }
        
        let startOfDay = cal.startOfDayForDate(self)
        guard let weekday = WeekDays(rawValue: comp.weekday) else {
            return nil
        }
        return startOfDay.dateByAddingTimeInterval(DAY*weekday.daysLeftTillNextWeek)
        
    }
    
    func thisWeekStart() -> NSDate? {
        guard
            let cal: NSCalendar = NSCalendar.currentCalendar(),
            let comp: NSDateComponents = cal.components(.Weekday, fromDate: self)
            else { return nil }
        
        let startOfDay = cal.startOfDayForDate(self)
        guard let weekday = WeekDays(rawValue: comp.weekday) else {
            return nil
        }
        return startOfDay.dateByAddingTimeInterval(DAY*(weekday.daysLeftTillNextWeek-7))
    }
    
    func lastWeekStart() -> NSDate? {
        guard let thisWeekStart = self.thisWeekStart() else {
            return nil
        }
        return thisWeekStart.dateByAddingTimeInterval(-WEEK)
    }
}