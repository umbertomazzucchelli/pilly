//
//  AddMedViewController.swift
//  pilly
//
//  Created by Samantha Ranjo on 10/29/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase



class AddMedViewController: UIViewController {
    
    // delegate to ViewController when getting back
//    var delegate:ViewController!
    
//    var selectedTime = "Morning"
    var selectedTime = Date()
    
    var currentUser: FirebaseAuth.User?
    let db = Firestore.firestore()
    
    var selectFrequency = "Daily"
    
    var selectDosage = "mg"
    
    let addMedScreen = AddMedView()
    var delegate:ViewController!
    
    override func loadView() {
        view = addMedScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Medication"
        
        // patching delegate and datasource of type PickerView
//        addMedScreen.pickerTime.delegate = self
//        addMedScreen.pickerTime.dataSource = self
        
        // adding action for tapping on buttonAdd
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

        // Format the selected time
        selectedTime = addMedScreen.pickerTime.date
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let formattedTime = timeFormatter.string(from: selectedTime)
        print("Button tapped. Validating inputs...")

        // Validate inputs
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
                
                // Proceed with saving medication only if inputs are valid
                saveMedicationToDatabase(med: newMed) { [weak self] success in
                    DispatchQueue.main.async {
                        if success {
                            // Only call delegate and show success alert if saving is successful
                            self?.delegate?.delegateOnAddMed(med: newMed)
                            self?.showSuccessAlert(message: "Success to save medication to database.") // Updated
                            self?.clearFormFields()
                            
                            self?.navigationController?.popViewController(animated: true)
                        } else {
                            // If saving fails, show an error
                            self?.showAlert(message: "Failed to save medication to database.")
                        }
                    }
                }
            } else {
                // Show input error if fields are empty
                DispatchQueue.main.async {
                    self.showAlert(message: "Please fill in all fields.")
                }
            }
        } else {
            // Show error if dosage or frequency is invalid
            DispatchQueue.main.async {
                self.showAlert(message: "Please select valid dosage and frequency.")
            }
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Input Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func showSuccessAlert(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    func saveMedicationToDatabase(med: Med, completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("No user is logged in") // Log if the user is not logged in
            completion(false)
            return
        }
        
        let medData: [String: Any] = [
            "title": med.title!,
            "amount": med.amount!,
            "dosage": med.dosage?.rawValue as Any,
            "frequency": med.frequency?.rawValue as Any,
            "time": med.time!,
            "isChecked": med.isChecked,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        print("Attempting to save medication: \(medData)")  // Log what you're trying to save
        
        db.collection("users").document(user.uid).collection("medications").addDocument(data: medData) { error in
            if let error = error {
                print("Error saving medication: \(error.localizedDescription)") // Log Firestore error
                completion(false)
            } else {
                print("Medication successfully saved!")  // Log successful save
                completion(true)
            }
        }
    }

    func showSuccessAlert() {
           let alert = UIAlertController(title: "Success", message: "Medication added successfully!", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
       
       func clearFormFields() {
           addMedScreen.textFieldTitle.text = ""
           addMedScreen.textFieldDosage.text = ""
           addMedScreen.pickerTime.setDate(Date(), animated: true)
       }
//    func updateSelectedTime(for timeString: String) {
//        let calendar = Calendar.current
//        var components = DateComponents()
//
//        switch timeString {
//        case "Morning":
//            components.hour = 8
//            components.minute = 0
//        case "Afternoon":
//            components.hour = 12
//            components.minute = 0
//        case "Evening":
//            components.hour = 18
//            components.minute = 0
//        default:
//            components.hour = 0
//            components.minute = 0
//        }
//
//        selectedTime = calendar.date(from: components) ?? Date()
//    }


}

// adopting required protocols
extension AddMedViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // Returning count of available times
        return Utilities.times.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == addMedScreen.pickerFrequency {
            let selectedFrequency = Frequency.allFrequencies[row]  // Get the enum value
            selectFrequency = selectedFrequency.rawValue  // Use rawValue to get the string representation
            addMedScreen.pickerFrequency.setTitle(selectFrequency, for: .normal)
        } else if pickerView == addMedScreen.pcikerDosage {
            let selectedDosage = Dosage.allDosages[row]  // Get the enum value
            selectDosage = selectedDosage.rawValue  // Use rawValue to get the string representation
            addMedScreen.pcikerDosage.setTitle(selectDosage, for: .normal)
        }
    }


}
