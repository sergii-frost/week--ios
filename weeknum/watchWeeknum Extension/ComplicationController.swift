//
//  ComplicationController.swift
//  watchWeeknum Extension
//
//  Created by Sergii Nezdolii on 02/07/16.
//  Copyright © 2016 FrostDigital. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.Forward, .Backward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate().lastWeekStart())
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate().nextWeekStart()?.nextWeekStart())
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        switch complication.family {
        case .ModularSmall:
            handler(getTimelineEntryForModularSmall(NSDate()))
            break
        default:
            handler(nil)
            break
        }
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        var entries = [CLKComplicationTimelineEntry]()
        switch complication.family {
        case .ModularSmall:
            var targetDate = date.thisWeekStart()
            while targetDate != nil && entries.count < limit {
                entries.append(getTimelineEntryForModularSmall(targetDate))
                targetDate = targetDate?.lastWeekStart()
            }
            handler(entries)
            break
        default:
            handler(nil)
            break
        }
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        var entries = [CLKComplicationTimelineEntry]()
        switch complication.family {
        case .ModularSmall:
            var targetDate = date.nextWeekStart()
            while targetDate != nil && entries.count < limit {
                entries.append(getTimelineEntryForModularSmall(targetDate))
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
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(NSDate().nextWeekStart());
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        switch complication.family {
        case .ModularSmall:
            handler(getTemplateForModularSmall(NSDate()))
            break
        default:
            handler(nil)
            break
        }
    }
    
    //MARK: - Private Template methods
    
    private func getTemplateForModularSmall(date: NSDate!) -> CLKComplicationTemplate? {
        guard let weekNumber = date.weekNumber() else {
            return nil
        }

        let template = CLKComplicationTemplateModularSmallStackText()
        template.line1TextProvider = CLKSimpleTextProvider.init(text: "Week#", shortText: "W#")
        template.line2TextProvider = CLKSimpleTextProvider.init(text: String(weekNumber))
        template.highlightLine2 = true
        return template
    }
    
    private func getTimelineEntryForModularSmall(date: NSDate!) -> CLKComplicationTimelineEntry {
        let timelineEntry = CLKComplicationTimelineEntry()
        timelineEntry.date = date
        if let template = getTemplateForModularSmall(date) {
            timelineEntry.complicationTemplate = template
        }
        return timelineEntry
    }
    
    private func getTemplateForUtilitarianSmall(date: NSDate) -> CLKComplicationTemplate? {
        guard let weekNumber = date.weekNumber() else {
            return nil
        }
        
        let template = CLKComplicationTemplateUtilitarianSmallFlat()
        template.textProvider = CLKSimpleTextProvider.init(text: String(weekNumber))
        return template
    }

}
