//
//  Cookie.swift
//  CookieStoreApp
//
//  Created by Andrea Selina Perez on 2025-02-18.
//

import UIKit

struct Cookie {
    let name: String
    let price: Double
    let imageName: String
    let variants: [String]?
    var stock: Int
    
    var image: UIImage? {
        return UIImage(named: imageName) ?? UIImage(systemName: "photo")
    }
    
    var description: String {
        "\(name) - $ \(price)"
    }
}
