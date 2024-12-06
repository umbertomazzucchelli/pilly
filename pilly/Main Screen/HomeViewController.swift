//
//  HomeViewController.swift
//  pilly
//
//  Created by Umberto Mazzucchelli on 12/4/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    var medListView: MedListView!
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "My Medications"

        let testMed = Med(
            title: "Test Medication",
            amount: "5",  // Example amount
            dosage: .mg,  // Example dosage
            frequency: .daily,  // Example frequency
            time: "08:00 AM",  // Example time
            isChecked: false,  // Example checked status
            checkedDates: [:]  // Empty dictionary for checked dates
        )

        // Post notification to trigger edit view
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            NotificationCenter.default.post(
                name: Notification.Name("MedicationClicked"),
                object: testMed
            )
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMedicationClicked(_:)),
            name: Notification.Name("MedicationClicked"),
            object: nil
        )

        print("Observer registered")

        setupMedListView()
        setupAddButton()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        medListView.fetchMedsFromFirestore() // Refresh medications when view appears
    }
    
    func setupMedListView() {
        // Initialize MedListView
        medListView = MedListView()
        medListView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(medListView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            medListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            medListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            medListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            medListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupAddButton() {
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addMedicationTapped)
        )
        navigationItem.rightBarButtonItem = addButton
    }
    @objc func handleMedicationClicked(_ notification: Notification) {
        print("Notification received in handleMedicationClicked")

        guard let med = notification.object as? Med else {
            print("Notification object is not of type Med")
            return
        }

        print("Medication: \(med.title)")
        navigateToEditView(with: med)
    }


    func navigateToEditView(with medication: Med) {
        let editMedicationController = EditMedicationViewController()
        
        editMedicationController.selectedMedication = medication
        navigationController?.pushViewController(editMedicationController, animated: true)
    }

    
    @objc func addMedicationTapped() {
        let addMedVC = AddMedViewController()
        addMedVC.delegate = self
        navigationController?.pushViewController(addMedVC, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    deinit {
            // Remove observer when view controller is deallocated
            NotificationCenter.default.removeObserver(self, name: Notification.Name("MedicationClicked"), object: nil)
        }
}

// MARK: - AddMedViewControllerDelegate
extension HomeViewController: AddMedViewControllerDelegate {
    func delegateOnAddMed(med: Med) {
        medListView.fetchMedsFromFirestore() // Refresh the medications list
    }
}

// MARK: - TableView Delegate Methods
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            
            // Get the medication to delete
            let medToDelete = medListView.meds[indexPath.row]
            
            // Query for the document with matching title
            db.collection("users").document(userId).collection("medications")
                .whereField("title", isEqualTo: medToDelete.title ?? "")
                .getDocuments { [weak self] (querySnapshot, error) in
                    if let error = error {
                        self?.showAlert(message: "Error deleting medication: \(error.localizedDescription)")
                        return
                    }
                    
                    // Delete the first matching document
                    if let documentToDelete = querySnapshot?.documents.first {
                        documentToDelete.reference.delete { [weak self] error in
                            if let error = error {
                                self?.showAlert(message: "Error deleting medication: \(error.localizedDescription)")
                            } else {
                                // Refresh the medications list after successful deletion
                                DispatchQueue.main.async {
                                    self?.medListView.fetchMedsFromFirestore()
                                }
                            }
                        }
                    }
                }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
