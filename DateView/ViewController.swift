//
//  ViewController.swift
//  DateView
//
//  Created by Kaitlyn Landmesser on 1/10/17.
//  Copyright © 2017 Industrial Scientific. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var calendar: CalendarView!
    var isCalendarOnScreen = false
    
    var dateLabel: UILabel!
    var selectedDate = Date()
    
    override func viewDidLoad() {
        dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        dateLabel.text = selectedDate.full
        dateLabel.textAlignment = .center
        
        view.addSubview(dateLabel)
        
        calendar = CalendarView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 360))
        calendar.center.y  -= calendar.bounds.height

        calendar.delegate = self

        animateShowCalendar()
        
        super.viewDidLoad()
    }
    
    func tapped() {
        if isCalendarOnScreen {
            dismissCalendar()
        } else {
            animateShowCalendar()
        }
    }
    
    func animateShowCalendar() {
        isCalendarOnScreen = true
        
        view.addSubview(calendar)

        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseIn], animations: {
            self.calendar.center.y += self.calendar.bounds.height
        }, completion: nil)
    }
    
    func dismissCalendar() {
        isCalendarOnScreen = false

        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseIn], animations: {
            self.calendar.center.y -= self.calendar.bounds.height
        }, completion: { _ in
            self.calendar.removeFromSuperview()
        })
    }
}

extension ViewController: CalendarViewDelegate {
    func didSelectDate(date: Date) {
        selectedDate = date
        dateLabel.text = selectedDate.full
        self.dismissCalendar()
    }
}

