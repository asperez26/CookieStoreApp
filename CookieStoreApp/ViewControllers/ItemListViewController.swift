//
//  ItemListViewController.swift
//  CookieStoreApp
//
//  Created by Andrea Selina Perez on 2025-02-18.
//

import UIKit

// Displays a table view for all cookie items for the store
// Cookies can be individually viewed by allowing users to select each table cell
// Instantiates purchase view
class ItemListViewController: UITableViewController {

    let categorizedCookies: [(category: String, cookies: [Cookie])] = [
        ("Classic Cookies", [
            Cookie(name: "Chocolate Chip", price: 2.99, imageName: "chocolate_chip", variants: ["Dark Chocolate", "Milk Chocolate", "White Chocolate"], stock: 20),
            Cookie(name: "Oatmeal Raisin", price: 2.49, imageName: "oatmeal_raisin", variants: ["Regular", "With Nuts", "Extra Raisins"], stock: 20),
            Cookie(name: "Peanut Butter", price: 2.79, imageName: "peanut_butter", variants: ["Crunchy", "Smooth", "Extra Peanut"], stock: 20),
            Cookie(name: "Sugar Cookie", price: 2.59, imageName: "sugar", variants: nil, stock: 100),
            Cookie(name: "Snickerdoodle", price: 2.99, imageName: "snickerdoodle", variants: nil, stock: 100)
        ]),
        ("Specialty Cookies", [
            Cookie(name: "Macadamia White Chocolate", price: 3.49, imageName: "macadamia_white_chocolate", variants: ["Regular", "Extra Macadamia"], stock: 100),
            Cookie(name: "Double Chocolate", price: 3.29, imageName: "double_chocolate", variants: ["Dark Chocolate", "Milk Chocolate"], stock: 100),
            Cookie(name: "Red Velvet", price: 3.59, imageName: "red_velvet", variants: ["Cream Cheese", "White Chocolate"], stock: 100),
            Cookie(name: "S'mores", price: 3.99, imageName: "smores", variants: nil, stock: 100),
            //Cookie(name: "Nutella Stuffed", price: 4.49, imageName: "", variants: nil, stock: 100),
            Cookie(name: "Caramel Pecan", price: 3.79, imageName: "caramel_pecan", variants: nil, stock: 100),
            Cookie(name: "Brownie", price: 3.89, imageName: "brownie", variants: nil, stock: 100)
        ]),
        ("Seasonal Cookies", [
            Cookie(name: "Pumpkin Spice", price: 3.99, imageName: "pumpkin_spice", variants: ["Regular", "With Cinnamon", "Extra Pumpkin"], stock: 100),
            Cookie(name: "Gingerbread", price: 3.49, imageName: "gingerbread", variants: ["Regular", "With Nuts"], stock: 100),
            /*Cookie(name: "Peppermint Chocolate", price: 3.79, imageName: "",
                   variants: nil, stock: 100),
            Cookie(name: "Easter Bunny", price: 4.29, imageName: "", variants: nil, stock: 100),
            Cookie(name: "Lemon Sugar", price: 3.19, imageName: "", variants: nil, stock: 100)*/
        ])
    ]

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cookie Menu"
        
        // Allows cookie data to be shared across views
        DataManager.shared.setCookies(categorizedCookies)
        
        // Reusable cell for displaying cookie items
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CookieCell")
  
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }

    // Sets the section of the menu view based on cookie categories
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categorizedCookies.count
    }

    // Returns number of rows per section based on number of cookies in each category
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorizedCookies[section].cookies.count
    }

    // Configures and displays each cookie item in the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CookieCell", for: indexPath)
        let cookie = categorizedCookies[indexPath.section].cookies[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = cookie.name
        content.secondaryText = "$\(cookie.price)"
        content.image = cookie.image
        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        content.imageProperties.reservedLayoutSize = CGSize(width: 60, height: 60)
        content.imageProperties.cornerRadius = 10

        cell.contentConfiguration = content
        return cell
    }

    // Sets the section headers based on cookie categories
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categorizedCookies[section].category
    }
    
    // Handles item selection and navigates to PurchaseViewController when user taps on a table cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Retrieves the selected cookie
        let selectedCookie = categorizedCookies[indexPath.section].cookies[indexPath.row]
        
        // Storyboard instantiation for PurchaseViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let purchaseVC = storyboard.instantiateViewController(withIdentifier: "PurchaseViewController") as? PurchaseViewController {
            
            purchaseVC.selectedCookie = selectedCookie
            // Allows the purchase view to be pushed to the navigation stack
            navigationController?.pushViewController(purchaseVC, animated: true)
        }
    }
}
