//
//  WeekPickerViewController.swift
//  weeknum
//
//  Created by Sergii Nezdolii on 28/08/16.
//  Copyright © 2016 FrostDigital. All rights reserved.
//

import UIKit

protocol WeekPickerDelegate: class {
    func didSelectWeek(_ weekNumber: Int?)
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
    var selectedDate: Date = Date() {
        didSet {
            guard let range = self.selectedDate.weeksRangeInYear() else {return}
            self.weeksRange = range
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fitSizeToShowAllWeekNumbers()
        guard let weekToSelect = selectedDate.weekNumber() ?? Date().weekNumber() else {
            return
        }
        weekNumbersCollectionView.selectItem(at: indexPathForWeek(weekToSelect), animated: true, scrollPosition: UICollectionViewScrollPosition())
    }
    
    /** 
    Checks Popover Presentation controller to get actual width of presented controller.
    
    Then resizes popover to fit whole collection view content.
    */
    private func fitSizeToShowAllWeekNumbers() {
        //Tricky workaround to make popover fit collection view size
        if let popoverFrame = self.popoverPresentationController?.sourceView?.frame {
            self.weekNumbersCollectionView.frame.size.width = popoverFrame.width
            self.weekNumbersCollectionView.collectionViewLayout.invalidateLayout()
            self.preferredContentSize = self.weekNumbersCollectionView.collectionViewLayout.collectionViewContentSize
        }
    }
    
    //MARK: - UICollectionView Delegate and DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weeksRange.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekNumberCollectionViewCell", for: indexPath) as! WeekNumberCollectionViewCell
        cell.weekNumberLabel.text = "\(weekForIndexPath(indexPath))"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
        if let delegate = self.delegate {
            delegate.didSelectWeek(weekForIndexPath(indexPath))
        }
    }
    
    fileprivate func weekForIndexPath(_ indexPath: IndexPath) -> Int {
        return weeksRange[(indexPath as NSIndexPath).row]
    }
    
    fileprivate func indexPathForWeek(_ weekNum: Int) -> IndexPath {
        guard let weekIndex = weeksRange.index(of: weekNum) else {
            return IndexPath(row: 0, section: 0)
        }
        return IndexPath(row: weekIndex, section: 0)
    }
}

class WeekNumberCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var selectorView: UIView!
    @IBOutlet weak var weekNumberLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            markSelected(self.isSelected)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            markSelected(self.isHighlighted)
        }
    }
    
    fileprivate func markSelected(_ selected: Bool) {
        selectorView.backgroundColor = selected ? UIColor.weekNumMainColor() : UIColor.weekNumWhiteColor()
        weekNumberLabel.textColor = selected ? UIColor.weekNumWhiteColor() : UIColor.weekNumMainColor()
    }
}
