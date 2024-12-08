import UIKit

class ProfileViewController: UIViewController {
    
    let profileView = ProfileView()
    
    override func loadView() {
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonActions()
        
        // Load pharmacy data on initial load
        profileView.updateFavoritePharmacy()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh pharmacy data when view appears
        profileView.updateFavoritePharmacy()
        
        // Add observer for pharmacy updates
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePharmacyUpdate),
            name: .favoritePharmacyUpdated,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupButtonActions() {
        profileView.myPharmacyButton.addTarget(self, action: #selector(onPharmacyButtonTapped), for: .touchUpInside)
        profileView.personalInfoButton.addTarget(self, action: #selector(onPersonalInfoButtonTapped), for: .touchUpInside)
        profileView.settingsButton.addTarget(self, action: #selector(onSettingsButtonTapped), for: .touchUpInside)
    }
    
    @objc func onPharmacyButtonTapped() {
        let pharmacyVC = PharmacyViewController()
        navigationController?.pushViewController(pharmacyVC, animated: true)
    }
    
    @objc func onPersonalInfoButtonTapped() {
        navigationController?.pushViewController(PersonalInfoViewController(), animated: true)
    }
    
    @objc func onSettingsButtonTapped() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc private func handlePharmacyUpdate() {
        profileView.updateFavoritePharmacy()
    }
}
