import UIKit
import FirebaseAuth // Assuming you're using Firebase Auth for authentication

class SettingsViewController: UIViewController {
    
    let logoutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Settings"
        
        // Setup the logout button
        setupLogoutButton()
    }
    
    func setupLogoutButton() {
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(.blue, for: .normal)
        logoutButton.addTarget(self, action: #selector(onLogoutButtonTapped), for: .touchUpInside)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        // Constraints for the logout button
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func onLogoutButtonTapped() {
        // Perform Firebase logout
        do {
            try Auth.auth().signOut()
            
            // Handle the logout action and navigate back to the ViewController
            DispatchQueue.main.async {
                let mainVC = ViewController()  // Your initial ViewController
                let navigationController = UINavigationController(rootViewController: mainVC)
                self.view.window?.rootViewController = navigationController
                self.view.window?.makeKeyAndVisible()
            }
        } catch {
            // Handle any errors during sign out
            showAlert(message: "Error signing out")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
