import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupTabBarAppearance()
    }
    
    private func setupTabs() {
        // Create view controllers for each tab
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let calendarVC = UINavigationController(rootViewController: CalendarViewController())
        let medicationsVC = UINavigationController(rootViewController: AddMedViewController())
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        
        // Configure tab bar items
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        calendarVC.tabBarItem = UITabBarItem(
            title: "Calendar",
            image: UIImage(systemName: "calendar"),
            selectedImage: UIImage(systemName: "calendar.fill")
        )
        
        medicationsVC.tabBarItem = UITabBarItem(
            title: "Medications",
            image: UIImage(systemName: "pill"),
            selectedImage: UIImage(systemName: "pill.fill")
        )
        
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        // Set the view controllers
        setViewControllers([homeVC, calendarVC, medicationsVC, profileVC], animated: false)
    }
    
    private func setupTabBarAppearance() {
        // Set the tab bar background color to match your design
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 179/255, green: 235/255, blue: 242/255, alpha: 1)
        
        // Configure item appearance
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.stackedLayoutAppearance = itemAppearance
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
