//
//  AddMedViewController.swift
//  pilly
//
//  Created by Samantha Ranjo on 10/29/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol AddMedViewControllerDelegate: AnyObject {
    func delegateOnAddMed(med: Med)
}

class AddMedViewController: UIViewController {
    
    var selectedTime = Date()
    var currentUser: FirebaseAuth.User?
    let db = Firestore.firestore()
    var selectFrequency = "Daily"
    var selectDosage = "mg"
    let addMedScreen = AddMedView()
    weak var delegate: AddMedViewControllerDelegate?
    
    override func loadView() {
        view = addMedScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Medication"
        
        addMedScreen.pickerFrequency.menu = getFrequentType()
        addMedScreen.pcikerDosage.menu = getDosagetype()
        addMedScreen.buttonAdd.addTarget(self, action: #selector(onAddButtonTapped), for: .touchUpInside)
    }
    
    func getFrequentType() -> UIMenu {
        var menuItems = [UIAction]()
        
        for type in Frequency.allFrequencies {
            let menuItem = UIAction(title: type.rawValue, handler: { (_) in
                self.selectFrequency = type.rawValue
                self.addMedScreen.pickerFrequency.setTitle(self.selectFrequency, for: .normal)
            })
            menuItems.append(menuItem)
        }
        
        return UIMenu(title: "Select Frequency", children: menuItems)
    }
    
    func getDosagetype() -> UIMenu {
        var menuItems = [UIAction]()
        
        for type in Dosage.allDosages {
            let menuItem = UIAction(title: type.rawValue, handler: { (_) in
                self.selectDosage = type.rawValue
                self.addMedScreen.pcikerDosage.setTitle(self.selectDosage, for: .normal)
            })
            menuItems.append(menuItem)
        }
        
        return UIMenu(title: "Select Dosage", children: menuItems)
    }
    
    @objc func onAddButtonTapped() {
        let name = addMedScreen.textFieldTitle.text
        let dosageAmount = addMedScreen.textFieldDosage.text
        
        selectedTime = addMedScreen.pickerTime.date
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let formattedTime = timeFormatter.string(from: selectedTime)
        
        if let unwrappedName = name, let unwrappedDosageAmount = dosageAmount,
           let dosageEnum = Dosage(rawValue: selectDosage),
           let frequencyEnum = Frequency(rawValue: selectFrequency) {
            
            if !unwrappedName.isEmpty, !unwrappedDosageAmount.isEmpty {
                let newMed = Med(
                    title: unwrappedName,
                    amount: unwrappedDosageAmount,
                    dosage: dosageEnum,
                    frequency: frequencyEnum,
                    time: formattedTime,
                    isChecked: false
                )
                
                saveMedicationToDatabase(med: newMed) { [weak self] success in
                    DispatchQueue.main.async {
                        if success {
                            self?.delegate?.delegateOnAddMed(med: newMed)
                            self?.showSuccessAlert(message: "Medication added successfully") {
                                self?.navigationController?.popViewController(animated: true)
                            }
                            self?.clearFormFields()
                        } else {
                            self?.showAlert(message: "Failed to save medication to database.")
                        }
                    }
                }
            } else {
                showAlert(message: "Please fill in all fields.")
            }
        } else {
            showAlert(message: "Please select valid dosage and frequency.")
        }
    }
    
    func saveMedicationToDatabase(med: Med, completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("No user is logged in")
            completion(false)
            return
        }
        
        let medData: [String: Any] = [
            "title": med.title!,
            "amount": med.amount!,
            "dosage": med.dosage?.rawValue as Any,
            "frequency": med.frequency?.rawValue as Any,
            "time": med.time!,
            "completionDates": [:],  // Initialize empty completion dates map
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        print("Attempting to save medication: \(medData)")
        
        db.collection("users").document(user.uid).collection("medications").addDocument(data: medData) { error in
            if let error = error {
                print("Error saving medication: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Medication successfully saved!")
                completion(true)
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Input Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showSuccessAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    func clearFormFields() {
        addMedScreen.textFieldTitle.text = ""
        addMedScreen.textFieldDosage.text = ""
        addMedScreen.pickerTime.setDate(Date(), animated: true)
        addMedScreen.pickerFrequency.setTitle("How Often?", for: .normal)
        addMedScreen.pcikerDosage.setTitle("Dosage Amount?", for: .normal)
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension AddMedViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Utilities.times.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == addMedScreen.pickerFrequency {
            let selectedFrequency = Frequency.allFrequencies[row]
            selectFrequency = selectedFrequency.rawValue
            addMedScreen.pickerFrequency.setTitle(selectFrequency, for: .normal)
        } else if pickerView == addMedScreen.pcikerDosage {
            let selectedDosage = Dosage.allDosages[row]
            selectDosage = selectedDosage.rawValue
            addMedScreen.pcikerDosage.setTitle(selectDosage, for: .normal)
        }
    }
}
