//
//  LogInViewController.swift
//  CookieStoreApp
//
//  Created by Andrea Selina Perez on 2025-02-18.
//

import UIKit

// Log in view instantiates Account and Order History views for when a successful login occurs
// Account and Order History view/functionality is only for authenticated users
class LogInViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!

    let usernameField = UITextField()
    let passwordField = UITextField()
    let loginButton = UIButton(type: .system)
    
    let customPink = UIColor(red: 243/255, green: 188/255, blue: 205/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Login"
        
        setupUI()
    }
    
    func setupUI() {
        // Progrmatically sets input fields and button needed for login functionality
        usernameField.placeholder = "Enter username"
        usernameField.borderStyle = .roundedRect
        passwordField.placeholder = "Enter password"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true

        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        loginButton.tintColor = customPink
        
        // Configures the stack view for the abovementioned elements
        let stack = UIStackView(arrangedSubviews: [usernameField, passwordField, loginButton])
        stack.axis = .vertical
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
    
    // Changes the tab bar items for when a user is logged in (adds Account and Order History tabs)
    @objc func loginTapped() {
        // Ensures username and password fields are filled
        guard let username = usernameField.text, let password = passwordField.text else { return }

        // Checks if username and password matches the hardcoded data for user authentication
        if DataManager.shared.login(username: username, password: password) {
            if let tabBarVC = self.tabBarController {
                
                // Instantiates Account view and creates a tab bar item programatically
                let accountVC = AccountViewController()
                accountVC.tabBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person.crop.circle.fill"), tag: 2)
                // Instantiate Order History view from the storyboard and creates tab bar item programatically
                let orderHistoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:  "OrderHistoryViewController")
                orderHistoryVC.tabBarItem = UITabBarItem(title: "Order History", image: UIImage(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90"), tag: 1)
                
                // Changes the Log in tab bar item to Account and appends the Order History tab bar item to the tab bar controllers
                var newViewControllers = tabBarVC.viewControllers ?? []
                newViewControllers[3] = accountVC
                newViewControllers.append(orderHistoryVC)
                tabBarVC.setViewControllers(newViewControllers, animated: true)
            }
            
            // Sets the view to the Account view right after user logs in
            self.tabBarController?.selectedIndex = 2
            
        } else {
            let alert = UIAlertController(title: "Login Failed", message: "Invalid username or password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}
