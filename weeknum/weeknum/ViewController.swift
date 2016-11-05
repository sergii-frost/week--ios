//
//  ViewController.swift
//  weeknum
//
//  Created by Sergii Nezdolii on 02/07/16.
//  Copyright © 2016 FrostDigital. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate, WeekPickerDelegate {

    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var weekInfoLabel: UILabel!
    @IBOutlet weak var weekNumberLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateForToday), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        setupDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateForToday()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Date Picker setup
    
    fileprivate func setupDatePicker() {
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.sendAction("setHighlightsToday:", to: nil, for: nil)
    }
    
    @IBAction func updateForToday() {
        self.datePicker.date = Date()
        datePickerChangedValue(self.datePicker)
    }
    
    @IBAction func updateForNextWeek() {
        if let nextWeekDate = self.datePicker.date.nextWeekStart() {
            self.datePicker.date = nextWeekDate
            datePickerChangedValue(self.datePicker)
        }
    }
    
    @IBAction func updateForPreviousWeek() {
        if let previousWeekDate = self.datePicker.date.lastWeekStart() {
            self.datePicker.date = previousWeekDate
            datePickerChangedValue(self.datePicker)
        }
    }

    
    @IBAction func datePickerChangedValue(_ datePickerWithNewValue: UIDatePicker) {
        updateUIWithDate(datePickerWithNewValue.date)
    }
    
    //MARK: - Week Popover methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "weekPickerSegue" {
            if segue.destination is WeekPickerViewController {
                let weekPickerViewController: WeekPickerViewController = segue.destination as! WeekPickerViewController
                weekPickerViewController.delegate = self
                weekPickerViewController.selectedDate = self.datePicker.date
                //Some magic to make it work as popover
                weekPickerViewController.modalPresentationStyle = UIModalPresentationStyle.popover
                weekPickerViewController.popoverPresentationController!.delegate = self
                fixIOS9PopOverAnchor(segue)
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    //MARK: - WeekPickerDelegate
    
    func didSelectWeek(_ weekNumber: Int?) {
        if let weekNumber = weekNumber, let startForWeek = self.datePicker.date.startForWeek(weekNumber) {
            self.datePicker.date = startForWeek
            datePickerChangedValue(self.datePicker)
        }
    }
    
    //MARK: - UI related methods
    
    fileprivate func updateUIWithDate(_ date: Date) {
        if  let formattedDate = FormatterUtils.formattedDate(date) {
            self.dateLabel?.fadeTransition()
            self.dateLabel?.text = formattedDate
        } else {
            self.dateLabel?.text = nil
        }
        
        if let weekInfo = FormatterUtils.getWeekInfo(date) {
            self.weekInfoLabel.fadeTransition()
            self.weekInfoLabel.text = weekInfo
        } else {
            self.weekInfoLabel.text = nil
        }
        
        if let weekNumber = date.weekNumber() {
            self.weekNumberLabel.fadeTransition()
            self.weekNumberLabel.text = String(weekNumber)
        } else {
            self.weekNumberLabel.text = nil
        }
        
    }
}

