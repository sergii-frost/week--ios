//
//  WeekPickerViewController.swift
//  weeknum
//
//  Created by Sergii Nezdolii on 28/08/16.
//  Copyright © 2016 FrostDigital. All rights reserved.
//

import UIKit

protocol WeekPickerDelegate: class {
    func didSelectWeek(weekNumber: Int?)
}

class WeekPickerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var weekNumbersCollectionView: UICollectionView!
    weak var delegate: WeekPickerDelegate?
    var weeksRange: [Int] = [] {
        didSet {
            if weeksRange.first == 0 {
                weeksRange.removeFirst()
            }
            if let _ = self.weekNumbersCollectionView {
                self.weekNumbersCollectionView.reloadData()
            }
        }
    }
    var selectedDate: NSDate = NSDate() {
        didSet {
            guard let range = self.selectedDate.weeksRangeInYear() else {return}
            self.weeksRange = range
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let weekToSelect = selectedDate.weekNumber() ?? NSDate().weekNumber() else {
            return
        }
        weekNumbersCollectionView.selectItemAtIndexPath(indexPathForWeek(weekToSelect), animated: true, scrollPosition: UICollectionViewScrollPosition.None)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weeksRange.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WeekNumberCollectionViewCell", forIndexPath: indexPath) as! WeekNumberCollectionViewCell
        cell.weekNumberLabel.text = "\(weekForIndexPath(indexPath))"
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.None)
        if let delegate = self.delegate {
            delegate.didSelectWeek(weekForIndexPath(indexPath))
        }
    }
    
    private func weekForIndexPath(indexPath: NSIndexPath) -> Int {
        return weeksRange[indexPath.row]
    }
    
    private func indexPathForWeek(weekNum: Int) -> NSIndexPath {
        guard let weekIndex = weeksRange.indexOf(weekNum) else {
            return NSIndexPath(forRow: 0, inSection: 0)
        }
        return NSIndexPath(forRow: weekIndex, inSection: 0)
    }
}

class WeekNumberCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var selectorView: UIView!
    @IBOutlet weak var weekNumberLabel: UILabel!
    
    override var selected: Bool {
        didSet {
            markSelected(self.selected)
        }
    }
    
    override var highlighted: Bool {
        didSet {
            markSelected(self.highlighted)
        }
    }
    
    private func markSelected(selected: Bool) {
        selectorView.backgroundColor = selected ? UIColor.weekNumMainColor() : UIColor.weekNumWhiteColor()
        weekNumberLabel.textColor = selected ? UIColor.weekNumWhiteColor() : UIColor.weekNumMainColor()
    }
}