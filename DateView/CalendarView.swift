//
//  CalendarView.swift
//  DateView
//
//  Created by Kaitlyn Landmesser on 1/11/17.
//  Copyright © 2017 Industrial Scientific. All rights reserved.
//

import UIKit

protocol CalendarViewDelegate {
    func didSelectDate(date: Date)
}

class CalendarView: UIView, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    var delegate: CalendarViewDelegate?
    var pageView: UIPageViewController!
    var selectedDate = Date()
    
    var centerViewController: MonthViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        pageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        pageView.delegate = self
        pageView.dataSource = self
        pageView.view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 340)
        
        centerViewController = newViewController(date: selectedDate)
        
        if let firstViewController = centerViewController {
            pageView.setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        self.addSubview(pageView.view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func newViewController(date: Date) -> MonthViewController {
        let new = MonthViewController()
        new.firstDayOfMonth = date.startOfMonth()
        new.selectedDay = selectedDate
        new.delegate = self
        return new
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let v = viewController as! MonthViewController
        
        return newViewController(date: v.firstDayOfMonth.nextMonth())
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let v = viewController as! MonthViewController
        
        return newViewController(date: v.firstDayOfMonth.previousMonth())
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 100
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 50
    }
}

extension CalendarView: MonthViewControllerDelegate {
    func didSelectDate(date: Date) {
        selectedDate = date
        self.delegate?.didSelectDate(date: date)
    }
}
