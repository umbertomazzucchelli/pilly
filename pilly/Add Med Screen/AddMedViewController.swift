//
//  AddMedViewController.swift
//  pilly
//
//  Created by Samantha Ranjo on 10/29/24.
//

import UIKit

class AddMedViewController: UIViewController {
    
    // delegate to ViewController when getting back
    var delegate:ViewController!
    
    var selectedTime = "Morning"
    
    let addMedScreen = AddMedView()
    
    override func loadView() {
        view = addMedScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // patching delegate and datasource of type PickerView
        addMedScreen.pickerTime.delegate = self
        addMedScreen.pickerTime.dataSource = self
        
        // adding action for tapping on buttonAdd
        addMedScreen.buttonAdd.addTarget(self, action: #selector(onAddButtonTapped), for: .touchUpInside)
    }
    
    // action for tapping buttonAdd
    @objc func onAddButtonTapped() {
        var title: String?
        if let titleText = addMedScreen.textFieldTitle.text {
            if !titleText.isEmpty {
                title = titleText
            } else {
                //do my thang
                return
            }
        }
        
        var dosage: String?
        if let dosageText = addMedScreen.textFieldDosage.text {
            if !dosageText.isEmpty {
                dosage = dosageText
            } else {
                // do my thang again
                return
            }
        } else {
            // do my thing again!
            return
        }
        
        let newMed = Med(title: title, dosage: dosage, time: selectedTime)
        delegate.delegateOnAddMed(med: newMed)
        navigationController?.popViewController(animated: true)
    }
}

// adopting required protocols
extension AddMedViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //MARK: we are displaying the options from Utilities.types...
        return Utilities.times.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // update selected type when user picks this row
        selectedTime = Utilities.times[row]
        return Utilities.times[row]
    }
}
