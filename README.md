# 🍪 Cookie Store App

An iOS UIKit application that simulates a cookie store — allowing users to browse, purchase, and track cookie orders. Built as part of a midterm project at Seneca Polytechnic, this app demonstrates end-to-end mobile app functionality including navigation, data handling, and user session management.

---

## 🚀 Features

- 🛍️ **Browse Cookies** — View different categories (classic, specialty, seasonal)
- 🧁 **Product Details** — Check price, variant, and quantity before purchase
- 🛒 **Shopping Cart** — Add, remove, and edit cookie items before checkout
- 📦 **Order History** — Displays past purchases grouped by user
- 👤 **Login/Logout System** — Switch between multiple user accounts
- 🎨 **Custom UI Theme** — Pink-themed tab bar and clean layout using UIKit

---

## 🧩 Technologies Used

- **Language:** Swift 5  
- **Framework:** UIKit (Programmatic UI)  
- **Architecture:** MVC  
- **Data Handling:** Singleton (`DataManager`)  
- **UI Components:** UITableView, UINavigationController, UIAlertController  
- **Design Tools:** Auto Layout, Stack Views  

---

## 🧠 Project Flow

1. **ItemListViewController** → Displays cookies by category  
2. **PurchaseViewController** → Select variant and quantity  
3. **CartViewController** → Review selected items  
4. **OrderHistoryViewController** → Shows all past purchases  
5. **AccountViewController / LogInViewController** → User management  

Data is shared across views using the `DataManager` singleton.

---

## 🧁 App Preview

> *(Add screenshots or screen recording links here later)*  
> You can use the “Upload files” option on GitHub to include images like `screenshots/home.png` and `screenshots/cart.png`.

---

## 👩‍💻 Author

**Andrea Selina Perez**  
📍 Seneca Polytechnic – Computer Programming (iOS & Data Structures focus)  
📫 [andreaselinaperez26@gmail.com](mailto:andreaselinaperez26@gmail.com)  
🌐 [GitHub Profile](https://github.com/asperez26)

---

⭐ *If you liked this project, consider giving it a star on GitHub!*
