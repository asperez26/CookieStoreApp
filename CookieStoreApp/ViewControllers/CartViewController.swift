//
//  CartViewController.swift
//  CookieStoreApp
//
//  Created by Andrea Selina Perez on 2025-02-19.
//

import UIKit

// Cart view displays a table view for when user purchases an item by adding items in the cart
// Items in the cart can be deleted
// Guest user and authenticated users can use this view's functionality
// Authenticated users checkout items are statically stored and shared in the app, allows order purchases to be viewed in order history
class CartViewController: UITableViewController {
    
    let customPink = UIColor(red: 243/255, green: 188/255, blue: 205/255, alpha: 1.0)
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cart"
        
        setupBackground()
        
        // Reusable cell for displaying cart items
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CartCell")
        
        // Allows user to checkout items
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Checkout", style: .done, target: self, action: #selector(checkoutTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // Sets the section of the cart view table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Returns number of items in the cart
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.cart.count
    }
    
    // Enables table view to display cart items
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath)
        let purchase = DataManager.shared.cart[indexPath.row]

        // Retrieves the full list of available cookies
        let allCookies = DataManager.shared.getAllCookies()
        
        // Displays cart item details with secondary text as total price
        // Uses corresponding cookie based on the name stored in the purchase
        if let matchedCookie = allCookies.first(where: { $0.name == purchase.cookieName }) {
            let totalPrice = Double(purchase.quantity) * matchedCookie.price
            
            var content = cell.defaultContentConfiguration()
            content.text = "\(purchase.quantity)x \(purchase.cookieName) (\(purchase.variant ?? "Regular"))"
            content.secondaryText = "Total: $\(String(format: "%.2f", totalPrice)) (\(purchase.quantity) x $\(String(format: "%.2f", matchedCookie.price)))"
            
            cell.contentConfiguration = content
        }
        
        return cell
    }

    // Enables item deletion functionality for cart items
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataManager.shared.removePurchase(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @objc func checkoutTapped() {
        let alert = UIAlertController(title: "Checkout", message: "Are you sure you want to place your order?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            // Ensures cart is not empty before proceeding checkout
            guard !DataManager.shared.cart.isEmpty else {
                let errorAlert = UIAlertController(title: "Error", message: "Cart is empty!", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(errorAlert, animated: true)
                return
            }
            
            DataManager.shared.checkout() // Save purchases to user's sales history
            
            DataManager.shared.clearCart() // Clears the cart
            self.tableView.reloadData() // Reload table after checkout
            
            // Show success message after user press checkout button
            let successAlert = UIAlertController(title: "Success", message: "Your order has been placed!", preferredStyle: .alert)
            successAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(successAlert, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    // Adds a swipe action to remove cart items
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Remove") { (action, view, completionhandler) in
            DataManager.shared.removePurchase(at: indexPath.row)
            
            // Deletion animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completionhandler(true)
            
        }
        
        delete.backgroundColor = .red

        return UISwipeActionsConfiguration(actions: [delete])
    }

    func setupBackground() {
            let cartSymbol = UIImage(systemName: "cart.fill")?.withTintColor(customPink, renderingMode: .alwaysOriginal)
            
            backgroundImageView.image = cartSymbol
            backgroundImageView.contentMode = .scaleAspectFit
            backgroundImageView.alpha = 0.2 // Transparency
            backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            
            tableView.backgroundView = backgroundImageView
            
            NSLayoutConstraint.activate([
                backgroundImageView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
                backgroundImageView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
                backgroundImageView.widthAnchor.constraint(equalTo: tableView.widthAnchor, multiplier: 0.4),
                backgroundImageView.heightAnchor.constraint(equalTo: backgroundImageView.widthAnchor)
            ])
        }
}
