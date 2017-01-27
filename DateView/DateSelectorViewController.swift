//
//  ViewController.swift
//  DateView
//
//  Created by Kaitlyn Landmesser on 1/10/17.
//  Copyright © 2017 Industrial Scientific. All rights reserved.
//

import UIKit

protocol DateSelectorViewControllerDelegate {
    func didSelectNewDate(date: Date)
}

class DateSelectorViewController: UIViewController {
    var delegate: DateSelectorViewControllerDelegate?
    
    var calendar: CalendarView!
    
    var dateButton: UIButton!
    var backButton: UIButton!
    var forwardButton: UIButton!
    
    var selectedDate = Date()
    
    override func viewDidLoad() {
        calendar = CalendarView(frame: CGRect(x: 0, y: 10, width: view.frame.width, height: 360))
        calendar.selectedDate = selectedDate
        calendar.center.y  -= calendar.bounds.height
        calendar.delegate = self
        
        dateButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        dateButton.setTitle(calendar.selectedDate.full, for: .normal)
        dateButton.setTitleColor(UIColor.black, for: .normal)
        dateButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 15)
        dateButton.titleLabel?.textAlignment = .center
        dateButton.addTarget(self, action: #selector(DateSelectorViewController.animateShowCalendar), for: .touchUpInside)
        dateButton.titleLabel?.textAlignment = .center

        backButton = UIButton(frame: CGRect(x: 30, y: 18, width: 13, height: 13))
        backButton.setImage(UIImage(named: "Backward"), for: .normal)
        backButton.addTarget(self, action: #selector(DateSelectorViewController.backward), for: .touchUpInside)

        forwardButton = UIButton(frame: CGRect(x: view.frame.width - 60, y: 18, width: 13, height: 13))
        forwardButton.setImage(UIImage(named: "Forward"), for: .normal)
        forwardButton.addTarget(self, action: #selector(DateSelectorViewController.forward), for: .touchUpInside)

        view.addSubview(dateButton)
        view.addSubview(backButton)
        view.addSubview(forwardButton)
        
        super.viewDidLoad()
    }
    
    func forward() {
        selectedDate = calendar.selectedDate.nextDay()
        calendar.selectedDate = selectedDate
        dateButton.setTitle(calendar.selectedDate.full, for: .normal)
        delegate?.didSelectNewDate(date: selectedDate)
    }
    
    func backward() {
        selectedDate = calendar.selectedDate.previousDay()
        calendar.selectedDate = selectedDate
        dateButton.setTitle(calendar.selectedDate.full, for: .normal)
        delegate?.didSelectNewDate(date: selectedDate)
    }
    
    func animateShowCalendar() {
        calendar.setCenter()

        view.addSubview(calendar)

        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseIn], animations: {
            self.calendar.center.y += self.calendar.bounds.height
        }, completion: nil)
    }
    
    func dismissCalendar() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseIn], animations: {
            self.calendar.center.y -= self.calendar.bounds.height
        }, completion: { _ in
            self.calendar.removeFromSuperview()
        })
    }
}

extension DateSelectorViewController: CalendarViewDelegate {
    func didSelectDate(date: Date) {
        selectedDate = date
        dateButton.setTitle(calendar.selectedDate.full, for: .normal)
        self.dismissCalendar()
        delegate?.didSelectNewDate(date: selectedDate)
    }
}

