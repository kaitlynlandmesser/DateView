//
//  MonthViewController.swift
//  DateView
//
//  Created by Kaitlyn Landmesser on 1/11/17.
//  Copyright © 2017 Industrial Scientific. All rights reserved.
//

import UIKit

private let reuseIdentifier = "test"

protocol MonthViewControllerDelegate {
    func didSelectDate(date: Date)
}
class MonthViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var delegate: MonthViewControllerDelegate?
    
    var monthLabel: UILabel!
    var collectionView: UICollectionView!
    
    var firstDayOfMonth: Date!
    var selectedDay: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        monthLabel.text = "\(firstDayOfMonth.headerFormat)"
        monthLabel.textAlignment = .center
        
        view.addSubview(monthLabel)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: (view.bounds.width - 110)/7, height: (view.bounds.width - 110)/7)
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 40, width: view.frame.width, height: 300), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(CalendarDayCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.isOpaque = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
    }
    
    func getDate(for indexPath: IndexPath) -> Date? {
        if indexPath.section == 0 {
            return nil // it's one of the weekday headers
        }
        
        let cal = Calendar(identifier: .gregorian)

        let dayOffset = cal.component(.weekday, from: firstDayOfMonth) - 1
        let daysInMonth = cal.component(.day, from: firstDayOfMonth.endOfMonth())
        
        let todaysDay = ( (indexPath.section - 1) * 7 ) + (indexPath.row + 1) - dayOffset
        
        if todaysDay > daysInMonth {
            return cal.date(bySetting: .day, value: todaysDay - daysInMonth, of: firstDayOfMonth.nextMonth())
        } else if todaysDay < 1 {
            let lastMonthDate = firstDayOfMonth.previousMonth()
            let daysInLastMonth = cal.component(.day, from: lastMonthDate.endOfMonth())
            
            return cal.date(bySetting: .day, value: todaysDay + daysInLastMonth, of: lastMonthDate)
        }
        
        return cal.date(bySetting: .day, value: todaysDay, of: firstDayOfMonth)
    }

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // three types of resuse : selected cell, today cell, out of month cell, in month cell, not selected cell
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "test", for: indexPath) as! CalendarDayCollectionViewCell
        
        if indexPath.section == 0 {
            let days = ["S","M","T","W","T","F","S"]
            cell.day.text = days[indexPath.row]
            return cell
        }

        cell.backgroundView = UIView()

        if let date = getDate(for: indexPath) {
            cell.day.text = date.day
            if !firstDayOfMonth.sameMonth(date: date) {
                cell.day.textColor = UIColor.gray
                print("gray cell")
            }
            
            if date.isToday {
                let background = UIView()
                background.layer.cornerRadius = (cell.bounds.width)/2
                background.layer.borderWidth = 1
                background.layer.borderColor = UIColor.red.cgColor
                
                cell.backgroundView = background
            }
            
            if let s = selectedDay {
                if s.sameDay(date: date) {
                    selectDay(indexPath: indexPath)
                }
            }
            
        }
        
        let selectionView = UIView()
        selectionView.backgroundColor = UIColor.red
        selectionView.layer.cornerRadius = (cell.bounds.width)/2
        
        cell.selectedBackgroundView = selectionView
        
        return cell
    }
    
    func selectDay(indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            let background = UIView()
            background.backgroundColor = UIColor.green
            background.layer.cornerRadius = (cell.bounds.width)/2
            
            cell.backgroundView = background
            
            cell.isSelected = false
        }
    }

    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let date = getDate(for: indexPath) {
            self.delegate?.didSelectDate(date: date)
        }
    }
}
