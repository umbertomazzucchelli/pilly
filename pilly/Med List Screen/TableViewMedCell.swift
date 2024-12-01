//
//  TableViewMedCell.swift
//  pilly
//
//  Created by Samantha Ranjo on 10/29/24.
//

import UIKit

class TableViewMedCell: UITableViewCell {
    var backgroundCardView: UIView!
    var labelTitle: UILabel!
    var labelDosage: UILabel!
    var checkboxButton: UIButton!
    var isChecked: Bool = false

    // Closure to notify the parent view about the toggle
    var onChecklistToggle: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBackgroundCardView()
        setupLabels()
        setupCheckboxButton()
        initConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupBackgroundCardView() {
        backgroundCardView = UIView()
        backgroundCardView.backgroundColor = UIColor.systemPink.withAlphaComponent(0.3)
        backgroundCardView.layer.cornerRadius = 10
        backgroundCardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundCardView)
    }

    func setupLabels() {
        labelTitle = UILabel()
        labelTitle.font = UIFont.boldSystemFont(ofSize: 16)
        labelTitle.textColor = .black
        labelTitle.translatesAutoresizingMaskIntoConstraints = false

        labelDosage = UILabel()
        labelDosage.font = UIFont.systemFont(ofSize: 14)
        labelDosage.textColor = .darkGray
        labelDosage.translatesAutoresizingMaskIntoConstraints = false

        backgroundCardView.addSubview(labelTitle)
        backgroundCardView.addSubview(labelDosage)
    }

    func setupCheckboxButton() {
        checkboxButton = UIButton()
        checkboxButton.setImage(UIImage(systemName: "circle"), for: .normal)
        checkboxButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        checkboxButton.tintColor = .systemBlue
        checkboxButton.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkboxButton)
    }

    @objc func toggleCheckbox() {
        isChecked.toggle()
        checkboxButton.isSelected = isChecked
        onChecklistToggle?() // Notify the parent view about the change

        if isChecked {
            labelTitle.textColor = .gray
            labelDosage.textColor = .gray
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: labelTitle.text ?? "")
            attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
            labelTitle.attributedText = attributeString
        } else {
            labelTitle.textColor = .black
            labelDosage.textColor = .darkGray
            labelTitle.attributedText = nil
            labelTitle.text = labelTitle.text // Reset text
        }
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            backgroundCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            backgroundCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            backgroundCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backgroundCardView.trailingAnchor.constraint(equalTo: checkboxButton.leadingAnchor, constant: -8),

            labelTitle.topAnchor.constraint(equalTo: backgroundCardView.topAnchor, constant: 8),
            labelTitle.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 8),
            labelTitle.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -8),

            labelDosage.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 4),
            labelDosage.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelDosage.trailingAnchor.constraint(equalTo: labelTitle.trailingAnchor),
            labelDosage.bottomAnchor.constraint(equalTo: backgroundCardView.bottomAnchor, constant: -8),

            checkboxButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkboxButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkboxButton.widthAnchor.constraint(equalToConstant: 32),
            checkboxButton.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
}

extension TableViewMedCell {
    func configure(with med: Med) {
        guard let title = med.title else {
            labelTitle.text = "Untitled" // Provide a default value if `title` is `nil`
            return
        }

        labelTitle.text = title
        labelDosage.text = "\(med.dosage) at \(med.time)"
        checkboxButton.isSelected = med.isChecked
        isChecked = med.isChecked

        if med.isChecked {
            labelTitle.textColor = .gray
            labelDosage.textColor = .gray
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: title)
            attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
            labelTitle.attributedText = attributeString
        } else {
            labelTitle.textColor = .black
            labelDosage.textColor = .darkGray
            labelTitle.attributedText = nil
            labelTitle.text = title
        }
    }
}
