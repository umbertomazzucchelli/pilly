//
//  AddMedView.swift
//  pilly
//
//  Created by Samantha Ranjo on 10/29/24.
//

import UIKit

class AddMedView: UIView {
    
    var textFieldTitle: UITextField!
    var textFieldDosage: UITextField!
    var labelTime: UILabel!
    var pickerTime: UIDatePicker!
    var pickerFrequency: UIButton!
    var pcikerDosage: UIButton!
    var buttonAdd: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupTextFieldTitle()
        setupTextFieldDosage()
        setupLabelTime()
        setupPickerTime()
        setupButtonAdd()
        
        setupFrequency()
        setupDosage()
        
        initConstraints()
    }
    
    func setupFrequency() {
        pickerFrequency = UIButton(type: .system)
        pickerFrequency.setTitle("How Often?", for: .normal)
        pickerFrequency.titleLabel?.font = UIFont(name: "ComicSansMS", size: 16)
        pickerFrequency.showsMenuAsPrimaryAction = true
        pickerFrequency.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pickerFrequency)
    }
    
    func setupDosage() {
        pcikerDosage = UIButton(type: .system)
        pcikerDosage.setTitle("Dosage Amount?", for: .normal)
        pcikerDosage.titleLabel?.font = UIFont(name: "ComicSansMS", size: 16)
        pcikerDosage.showsMenuAsPrimaryAction = true
        pcikerDosage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pcikerDosage)
    }
    
    // Initialize UI elements
    func setupTextFieldTitle() {
        textFieldTitle = UITextField()
        textFieldTitle.placeholder = "Name"
        textFieldTitle.borderStyle = .roundedRect
        textFieldTitle.font = UIFont(name: "ComicSansMS", size: 16)
        textFieldTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldTitle)
    }
    
    func setupTextFieldDosage() {
        textFieldDosage = UITextField()
        textFieldDosage.placeholder = "Dosage"
        textFieldDosage.borderStyle = .roundedRect
        textFieldDosage.font = UIFont(name: "ComicSansMS", size: 16)
        textFieldDosage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldDosage)
    }
    
    func setupLabelTime() {
        labelTime = UILabel()
        labelTime.text = "Time"
        labelTime.font = UIFont(name: "ComicSansMS", size: 16)
        labelTime.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelTime)
    }
    
    func setupPickerTime() {
        pickerTime = UIDatePicker()
        pickerTime.datePickerMode = .time
        pickerTime.preferredDatePickerStyle = .wheels
        pickerTime.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pickerTime)
    }
    
    func setupButtonAdd() {
        buttonAdd = UIButton(type: .system)
        buttonAdd.setTitle("Add", for: .normal)
        buttonAdd.titleLabel?.font = UIFont(name: "ComicSansMS", size: 16)
        buttonAdd.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonAdd)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([

            textFieldTitle.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            textFieldTitle.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldTitle.widthAnchor.constraint(equalToConstant: 300),
            textFieldTitle.heightAnchor.constraint(equalToConstant: 50),


            textFieldDosage.topAnchor.constraint(equalTo: textFieldTitle.bottomAnchor, constant: 16),
            textFieldDosage.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldDosage.widthAnchor.constraint(equalToConstant: 300),
            textFieldDosage.heightAnchor.constraint(equalToConstant: 50),


            pickerFrequency.topAnchor.constraint(equalTo: textFieldDosage.bottomAnchor, constant: 16),
            pickerFrequency.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
        
            pcikerDosage.topAnchor.constraint(equalTo: pickerFrequency.bottomAnchor, constant: 16),
            pcikerDosage.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),


            labelTime.topAnchor.constraint(equalTo: pcikerDosage.bottomAnchor, constant: 16),
            labelTime.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),

       
            pickerTime.topAnchor.constraint(equalTo: labelTime.bottomAnchor, constant: 16),
            pickerTime.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),

  
            buttonAdd.topAnchor.constraint(equalTo: pickerTime.bottomAnchor, constant: 16),
            buttonAdd.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
        ])
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
