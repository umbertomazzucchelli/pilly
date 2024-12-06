//
//  MedicationListViewController.swift
//  pilly
//
//  Created by Belen Tesfaye on 12/6/24.
//

import UIKit
import Firebase

class MedicationListViewController: UITableViewController {
    var medications: [Med] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(TableViewMedCell.self, forCellReuseIdentifier: "MedicationCell")
        fetchMedications()
    }

    func fetchMedications() {
        guard let user = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        let medicationRef = db.collection("users").document(user.uid).collection("medications")
        
        medicationRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching medications: \(error)")
            } else {
                self.medications = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    let title = data["title"] as? String
                    let dosage = Dosage(rawValue: data["dosage"] as? String ?? "")
                    let frequence = Frequency(rawValue:data["frequency"] as? String ?? "")
                    let time = data["time"] as? String
                    let amount = data["amount"] as? String
                    
                    let id = document.documentID
                    /*
                     var id: String?
                     var title: String?
                     var amount: String?
                     var dosage: Dosage?
                     var frequency: Frequency?
                     var time: String?
                     var isChecked: Bool
                     */
                    return Med(id: id, title: title, amount: amount, dosage: dosage, frequency: frequence, time: time)
                } ?? []
                self.hideCheckboxButton()
                self.tableView.reloadData()
            }
        }
    }
    func hideCheckboxButton() {
        tableView.reloadData()
        
        tableView.visibleCells.forEach { cell in
            if let medCell = cell as? TableViewMedCell {
                print("Hiding checkbox for cell")
                medCell.checkboxButton.isHidden = true
            }
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medications.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let medication = medications[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationCell", for: indexPath)
        cell.textLabel?.text = medication.title
        cell.detailTextLabel?.text = medication.dosage?.rawValue
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMedication = medications[indexPath.row]
        let editMedicationVC = EditMedicationViewController()
        editMedicationVC.selectedMedication = selectedMedication  // Pass selected medication
        navigationController?.pushViewController(editMedicationVC, animated: true)
    }
}
