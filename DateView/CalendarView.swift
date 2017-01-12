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
    
    var pages = [UIViewController]()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        pageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        pageView.delegate = self
        pageView.dataSource = self
        pageView.view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 340)
        
        pages = [newViewController(month: 1),
                 newViewController(month: 2),
                 newViewController(month: 3),
                 newViewController(month: 4),
                 newViewController(month: 5)]
        
        if let firstViewController = pages.first {
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
    
    func newViewController(month: Int) -> MonthViewController {
        let new = MonthViewController()
        new.month = month
        new.delegate = self
        return new
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = currentIndex + 1
        
        if nextIndex < pages.count {
            return pages[nextIndex]
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.index(of: viewController) else {
            return nil
        }
        
        let previous = currentIndex - 1
        
        if previous >= 0 {
            return pages[previous]
        }
        
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = pageView.viewControllers?.first else {
            return 0
        }
        
        guard let firstViewControllerIndex = pages.index(of: firstViewController) else {
            return 0
        }
        
        return firstViewControllerIndex
    }
}

extension CalendarView: MonthViewControllerDelegate {
    func didSelectDate(date: Date) {
        self.delegate?.didSelectDate(date: date)
    }
}
