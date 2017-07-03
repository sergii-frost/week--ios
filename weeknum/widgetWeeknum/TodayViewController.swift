//
//  TodayViewController.swift
//  widgetWeeknum
//
//  Created by Sergii Frost on 2017-07-03.
//  Copyright © 2017 FrostDigital. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var weekInfoLabel: UILabel?
    @IBOutlet weak var weekNumberLabel: UILabel?
    
    private var selectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        extensionContext?.widgetLargestAvailableDisplayMode = .compact
        self.weekInfoLabel?.text = nil
        self.weekNumberLabel?.text = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateForToday()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        updateForToday()
        completionHandler(NCUpdateResult.newData)
    }
    
    @IBAction func updateForToday() {
        updateUIWithDate(Date())
    }
    
    @IBAction func updateForNextWeek() {
        if let nextWeekDate = selectedDate?.nextWeekStart() {
            updateUIWithDate(nextWeekDate)
        }
    }
    
    @IBAction func updateForPreviousWeek() {
        if let previousWeekDate = selectedDate?.lastWeekStart() {
            updateUIWithDate(previousWeekDate)
        }
    }
    
    fileprivate func updateUIWithDate(_ date: Date?) {
        self.selectedDate = date ?? Date()
        if let weekInfo = FormatterUtils.getWeekInfo(self.selectedDate) {
            self.weekInfoLabel?.text = weekInfo
        } else {
            self.weekInfoLabel?.text = nil
        }
        
        if let weekNumber = self.selectedDate?.weekNumber() {
            self.weekNumberLabel?.text = String(weekNumber)
        } else {
            self.weekNumberLabel?.text = nil
        }
    }
}
