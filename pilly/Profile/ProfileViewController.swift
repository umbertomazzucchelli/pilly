import UIKit

class ProfileViewController: UIViewController {
    
    let profileView = ProfileView()
    
    override func loadView() {
        view = profileView
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //profileView.myPharmacyButton.setImage(UIImage(systemName: <#T##String#>), for: <#T##UIControl.State#>)
        profileView.myPharmacyButton.addTarget(self, action: #selector(onPharmacyButtonTapped), for: .touchUpInside)
        profileView.personalInfoButton.addTarget(self, action: #selector(onPersonalInfoButtonTapped), for: .touchUpInside)
        profileView.settingsButton.addTarget(self, action: #selector(onSettingsButtonTapped), for: .touchUpInside)
    }
    
    @objc func onPharmacyButtonTapped () {
        navigationController?.pushViewController(PharmacyViewController(), animated: true)
    }
    @objc func onPersonalInfoButtonTapped() {
        navigationController?.pushViewController(PersonalInfoViewController(), animated: true)
    }
    @objc func onSettingsButtonTapped() {
        // Push the SettingsViewController onto the navigation stack
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }


}

