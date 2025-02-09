//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Taijaun Pitt on 09/02/2025.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
