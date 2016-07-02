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

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.updateForToday), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateForToday()
    }
    
    func updateForToday() {
        self.updateUIWithDate(NSDate())
    }
    
    private func updateUIWithDate(date: NSDate) {
        self.dateLabel.text = date.formatted()
        if let dayOfWeek = date.dayOfWeek(), let dayWithName = WeekDays(rawValue: dayOfWeek) {
            self.weekDayLabel.text = dayWithName.name
        } else {
            self.weekDayLabel.text = nil
        }
        
        if let weekNumber = date.weekNumber() {
            self.weekNumberLabel.text = String(weekNumber)
        } else {
            self.weekNumberLabel.text = nil
        }
        
    }
}

