//
//  DateTools.swift
//  weeknum
//
//  Created by Sergii Nezdolii on 02/07/16.
//  Copyright © 2016 FrostDigital. All rights reserved.
//

import Foundation

enum WeekDays: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    
    var name: String {
        switch self {
        case .monday:       return "Mon".localized
        case .tuesday:      return "Tue".localized
        case .wednesday:    return "Wed".localized
        case .thursday:     return "Thu".localized
        case .friday:       return "Fri".localized
        case .saturday:     return "Sat".localized
        case .sunday:       return "Sun".localized
        }
    }
    
    var daysLeftTillNextWeek: Int {
        switch self {
        case .monday:   return 7
        case .tuesday:  return 6
        case .wednesday:return 5
        case .thursday: return 4
        case .friday:   return 3
        case .saturday: return 2
        case .sunday:   return 1
        }
    }
    
    var weekProgress: Float {
        return Float(self.rawValue-1) / 7.0
    }
}

let DAYS_IN_WEEK: Int = 7

extension Date {
    
    fileprivate func startOfDay() -> Date? {
        var cal: Calendar = Calendar.current
        cal.timeZone = TimeZone.current
        return cal.startOfDay(for: self)
    }

    //MARK: - Day of Week, Week Number
    
    func dayOfWeek() -> Int? {
        let comp: DateComponents = Calendar.current.dateComponents([.weekday], from: self)
        
        return comp.weekday
    }
    
    func weekNumber() -> Int? {
        let cal: Calendar = Calendar(identifier: Calendar.Identifier.iso8601)
        let comp: DateComponents = cal.dateComponents([.weekOfYear], from: self)
        
        return comp.weekOfYear
    }
    
    func weeksRangeInYear() -> [Int]? {
        let calendar = Calendar(identifier: Calendar.Identifier.iso8601)
        let weekRange = (calendar as NSCalendar).range(of: .weekOfYear, in: .year, for: self)
        return Array(weekRange.location..<weekRange.location + weekRange.length)
    }
    
    //MARK: - Day(s) before/after
    
    func daysBefore(_ days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: -days, to: self)?.startOfDay()
    }
    
    func dayBefore() -> Date? {
        return daysBefore(1)
    }
    
    func daysAfter(_ days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: self)?.startOfDay()
    }
    
    func dayAfter() -> Date? {
        return daysAfter(1)
    }
    
    func weekBefore() -> Date? {
        return daysBefore(DAYS_IN_WEEK)
    }
    
    func weekAfter() -> Date? {
        return daysAfter(DAYS_IN_WEEK)
    }
    
    //MARK: - last/this/next week start dates logics
    
    func thisWeekStart() -> Date? {
        let cal: Calendar = Calendar.current
        let comp: DateComponents = cal.dateComponents([.weekday], from: self)
        
        guard let componentWeekday = comp.weekday, let weekday = WeekDays(rawValue: componentWeekday) else {
            return nil
        }
        return cal.date(byAdding: .day, value: weekday.daysLeftTillNextWeek - DAYS_IN_WEEK, to: self)
    }
    
    func weekStart(byAddingWeeks weeks: Int) -> Date? {
        guard let thisWeekStart = self.thisWeekStart() else {
            return nil
        }
        return Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: thisWeekStart)
    }
    
    func nextWeekStart() -> Date? {
        return weekStart(byAddingWeeks: 1)
    }
    
    func lastWeekStart() -> Date? {
        return weekStart(byAddingWeeks: -1)
    }
    
    func startForWeek(_ week: Int?) -> Date? {
        guard let thisWeekStart = self.thisWeekStart() else { return nil }
        let cal: Calendar = Calendar(identifier: Calendar.Identifier.iso8601)
        var comp: DateComponents = cal.dateComponents([.weekday, .weekOfYear, .year], from: thisWeekStart)

        guard let week = week, let last = self.weeksRangeInYear()?.last else {
            return nil
        }
        if week > last {
            return nil
        }
        comp.weekOfYear = week
        return cal.date(from: comp)
    }
}
