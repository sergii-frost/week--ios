//
//  ComplicationController.swift
//  watchWeeknum Extension
//
//  Created by Sergii Nezdolii on 02/07/16.
//  Copyright © 2016 FrostDigital. All rights reserved.
//

import ClockKit

let kWeekNumLong = "Week#"
let kWeekNumShort = "W#"

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date().lastWeekStart())
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date().nextWeekStart()?.nextWeekStart())
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: (@escaping (CLKComplicationTimelineEntry?) -> Void)) {
        switch complication.family {
        case .modularSmall, .circularSmall, .utilitarianSmall:
            handler(getTimelineEntryFor(complication, date: Date()))
            break
        default:
            handler(nil)
            break
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: (@escaping ([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        var entries = [CLKComplicationTimelineEntry]()
        switch complication.family {
        case .modularSmall, .circularSmall, .utilitarianSmall:
            var targetDate = date.thisWeekStart()
            while targetDate != nil && entries.count < limit {
                entries.append(getTimelineEntryFor(complication, date: targetDate))
                targetDate = targetDate?.lastWeekStart()
            }
            handler(entries)
            break
        default:
            handler(nil)
            break
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: (@escaping ([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        var entries = [CLKComplicationTimelineEntry]()
        switch complication.family {
        case .modularSmall, .circularSmall, .utilitarianSmall:
            var targetDate = date.nextWeekStart()
            while targetDate != nil && entries.count < limit {
                entries.append(getTimelineEntryFor(complication, date: targetDate))
                targetDate = targetDate?.nextWeekStart()
            }
            handler(entries)
            break
        default:
            handler(nil)
            break
        }
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDate(handler: @escaping (Date?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(Date().nextWeekStart());
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        switch complication.family {
        case .modularSmall:
            handler(getTemplateForModularSmall(Date()))
            break
        case .circularSmall:
            handler(getTemplateForCircularSmall(Date()))
            break
        case .utilitarianSmall:
            handler(getTemplateForUtilitarianSmall(Date()))
        default:
            handler(nil)
            break
        }
    }
    
    //MARK: - Private Template methods
    
    fileprivate func getTemplateForModularSmall(_ date: Date!) -> CLKComplicationTemplate? {
        guard let weekNumber = date.weekNumber() else {
            return nil
        }

        let template = CLKComplicationTemplateModularSmallStackText()
        template.line1TextProvider = CLKSimpleTextProvider.init(text: kWeekNumLong, shortText: kWeekNumShort)
        template.line2TextProvider = CLKSimpleTextProvider.init(text: String(weekNumber))
        template.highlightLine2 = true
        return template
    }
    
    fileprivate func getTemplateForCircularSmall(_ date: Date) -> CLKComplicationTemplate? {
        guard let weekNumber = date.weekNumber() else {
            return nil
        }
        
        let template = CLKComplicationTemplateCircularSmallStackText()
        template.line1TextProvider = CLKSimpleTextProvider.init(text: kWeekNumLong, shortText: kWeekNumShort)
        template.line2TextProvider = CLKSimpleTextProvider.init(text: String(weekNumber))
        return template
    }
    
    fileprivate func getTemplateForUtilitarianSmall(_ date: Date) -> CLKComplicationTemplate? {
        guard let weekNumber = date.weekNumber() else {
            return nil
        }
        
        let template = CLKComplicationTemplateUtilitarianSmallFlat()
        template.textProvider = CLKSimpleTextProvider.init(text: "\(kWeekNumShort) \(weekNumber)", shortText: String(weekNumber))
        return template
    }
    
    //MARK: - Private Timeline Entry methods
    
    fileprivate func getTimelineEntryFor(_ complication: CLKComplication!, date: Date!) -> CLKComplicationTimelineEntry {
        let timelineEntry = CLKComplicationTimelineEntry()
        timelineEntry.date = date
        var template: CLKComplicationTemplate?
        switch complication.family {
        case .modularSmall:
            template = getTemplateForModularSmall(date)
            break
        case .circularSmall:
            template = getTemplateForCircularSmall(date)
            break
        case .utilitarianSmall:
            template = getTemplateForUtilitarianSmall(date)
            break
        default:
            break
        }
        if let template = template {
            timelineEntry.complicationTemplate = template
        }
        return timelineEntry
    }
}
