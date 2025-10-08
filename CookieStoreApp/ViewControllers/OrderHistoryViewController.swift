//
//  OrderHistoryViewController.swift
//  CookieStoreApp
//
//  Created by Andrea Selina Perez on 2025-02-18.
//

import UIKit

// This view controller will only be visible to logged in users
// View is instantiated in the login view controller when user successfully logs in
class OrderHistoryViewController: UITableViewController {
    
    // For storing grouped orders
    // Each order ID can contain multiple purchases
    var groupedSalesHistory: [(orderId: String, purchases: [Purchase])] = []

    let customPink = UIColor(red: 243/255, green: 188/255, blue: 205/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Order History"
        
        // Reusable table cell for user past orders (grouped/sectioned)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
        
        view.backgroundColor = customPink
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let salesHistory = DataManager.shared.getSalesHistory()

        // Group orders by orderId and sort them in descending order (newest first)
        let groupedOrders = Dictionary(grouping: salesHistory, by: { $0.orderId })
            .sorted { $0.key > $1.key } // Sort by order ID descending (latest order first)

        groupedSalesHistory = groupedOrders.map { ($0.key, $0.value) }

        // Reloads the table data to display the updated order history
        tableView.reloadData()
    }
    
    // Returns the number of sections based on grouped orders
    override func numberOfSections(in tableView: UITableView) -> Int {
        return groupedSalesHistory.count
    }
    
    // Displays order ID as the section header
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groupedSalesHistory[section].orderId
    }
    
    // Returns the number of purchases in each order
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedSalesHistory[section].purchases.count
    }
    
    // Configures and displays each purchase item inside the corresponding order section
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        let purchase = groupedSalesHistory[indexPath.section].purchases[indexPath.row]
        
        // Displays item details and date of purchase
        var content = cell.defaultContentConfiguration()
        content.text = "\(purchase.quantity)x \(purchase.cookieName) (\(purchase.variant ?? "Regular"))"
        content.secondaryText = "Purchased on \(purchase.dateFormatted)"
                
        cell.contentConfiguration = content
        return cell
    }
}
