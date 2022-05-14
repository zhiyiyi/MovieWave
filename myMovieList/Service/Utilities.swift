//
//  Utilities.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 5/10/22.
//

import Foundation

final class Utilities {
    static let shared = Utilities()
    
    // Convert date format
    func convertDateFormatter(_ date: String?) -> String {
        var fixDate = ""
        let dateFormatter  = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let originalDate = date {
            if let newDate = dateFormatter.date(from: originalDate) {
                dateFormatter.dateFormat = "MM.dd.yyyy"
                fixDate = dateFormatter.string(from: newDate)
            }
        }
        return fixDate
    }
}
    
