import UIKit
import FirebaseAuth // Assuming you're using Firebase Auth for authentication

class SettingsViewController: UIViewController {
    
    // Buttons for settings options
    let logoutButton = UIButton()
    let editProfileButton = UIButton()
    let editMedicineButton = UIButton()
    let editPasswordButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Settings"
        
        // Setup buttons
        setupButtons()
    }
    
    func setupButtons() {
        // Configure buttons
        configureButton(button: editProfileButton, title: "Edit Profile", action: #selector(onEditProfileTapped))
        configureButton(button: editMedicineButton, title: "Edit Medicine", action: #selector(onEditMedicineTapped))
        configureButton(button: editPasswordButton, title: "Edit Password", action: #selector(onEditPasswordTapped))
        configureButton(button: logoutButton, title: "Logout", action: #selector(onLogoutButtonTapped))
        
        // Add buttons to the view
        let stackView = UIStackView(arrangedSubviews: [editProfileButton, editMedicineButton, editPasswordButton, logoutButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // Constraints for stack view
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func configureButton(button: UIButton, title: String, action: Selector) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Button Actions
    
    @objc func onEditProfileTapped() {
        let editProfileVC = EditProfileViewController()
        navigationController?.pushViewController(editProfileVC, animated: true)
          
    }
    
    @objc func onEditMedicineTapped() {
        let editMedVC = MedicationListViewController()
        navigationController?.pushViewController(editMedVC, animated: true)
    }
    
    @objc func onEditPasswordTapped() {
        let editPasswordVC = EditPasswordViewController()
        navigationController?.pushViewController(editPasswordVC, animated: true)

    }
    
    @objc func onLogoutButtonTapped() {
        do {
            try Auth.auth().signOut()
            
            DispatchQueue.main.async {
                let mainVC = ViewController()  // Replace with your initial ViewController
                let navigationController = UINavigationController(rootViewController: mainVC)
                self.view.window?.rootViewController = navigationController
                self.view.window?.makeKeyAndVisible()
            }
        } catch {
            showAlert(message: "Error signing out")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

