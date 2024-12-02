//
//  AddMedViewController.swift
//  pilly
//
//  Created by Samantha Ranjo on 10/29/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol AddMedDelegate: AnyObject {
    func delegateOnAddMed(med: Med)
}


class AddMedViewController: UIViewController {
    
    // delegate to ViewController when getting back
//    var delegate:ViewController!
    
//    var selectedTime = "Morning"
    var selectedTime = Date()
    
    var currentUser: FirebaseAuth.User?
    
    let addMedScreen = AddMedView()
    var delegate:AddMedDelegate!
    
    override func loadView() {
        view = addMedScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // patching delegate and datasource of type PickerView
//        addMedScreen.pickerTime.delegate = self
//        addMedScreen.pickerTime.dataSource = self
        
        // adding action for tapping on buttonAdd
        addMedScreen.buttonAdd.addTarget(self, action: #selector(onAddButtonTapped), for: .touchUpInside)
    }
    
    @objc func onAddButtonTapped() {
        var title: String?
        if let titleText = addMedScreen.textFieldTitle.text, !titleText.isEmpty {
            title = titleText
        } else {
            return // Handle empty title
        }
        
        var dosage: String?
        if let dosageText = addMedScreen.textFieldDosage.text, !dosageText.isEmpty {
            dosage = dosageText
        } else {
            return // Handle empty dosage
        }
        
        selectedTime = addMedScreen.pickerTime.date
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let formattedTime = timeFormatter.string(from: selectedTime)
        
        // Create a new medication object
        let newMed = Med(title: title, dosage: dosage, time: formattedTime, isChecked: false)
        
        // Save medication to Firestore
        saveMedicationToDatabase(med: newMed) { [weak self] success in
            if success {
                // Notify delegate and pop view controller
                self?.delegate?.delegateOnAddMed(med: newMed)
                
                // Show success alert
                self?.showSuccessAlert()
                
                // Clear the fields after adding the med
                self?.clearFormFields()
                
                // Pop the view controller
                self?.navigationController?.popViewController(animated: true)
            } else {
                print("Failed to save medication to database")
            }
        }
    }
    
    func saveMedicationToDatabase(med: Med, completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("No user is logged in")
            completion(false)
            return
        }
        
        let db = Firestore.firestore()
        let medData: [String: Any] = [
            "title": med.title ?? "",
            "dosage": med.dosage ?? "",
            "time": med.time ?? "",
            "isChecked": med.isChecked,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
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
    func updateSelectedTime(for timeString: String) {
        let calendar = Calendar.current
        var components = DateComponents()

        switch timeString {
        case "Morning":
            components.hour = 8  // 8 AM
            components.minute = 0
        case "Afternoon":
            components.hour = 12  // 12 PM
            components.minute = 0
        case "Evening":
            components.hour = 18  // 6 PM
            components.minute = 0
        default:
            components.hour = 0  // Default to midnight if not matched
            components.minute = 0
        }

        selectedTime = calendar.date(from: components) ?? Date()  // Fallback to current date if invalid
    }


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

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Get time option from Utilities
        let selectedTimeString = Utilities.times[row]

        // Set selectedTime as a Date based on the option
        updateSelectedTime(for: selectedTimeString)
        
        return selectedTimeString
    }
}
