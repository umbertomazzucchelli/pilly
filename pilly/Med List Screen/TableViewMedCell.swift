//
//  TableViewMedCell.swift
//  pilly
//
//  Created by Samantha Ranjo on 10/29/24.
//

import UIKit

class TableViewMedCell: UITableViewCell {
    static let identifier = "TableViewMedCell"
    var backgroundCardView: UIView!
    var labelTitle: UILabel!
    var labelAmount: UILabel!
    var labelDosage: UILabel!
    var labelFrequency: UILabel!
    var labelTime: UILabel!
    var checkboxButton: UIButton!
    var isChecked: Bool = false
    var onChecklistToggle: (() -> Void)?
    var currentDate: Date = Date()

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

        labelAmount = UILabel()
        labelAmount.font = UIFont.systemFont(ofSize: 14)
        labelAmount.textColor = .darkGray
        labelAmount.translatesAutoresizingMaskIntoConstraints = false
        
        labelDosage = UILabel()
        labelDosage.font = UIFont.systemFont(ofSize: 14)
        labelDosage.textColor = .darkGray
        labelDosage.translatesAutoresizingMaskIntoConstraints = false
        
        labelFrequency = UILabel()
        labelFrequency.font = UIFont.systemFont(ofSize: 14)
        labelFrequency.textColor = .darkGray
        labelFrequency.translatesAutoresizingMaskIntoConstraints = false
        
        labelTime = UILabel()
        labelTime.font = UIFont.systemFont(ofSize: 14)
        labelTime.textColor = .darkGray
        labelTime.translatesAutoresizingMaskIntoConstraints = false

        backgroundCardView.addSubview(labelTitle)
        backgroundCardView.addSubview(labelAmount)
        backgroundCardView.addSubview(labelDosage)
        backgroundCardView.addSubview(labelFrequency)
        backgroundCardView.addSubview(labelTime)
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
        onChecklistToggle?()
        updateLabelAppearance()
    }

    private func updateLabelAppearance() {
        if isChecked {
            labelTitle.textColor = .gray
            labelAmount.textColor = .gray
            labelDosage.textColor = .gray
            let attributeString = NSMutableAttributedString(string: labelTitle.text ?? "")
            attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
            labelTitle.attributedText = attributeString
        } else {
            labelTitle.textColor = .black
            labelAmount.textColor = .darkGray
            labelDosage.textColor = .darkGray
            labelTitle.attributedText = nil
            labelTitle.text = labelTitle.text
        }
    }

    func configure(with med: Med, for date: Date) {
        self.currentDate = date
        
        guard let title = med.title else {
            labelTitle.text = "Untitled"
            return
        }

        labelTitle.text = title
        labelAmount.text = med.amount
        
        if let dosageString = med.dosage {
            labelDosage.text = dosageString.rawValue
        } else {
            labelDosage.text = "Unknown dosage"
        }

        labelFrequency.text = med.frequency?.rawValue
        labelTime.text = med.time
        
        isChecked = med.isCompleted(for: date)
        checkboxButton.isSelected = isChecked
        
        updateLabelAppearance()
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

            labelAmount.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 4),
            labelAmount.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelAmount.trailingAnchor.constraint(equalTo: labelTitle.trailingAnchor),

            labelDosage.topAnchor.constraint(equalTo: labelAmount.bottomAnchor, constant: 4),
            labelDosage.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelDosage.trailingAnchor.constraint(equalTo: labelTitle.trailingAnchor),

            labelFrequency.topAnchor.constraint(equalTo: labelDosage.bottomAnchor, constant: 4),
            labelFrequency.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelFrequency.trailingAnchor.constraint(equalTo: labelTitle.trailingAnchor),

            labelTime.topAnchor.constraint(equalTo: labelFrequency.bottomAnchor, constant: 4),
            labelTime.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelTime.trailingAnchor.constraint(equalTo: labelTitle.trailingAnchor),
            labelTime.bottomAnchor.constraint(equalTo: backgroundCardView.bottomAnchor, constant: -8),

            checkboxButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkboxButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkboxButton.widthAnchor.constraint(equalToConstant: 32),
            checkboxButton.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
}
