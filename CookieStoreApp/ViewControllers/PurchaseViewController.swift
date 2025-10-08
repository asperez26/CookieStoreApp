//
//  PurchaseViewController.swift
//  CookieStoreApp
//
//  Created by Andrea Selina Perez on 2025-02-18.
//

import UIKit

// Purchase view is for when the user selects a cookie from the table view in the menu
// Displays cookie image, name, and buttons to add the cookie and check cart items
class PurchaseViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // Stores the cookie item selected by the user
    var selectedCookie: Cookie?
    
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let pickerView = UIPickerView()
    let addToCartButton = UIButton(type: .system)
    let goToCartButton = UIButton(type: .system)
    
    var selectedVariant: String? // Stores the selected variant of the cookie
    var selectedQuantity: Int = 1 // Default qty set to 1
    
    let customPink = UIColor(red: 243/255, green: 188/255, blue: 205/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(.white)
        title = "Purchase"
        
        setupUI()
    }
    
    func setupUI() {
        guard let cookie = selectedCookie else { return }
        
        // Configures the image display for the selected cookie
        imageView.image = cookie.image ?? UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // Displays selected cookie name
        nameLabel.text = cookie.name
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.textColor = customPink
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        // Configures the picker view for selecting a variant and quantity
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up for adding cookie to cart
        addToCartButton.setTitle("Add to Cart - $\(cookie.price)", for: .normal)
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        addToCartButton.backgroundColor = customPink
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.layer.cornerRadius = 8
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        // Set up for checking current cart items
        goToCartButton.setTitle("Go to Cart", for: .normal)
        goToCartButton.addTarget(self, action: #selector(goToCart), for: .touchUpInside)
        goToCartButton.backgroundColor = customPink
        goToCartButton.setTitleColor(.white, for: .normal)
        goToCartButton.layer.cornerRadius = 8
        goToCartButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Stack view layout configuration as elements in the view are added programatically
        let stack = UIStackView(arrangedSubviews: [imageView, nameLabel, pickerView, addToCartButton, goToCartButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 30, left: 20, bottom: 30, right: 20)
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),

            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
        
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            pickerView.heightAnchor.constraint(equalToConstant: 120),

            addToCartButton.heightAnchor.constraint(equalToConstant: 50),
            addToCartButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),

            goToCartButton.heightAnchor.constraint(equalToConstant: 50),
            goToCartButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
        
        // Default selection for cookie variant
        if let variants = cookie.variants, !variants.isEmpty {
            selectedVariant = variants[0]
        } else {
            selectedVariant = "Regular"
        }
    }
    
    // Handles adding to cart functionality
    @objc func addToCartTapped() {
        guard let cookie = selectedCookie else { return }
        
        let userId = DataManager.shared.loggedInUser?.username ?? "Guest"
        
        // Generate order ID based on existing sales history
        let pastOrders = DataManager.shared.getSalesHistory()
        let uniqueOrderIds = Set(pastOrders.map { $0.orderId })
        let orderId = "Order # \(uniqueOrderIds.count + 1)"
        
        // Create a new purchase and ass to cart
        let newPurchase = Purchase(orderId: orderId, userId: userId, cookieName: cookie.name, variant: selectedVariant, quantity: selectedQuantity, date: Date())
        DataManager.shared.addPurchase(newPurchase)
        
        showTemporaryMessage("Added to Cart!")
    }
    
    // Navigates to cart view when Go to cart button is tapped
    @objc func goToCart() {
        let cartVC = CartViewController()
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
    // Manages the alert message for when user adds an item to the cart
    func showTemporaryMessage(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        self.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    // Sets the variant and quantity as picker view's components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // Returns the number of rows in each component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return selectedCookie?.variants?.count ?? 1
        } else {
            return selectedCookie?.stock ?? 1
        }
    }
    
    // Sets the title for each row in the picker view in variant component
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return selectedCookie?.variants?[row] ?? "Regular"
        } else {
            return "\(row + 1)"
        }
    }
    
    // Updates the selected variant or quantity when user selects a row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedVariant = selectedCookie?.variants?[row] ?? "Regular"
        } else {
            selectedQuantity = row + 1
        }
    }
}
