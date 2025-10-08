//
//  DataManager.swift
//  CookieStoreApp
//
//  Created by Andrea Selina Perez on 2025-02-18.
//

import Foundation

// SIngleton class responsible for managing user authentication, cart, and sales history
class DataManager {
    // Ensures global access
    static let shared = DataManager()
    
    private init() {} // Enforce singleton instance
    
    // Sample users / stored in memory for log in authentication
    var users: [User] = [
        User(username: "Andrea", password: "password123"),
        User(username: "John_doe", password: "password456")
    ]
    
    // Stores the currently logged in user, if any.
    var loggedInUser: User?
    
    // Verifies user credentials
    func login(username: String, password: String) -> Bool {
        if let userIndex = users.firstIndex(where: { $0.username == username && $0.password == password}) {
            loggedInUser = users[userIndex]
            return true
        }
        return false
    }
    
    // Clears loggedInUser property when user logs out
    func logout(){
        loggedInUser = nil
    }
    
    // Stores categorizes cookies and items added to the cart
    var categorizedCookies: [(category: String, cookies: [Cookie])] = []
    var cart: [Purchase] = []
    
    private var salesHistory: [String: [Purchase]] = [:]
    
    // List of available cookies
    func setCookies(_ cookies: [(category: String, cookies: [Cookie])]) {
        categorizedCookies = cookies
    }
    // Retrieves all cookies in the categorized list
    func getAllCookies() -> [Cookie] {
        return categorizedCookies.flatMap { $0.cookies }
    }

    // Adds a purchase item in the cart
    func addPurchase(_ purchase: Purchase) {
        cart.append(purchase)
    }
    
    // Removes a purchase item from the cart at a specified index
    func removePurchase(at index: Int) {
        if index < cart.count {
            cart.remove(at: index)
        }
    }
    
    func clearCart() {
        cart.removeAll()
    }
    
    // Completes the checkout process, moving the cart items to user sales history
    func checkout() {
        let userId = loggedInUser?.username ?? "Guest"
        
        // Ensures sales history exists for the user
        if salesHistory[userId] == nil {
            salesHistory[userId] = []
        }

        print("Checking out \(cart.count) items for \(userId)") // Debugging Log

        // Unique order id for user purchases
        let ordersCount = Set(salesHistory[userId]?.map { $0.orderId } ?? []).count
        let orderId = "Order #\(ordersCount + 1)"

        // Converts the cart purchases into order history entries
        let checkoutItems = cart.map { item in
                Purchase(orderId: orderId, userId: item.userId, cookieName: item.cookieName, variant: item.variant, quantity: item.quantity, date: Date())
            }
        
        salesHistory[userId]?.append(contentsOf: checkoutItems) // Move cart to sales history
        cart.removeAll()
        
        print("Checkout complete. Sales History for \(userId) now has \(salesHistory[userId]?.count ?? 0) orders") // Debugging Log
    }
    
    // Retrieves sales history for the logged in user
    func getSalesHistory() -> [Purchase] {
        let userId = loggedInUser?.username ?? "Guest"
        print("Fetching Sales History for \(userId): \(salesHistory[userId]?.count ?? 0) orders") // Debugging Log
        return salesHistory[userId] ?? []
    }

}
