//
//  AppDelegate.swift
//  pilly
//
//  Created by Belen Tesfaye on 10/24/24.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure Firebase first
        FirebaseApp.configure()
        AuthManager.shared.configure() // Initialize AuthManager
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Set initial view controller based on auth state
        if AuthManager.shared.isUserLoggedIn {
            let mainTabBarController = MainTabBarController()
            window?.rootViewController = mainTabBarController
        } else {
            let initialViewController = LoginViewController()
            let navigationController = UINavigationController(rootViewController: initialViewController)
            window?.rootViewController = navigationController
        }
        
        window?.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
