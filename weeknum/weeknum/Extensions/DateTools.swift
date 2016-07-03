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
    
    var weekProgress: Float {
        return Float(self.rawValue-1) / 7.0
    }
}

let DAY: NSTimeInterval = 60*60*24
let DAYS_IN_WEEK: Int = 7
let WEEK: NSTimeInterval = DAY*NSTimeInterval(DAYS_IN_WEEK)

extension NSDate {
    
    private func startOfDay() -> NSDate? {
        guard
            let cal: NSCalendar = NSCalendar.currentCalendar()
            else { return nil }
        
        cal.timeZone = NSTimeZone.systemTimeZone()
        return cal.startOfDayForDate(self)
    }

    //MARK: - Day of Week, Week Number
    
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
    
    //MARK: - Day(s) before/after
    
    func daysBefore(days: Int) -> NSDate? {
        guard let startOfDay = self.startOfDay() else { return nil }
        return startOfDay.dateByAddingTimeInterval(-DAY*NSTimeInterval(days))
    }
    
    func dayBefore() -> NSDate? {
        return daysBefore(1)
    }
    
    func daysAfter(days: Int) -> NSDate? {
        guard let startOfDay = self.startOfDay() else { return nil }
        return startOfDay.dateByAddingTimeInterval(DAY*NSTimeInterval(days))
    }
    
    func dayAfter() -> NSDate? {
        return daysAfter(1)
    }
    
    func weekBefore() -> NSDate? {
        return daysBefore(DAYS_IN_WEEK)
    }
    
    func weekAfter() -> NSDate? {
        return daysAfter(DAYS_IN_WEEK)
    }
    
    //MARK: - last/this/next week start dates logics
    
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