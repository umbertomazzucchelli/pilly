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
    var buttonAdd: UIButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = .white
        
        setupTextFieldTitle()
        setupTextFieldDosage()
        setupLabelTime()
        setupPickerTime()
        setupButtonAdd()
        
        initConstraints()
    }
    
    // initialize UI elements
    func setupTextFieldTitle(){
        textFieldTitle = UITextField()
        textFieldTitle.placeholder = "Title"
        textFieldTitle.borderStyle = .roundedRect
        textFieldTitle.font = .systemFont(ofSize: 16)
        textFieldTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldTitle)
    }
    
    func setupTextFieldDosage(){
        textFieldDosage = UITextField()
        textFieldDosage.placeholder = "Dosage"
        textFieldDosage.borderStyle = .roundedRect
        textFieldDosage.font = .systemFont(ofSize: 16)
        textFieldDosage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldDosage)
    }
    
    func setupLabelTime(){
        labelTime = UILabel()
        labelTime.text = "Time"
        labelTime.font = .systemFont(ofSize: 16)
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

    
    func setupButtonAdd(){
        buttonAdd = UIButton(type: .system)
        buttonAdd.setTitle("Add", for: .normal)
        buttonAdd.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonAdd)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            textFieldTitle.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            textFieldTitle.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
                
            textFieldDosage.topAnchor.constraint(equalTo: textFieldTitle.bottomAnchor, constant: 16),
            textFieldDosage.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
                
            labelTime.topAnchor.constraint(equalTo: textFieldDosage.bottomAnchor, constant: 16),
            labelTime.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
                
            pickerTime.topAnchor.constraint(equalTo: labelTime.bottomAnchor, constant: 16),
            pickerTime.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
                
            buttonAdd.topAnchor.constraint(equalTo: pickerTime.bottomAnchor, constant: 16),
            buttonAdd.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    //MARK: unused methods...
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
