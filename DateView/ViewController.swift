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
    
    var dateButton: UIButton!
    var backButton: UIButton!
    var forwardButton: UIButton!
    
    var selectedDate = Date()
    
    override func viewDidLoad() {
        calendar = CalendarView()
        
        calendar.delegate = self
        
        dateButton = UIButton(frame: CGRect(x: 0, y: 0, width: 400, height: 50))
        dateButton.setTitle(calendar.selectedDate.full, for: .normal)
        dateButton.setTitleColor(UIColor.black, for: .normal)
        dateButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 15)
        dateButton.titleLabel?.textAlignment = .center
        dateButton.addTarget(self, action: #selector(ViewController.animateShowCalendar), for: .touchUpInside)

        backButton = UIButton(frame: CGRect(x: 30, y: 18, width: 13, height: 13))
        backButton.setImage(UIImage(named: "Backward"), for: .normal)
        backButton.addTarget(self, action: #selector(ViewController.backward), for: .touchUpInside)

        forwardButton = UIButton(frame: CGRect(x: view.frame.width - 60, y: 18, width: 13, height: 13))
        forwardButton.setImage(UIImage(named: "Forward"), for: .normal)
        forwardButton.addTarget(self, action: #selector(ViewController.forward), for: .touchUpInside)

        view.addSubview(dateButton)
        view.addSubview(backButton)
        view.addSubview(forwardButton)
        
        super.viewDidLoad()
    }
    
    func forward() {
        calendar.selectedDate = calendar.selectedDate.nextDay()
        dateButton.setTitle(calendar.selectedDate.full, for: .normal)
    }
    
    func backward() {
        calendar.selectedDate = calendar.selectedDate.previousDay()
        dateButton.setTitle(calendar.selectedDate.full, for: .normal)
    }
    
    func animateShowCalendar() {
        calendar = CalendarView(frame: CGRect(x: 0, y: 10, width: view.frame.width, height: 360))
        calendar.selectedDate = selectedDate
        calendar.center.y  -= calendar.bounds.height
        calendar.delegate = self

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
            self.calendar = nil
        })
    }
}

extension ViewController: CalendarViewDelegate {
    func didSelectDate(date: Date) {
        selectedDate = date
        dateButton.setTitle(calendar.selectedDate.full, for: .normal)
        self.dismissCalendar()
    }
}

