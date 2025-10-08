//
//  Purchase.swift
//  CookieStoreApp
//
//  Created by Andrea Selina Perez on 2025-02-18.
//

import Foundation

struct Purchase {
    let orderId: String
    let userId: String
    let cookieName: String
    let variant: String?
    let quantity: Int
    let date: Date
    
    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    var timestamp: TimeInterval { date.timeIntervalSince1970 }
}
