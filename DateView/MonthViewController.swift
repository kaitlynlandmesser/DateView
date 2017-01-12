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
    struct Day {
        var date: Date
        var inCurrentMonth: Bool
    }
    var delegate: MonthViewControllerDelegate?
    
    var monthLabel: UILabel!
    var collectionView: UICollectionView!
    
    var firstDayOfMonth: Date!
    var month: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstDayOfMonth = Calendar(identifier: .gregorian).date(bySetting: .month, value: month, of: Date())?.startOfMonth()
        
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
    
    func getDate(for indexPath: IndexPath) -> Day? {
        if indexPath.section == 0 {
            return nil // it's one of the weekday headers
        }
        
        let cal = Calendar(identifier: .gregorian)

        let dayOffset = cal.component(.weekday, from: firstDayOfMonth) - 1
        let daysInMonth = cal.component(.day, from: firstDayOfMonth.endOfMonth())
        
        var todaysDay = ( (indexPath.section - 1) * 7 ) + (indexPath.row + 1) - dayOffset
        
        if todaysDay > daysInMonth {
            todaysDay = todaysDay - daysInMonth
            
            guard var nextMonthDate = cal.date(byAdding: .month, value: 1, to: firstDayOfMonth) else {
                return nil
            }
            nextMonthDate = cal.date(bySetting: .day, value: todaysDay, of: nextMonthDate)!
            
            return Day(date: nextMonthDate, inCurrentMonth: false)
        } else if todaysDay < 1 {
            guard var lastMonthDate = cal.date(byAdding: .month, value: -1, to: firstDayOfMonth) else {
                return nil
            }
            
            let daysInLastMonth = cal.component(.day, from: lastMonthDate.endOfMonth())
            
            todaysDay = todaysDay + daysInLastMonth
            
            lastMonthDate = cal.date(bySetting: .day, value: todaysDay, of: lastMonthDate)!
            
            return Day(date: lastMonthDate, inCurrentMonth: false)
        }
        
        let date = cal.date(bySetting: .day, value: todaysDay, of: firstDayOfMonth)
        
        return Day(date: date!, inCurrentMonth: true)
    }

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "test", for: indexPath) as! CalendarDayCollectionViewCell
        
        if indexPath.section == 0 {
            let days = ["S","M","T","W","T","F","S"]
            cell.day.text = days[indexPath.row]
            return cell
        }
        
        let day = getDate(for: indexPath)
        cell.day.text = day?.date.day
        
        if !(day?.inCurrentMonth)! {
           cell.day.textColor = UIColor.gray
        }
        
        let selectionView = UIView()
        selectionView.backgroundColor = UIColor.red
        selectionView.layer.cornerRadius = (cell.bounds.width)/2
        
        cell.selectedBackgroundView = selectionView
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let date = getDate(for: indexPath)?.date {
            self.delegate?.didSelectDate(date: date)
            print(date.day)
        }
    }
}
