//
//  InterfaceController.swift
//  watchWeeknum Extension
//
//  Created by Sergii Nezdolii on 02/07/16.
//  Copyright © 2016 FrostDigital. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var dateDetailsLabel: WKInterfaceLabel!
    @IBOutlet var weekDayLabel: WKInterfaceLabel!
    @IBOutlet var weekNumberLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        updateForToday()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    private func updateUIWithDate(date: NSDate) {
        self.dateDetailsLabel.setText(date.formatted())
        if let dayOfWeek = date.dayOfWeek(), let dayWithName = WeekDays(rawValue: dayOfWeek) {
            self.weekDayLabel.setText(dayWithName.name)
        } else {
            self.weekDayLabel.setText(nil)
        }
        if let weekNumber = date.weekNumber() {
            self.weekNumberLabel.setText(String(weekNumber))
        } else {
            self.weekNumberLabel.setText(nil)
        }
    }

    @IBAction func updateForToday() {
        updateUIWithDate(NSDate())
    }
}
