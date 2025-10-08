//
//  AccountViewController.swift
//  CookieStoreApp
//
//  Created by Andrea Selina Perez on 2025-02-18.
//

import UIKit

// Account view is for when a user successfully logs in in the app
// Intention is to show a successful user authentication
// User data is hardcoded
// User logging out will return to the initial app view (removes Account and Order History tabs)
class AccountViewController: UIViewController {
    let usernameLabel = UILabel()
    let logoutButton = UIButton(type: .system)
    
    let customPink = UIColor(red: 243/255, green: 188/255, blue: 205/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = customPink
        title = "Account"
        
        setupUI()
    }
    
    // Programatically setting up UI for Account view where users will be directed to after logging in successfully
    func setupUI() {
        guard let user = DataManager.shared.loggedInUser else { return }

        // Welcome message for logged in user
        usernameLabel.text = "Hello, \(user.username)!"
        usernameLabel.textAlignment = .center
        usernameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
                
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        logoutButton.tintColor = .black
        
        // Configuration for stack view display
        let stack = UIStackView(arrangedSubviews: [usernameLabel, logoutButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
                
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
    
    // Logs user out and resets display with main tab bar
    @objc func logoutTapped() {
        DataManager.shared.logout()

        // Resets root view controller (requiring logging in again)
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = MainTabBarController()
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
}
