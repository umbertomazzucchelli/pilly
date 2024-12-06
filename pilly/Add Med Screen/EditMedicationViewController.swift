//
//  EditMedicationViewController.swift
//  pilly
//
//  Created by Belen Tesfaye on 12/6/24.
//

import Firebase
import UIKit

class EditMedicationViewController: UIViewController {

    var selectedMedication: Med?

    var textFieldTitle: UITextField!
    var textFieldAmount: UITextField!
    var labelTime: UILabel!
    var pickerTime: UIDatePicker!
    var pickerFrequency: UIButton!
    var pickerDosage: UIButton!
    var updateButton: UIButton!
    var selectFrequency = "Daily"
    var selectDosage = "mg"
    let notificationCenter = NotificationCenter.default


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        populateFields()
    }

    func setupUI() {
        setupTextFieldTitle()
        setupTextFieldDosage()
        setupLabelTime()
        setupPickerTime()
        setupButtonAdd()
        setupFrequency()
        setupDosage()

        initConstraints()
    }

    func setupTextFieldTitle() {
        textFieldTitle = UITextField()
        textFieldTitle.placeholder = "Name"
        textFieldTitle.borderStyle = .roundedRect
        textFieldTitle.font = UIFont(name: "ComicSansMS", size: 16)
        textFieldTitle.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textFieldTitle)
    }

    func setupTextFieldDosage() {
        textFieldAmount = UITextField()
        textFieldAmount.placeholder = "Amount"
        textFieldAmount.borderStyle = .roundedRect
        textFieldAmount.font = UIFont(name: "ComicSansMS", size: 16)
        textFieldAmount.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textFieldAmount)
    }

    func setupLabelTime() {
        labelTime = UILabel()
        labelTime.text = "Time"
        labelTime.font = UIFont(name: "ComicSansMS", size: 16)
        labelTime.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(labelTime)
    }

    func setupPickerTime() {
        pickerTime = UIDatePicker()
        pickerTime.datePickerMode = .time
        pickerTime.preferredDatePickerStyle = .wheels
        pickerTime.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pickerTime)
    }

    func setupFrequency() {
        pickerFrequency = UIButton(type: .system)
        pickerFrequency.setTitle("How Often?", for: .normal)
        pickerFrequency.titleLabel?.font = UIFont(name: "ComicSansMS", size: 16)
        pickerFrequency.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pickerFrequency)

        pickerFrequency.addAction(
            UIAction(handler: { _ in
                self.pickerFrequency.menu = self.getFrequentType()
                self.pickerFrequency.showsMenuAsPrimaryAction = true
            }), for: .touchUpInside)
    }

    func setupDosage() {
        pickerDosage = UIButton(type: .system)
        pickerDosage.setTitle("Dosage Amount?", for: .normal)
        pickerDosage.titleLabel?.font = UIFont(name: "ComicSansMS", size: 16)
        pickerDosage.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pickerDosage)

        // Add action to show the menu when tapped
        pickerDosage.addAction(
            UIAction(handler: { _ in
                self.pickerDosage.menu = self.getDosagetype()
                self.pickerDosage.showsMenuAsPrimaryAction = true
            }), for: .touchUpInside)
    }

    //    func setupDosage() {
    //        pickerDosage = UIButton(type: .system)
    //        pickerDosage.setTitle("Dosage Amount?", for: .normal)
    //        pickerDosage.titleLabel?.font = UIFont(name: "ComicSansMS", size: 16)
    //        pickerDosage.translatesAutoresizingMaskIntoConstraints = false
    //        self.view.addSubview(pickerDosage)
    //    }

    func setupButtonAdd() {
        updateButton = UIButton(type: .system)
        updateButton.setTitle("Update", for: .normal)
        updateButton.titleLabel?.font = UIFont(name: "ComicSansMS", size: 16)
        updateButton.addTarget(
            self, action: #selector(updateMedication), for: .touchUpInside)
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(updateButton)
    }

    func getFrequentType() -> UIMenu {
        var menuItems = [UIAction]()

        for type in Frequency.allFrequencies {
            let menuItem = UIAction(
                title: type.rawValue,
                handler: { (_) in
                    self.selectFrequency = type.rawValue
                    self.pickerFrequency.setTitle(
                        self.selectFrequency, for: .normal)
                })
            menuItems.append(menuItem)
        }

        return UIMenu(title: "Select Frequency", children: menuItems)
    }

    func getDosagetype() -> UIMenu {
        var menuItems = [UIAction]()

        for type in Dosage.allDosages {
            let menuItem = UIAction(
                title: type.rawValue,
                handler: { (_) in
                    self.selectDosage = type.rawValue
                    self.pickerDosage.setTitle(self.selectDosage, for: .normal)
                })
            menuItems.append(menuItem)
        }

        return UIMenu(title: "Select Dosage", children: menuItems)
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            textFieldTitle.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32),
            textFieldTitle.centerXAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            textFieldTitle.widthAnchor.constraint(equalToConstant: 300),
            textFieldTitle.heightAnchor.constraint(equalToConstant: 50),

            textFieldAmount.topAnchor.constraint(
                equalTo: textFieldTitle.bottomAnchor, constant: 16),
            textFieldAmount.centerXAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            textFieldAmount.widthAnchor.constraint(equalToConstant: 300),
            textFieldAmount.heightAnchor.constraint(equalToConstant: 50),

            pickerFrequency.topAnchor.constraint(
                equalTo: textFieldAmount.bottomAnchor, constant: 16),
            pickerFrequency.centerXAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),

            pickerDosage.topAnchor.constraint(
                equalTo: pickerFrequency.bottomAnchor, constant: 16),
            pickerDosage.centerXAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),

            labelTime.topAnchor.constraint(
                equalTo: pickerDosage.bottomAnchor, constant: 16),
            labelTime.centerXAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),

            pickerTime.topAnchor.constraint(
                equalTo: labelTime.bottomAnchor, constant: 16),
            pickerTime.centerXAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),

            updateButton.topAnchor.constraint(
                equalTo: pickerTime.bottomAnchor, constant: 16),
            updateButton.centerXAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }

    func populateFields() {
        if let medication = selectedMedication {
            textFieldTitle.text = medication.title ?? ""
            textFieldAmount.text = medication.amount ?? ""

            if let frequency = medication.frequency {
                selectFrequency = frequency.rawValue
            } else {
                selectFrequency = "Daily"
            }
            pickerFrequency.setTitle(selectFrequency, for: .normal)

            if let dosage = medication.dosage {
                selectDosage = dosage.rawValue
            } else {
                selectDosage = "mg"
            }
            pickerDosage.setTitle(selectDosage, for: .normal)
            if let time = medication.time {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                if let timeDate = formatter.date(from: time) {
                    pickerTime.date = timeDate
                }
            }
        }
    }

    @objc func updateMedication() {
        guard let updatedTitle = textFieldTitle.text,
            let updatedAmountString = textFieldAmount.text,
            let selectedMedication = selectedMedication
        else {
            print("Error: Medication data is missing")
            return
        }

        // Ensure updatedDosage is valid
        guard let updatedDosage = Dosage(rawValue: selectDosage) else {
            print("Error: Invalid dosage")
            return
        }

        let updatedFrequency = selectFrequency
        let updatedTime = formattedTime(from: pickerTime.date)

        if let medicationId = selectedMedication.id {
            let db = Firestore.firestore()
            let user = Auth.auth().currentUser!
            let medicationRef = db.collection("users").document(user.uid)
                .collection("medications").document(medicationId)

            medicationRef.updateData([
                "title": updatedTitle,
                "amount": updatedAmountString,
                "dosage": updatedDosage.rawValue,
                "frequency": updatedFrequency,
                "time": updatedTime,
            ]) { error in
                if let error = error {
                    print("Error updating medication: \(error)")
                } else {
//                    NotificationCenter.default.post(name: .medicationsUpdated, object: updatedMeds)
                    print("Medication updated successfully.")
                    self.showSuccessAlert()
                }
            }
        }
    }

    func showSuccessAlert() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(
                title: "Success", message: "Medication updated successfully.",
                preferredStyle: .alert)

            let goBackAction = UIAlertAction(title: "Go Back", style: .default)
            { _ in
                self.navigationController?.popViewController(animated: true)
            }
            let refreshAction = UIAlertAction(title: "Refresh", style: .default)
            { _ in
                self.populateFields()
            }

            alertController.addAction(goBackAction)
            alertController.addAction(refreshAction)

            self.present(alertController, animated: true, completion: nil)
        }
    }

    func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
