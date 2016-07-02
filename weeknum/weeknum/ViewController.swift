//
//  ViewController.swift
//  weeknum
//
//  Created by Sergii Nezdolii on 02/07/16.
//  Copyright © 2016 FrostDigital. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var weekNumberLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.updateForToday), name: UIApplicationDidBecomeActiveNotification, object: nil)
        setupDatePicker()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateForToday()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: - Date Picker setup
    
    private func setupDatePicker() {
        datePicker.setValue(UIColor.whiteColor(), forKey: "textColor")
        datePicker.sendAction("setHighlightsToday:", to: nil, forEvent: nil)
    }
    
    @IBAction func updateForToday() {
        self.datePicker.date = NSDate()
        updateUIWithDate(self.datePicker.date)
    }
    
    @IBAction func datePickerChangedValue(datePickerWithNewValue: UIDatePicker) {
        updateUIWithDate(datePickerWithNewValue.date)
    }
    
    //MARK: - UI related methods
    
    private func updateUIWithDate(date: NSDate) {
        self.dateLabel.fadeTransition()
        self.dateLabel.text = date.formatted()
        if let dayOfWeek = date.dayOfWeek(), let dayWithName = WeekDays(rawValue: dayOfWeek) {
            self.weekDayLabel.fadeTransition()
            self.weekDayLabel.text = dayWithName.name
        } else {
            self.weekDayLabel.text = nil
        }
        
        if let weekNumber = date.weekNumber() {
            self.weekNumberLabel.fadeTransition()
            self.weekNumberLabel.text = String(weekNumber)
        } else {
            self.weekNumberLabel.text = nil
        }
        
    }
}

