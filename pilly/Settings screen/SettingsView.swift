import UIKit

class SettingsView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let resetPasswordButton: UIButton = {
        let button = createStyledButton(title: "Reset Password", iconName: "lock.reset")
        return button
    }()
    
    private let editMedicationButton: UIButton = {
        let button = createStyledButton(title: "Edit Medication", iconName: "pills")
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = createStyledButton(title: "Logout", iconName: "arrowshape.turn.up.left")
        return button
    }()

    var resetPasswordAction: (() -> Void)?
    var editMedicationAction: (() -> Void)?
    var logoutAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    private func setupLayout() {
        backgroundColor = .white
        
        // Add subviews
        addSubview(titleLabel)
        addSubview(resetPasswordButton)
        addSubview(editMedicationButton)
        addSubview(logoutButton)

        // Set constraints
        let buttonWidth: CGFloat = 231
        let buttonHeight: CGFloat = 55

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            resetPasswordButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            resetPasswordButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            resetPasswordButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            resetPasswordButton.heightAnchor.constraint(equalToConstant: buttonHeight),

            editMedicationButton.topAnchor.constraint(equalTo: resetPasswordButton.bottomAnchor, constant: 20),
            editMedicationButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            editMedicationButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            editMedicationButton.heightAnchor.constraint(equalToConstant: buttonHeight),

            logoutButton.topAnchor.constraint(equalTo: editMedicationButton.bottomAnchor, constant: 20),
            logoutButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            logoutButton.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])

        // Button Actions
        resetPasswordButton.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .touchUpInside)
        editMedicationButton.addTarget(self, action: #selector(editMedicationButtonTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }

    // Button Action Methods
    @objc private func resetPasswordButtonTapped() {
        resetPasswordAction?()
    }

    @objc private func editMedicationButtonTapped() {
        editMedicationAction?()
    }

    @objc private func logoutButtonTapped() {
        logoutAction?()
    }

    // Reusable Button Styling Method
    private static func createStyledButton(title: String, iconName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setImage(UIImage(systemName: iconName), for: .normal)
        button.titleLabel?.font = UIFont(name: "Comic Sans MS", size: 28)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 0.702, green: 0.922, blue: 0.949, alpha: 1)
        button.layer.cornerRadius = 5
        button.layer.shadowOffset = .zero
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
