//
//  MainTabBarController.swift
//  CookieStoreApp
//
//  Created by Andrea Selina Perez on 2025-02-18.
//

import UIKit

// Initial view controller for the app
class MainTabBarController: UITabBarController {
    
    let customPink = UIColor(red: 243/255, green: 188/255, blue: 205/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
        customizeTabBar()
    }
    
    func setupTabBar() {
        // Since I created view controllers in the storyboard, I created a storyboard object for VC instantiations for the tab bar views
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Home, Menu, Cart, and Log in tab bar views are instantiated for the tab bar
        
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "storefront"), tag: 0)
        
        let menuVC = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        let menuNav = UINavigationController(rootViewController: menuVC)
        menuVC.tabBarItem = UITabBarItem(title: "Cookie Menu", image: UIImage(systemName: "list.bullet"), tag: 1)
        
        let cartVC = CartViewController()
        let cartNav = UINavigationController(rootViewController: cartVC)
        cartNav.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart"), tag: 2)

        let loginVC = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        loginVC.tabBarItem = UITabBarItem(title: "Log In", image: UIImage(systemName: "person"), tag: 3)
        
        // Customizes the navigation bars to my custom pink theme
        let navControllers = [homeNav, menuNav, cartNav]
            for navController in navControllers {
                navController.navigationBar.tintColor = customPink
                
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = customPink
                appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
                appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: customPink]
                navController.navigationBar.tintColor = .white
                
                navController.navigationBar.standardAppearance = appearance
                navController.navigationBar.scrollEdgeAppearance = appearance
            }
        
        self.viewControllers = [homeVC, menuNav, cartNav, loginVC]
    }
    
    // Customizes main tab bar items
    func customizeTabBar() {
        let appearance = UITabBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        appearance.stackedLayoutAppearance.selected.iconColor = customPink
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: customPink]
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.black
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
    }
}
