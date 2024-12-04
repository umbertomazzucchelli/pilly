import UIKit

class SettingsView: UIView {

    // Example UI elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let toggleSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    // Logout Button
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // Action closure for the logout button
    var logoutAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    // Configure the layout of subviews
    private func setupLayout() {
        backgroundColor = .white
        
        // Add subviews
        addSubview(titleLabel)
        addSubview(toggleSwitch)
        addSubview(logoutButton)
        
        // Set constraints
        NSLayoutConstraint.activate([
            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            // Toggle Switch Constraints
            toggleSwitch.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            toggleSwitch.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // Logout Button Constraints
            logoutButton.topAnchor.constraint(equalTo: toggleSwitch.bottomAnchor, constant: 40),
            logoutButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        // Add target to the logout button
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    // Action method for the logout button
    @objc private func logoutButtonTapped() {
        logoutAction?()
    }
}
