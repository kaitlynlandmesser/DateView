//
//  Date.swift
//  DateView
//
//  Created by Kaitlyn Landmesser on 1/11/17.
//  Copyright © 2017 Industrial Scientific. All rights reserved.
//

import Foundation

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    var headerFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        
        return formatter.string(from: self)
    }
    
    var day: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        
        return formatter.string(from: self)
    }
    
    var full: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        
        return formatter.string(from: self)
    }
}
