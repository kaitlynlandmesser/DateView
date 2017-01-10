//
//  ViewController.swift
//  DateView
//
//  Created by Kaitlyn Landmesser on 1/10/17.
//  Copyright © 2017 Industrial Scientific. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var calendar: UICollectionView!
    
    let cal = Calendar(identifier: .gregorian)
    let components = DateComponents()

    var month: Int!
    var dayOffset: Int!
    
    var daysInMonth: Int!
    var daysInLastMonth: Int!

    override func viewDidLoad() {
        calendar.delegate = self
        calendar.dataSource = self
        
        month = 2

        guard let monthDay = cal.date(bySetting: .month, value: month, of: Date()) else{
            return
        }
        
        let firstDay = monthDay.startOfMonth()
        let lastDay = monthDay.endOfMonth()
        
        dayOffset = cal.component(.weekday, from: firstDay)
        daysInMonth = cal.component(.day, from: lastDay)
        
        
        guard let lastMonthDate = cal.date(byAdding: .month, value: -1, to: monthDay) else {
            return //what does returning in view did load do?
        }
        
        print("\(lastMonthDate)")

        
        daysInLastMonth = cal.component(.day, from: lastMonthDate.endOfMonth())
        
        print("\(daysInLastMonth)")
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: (view.bounds.width - 110)/7, height: (view.bounds.width - 110)/7)
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 10
        calendar.collectionViewLayout = layout
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "test", for: indexPath) as! CalendarDayCollectionViewCell
        
        if indexPath.section == 0 {
            let days = ["S","M","T","W","T","F","S"]
            cell.day.text = days[indexPath.row]
            return cell
        }
        
        var todaysDate = ( (indexPath.section - 1) * 7 ) + (indexPath.row - 1) - dayOffset
        
        if todaysDate > daysInMonth {
            todaysDate = todaysDate - daysInMonth
            cell.day.textColor = UIColor.gray
        } else if todaysDate < 1 {
            todaysDate = todaysDate + daysInLastMonth
            cell.day.textColor = UIColor.gray
        }
        
        cell.day.text = "\(todaysDate)"
        
        let selectionView = UIView()
        selectionView.backgroundColor = UIColor.red
        selectionView.layer.cornerRadius = (cell.bounds.width)/2
        
        cell.selectedBackgroundView = selectionView
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected item \(indexPath)")

    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

