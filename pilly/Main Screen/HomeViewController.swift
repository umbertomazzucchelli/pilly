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
            
            let medToDelete = medListView.meds[indexPath.row]
            
            db.collection("users").document(userId).collection("medications")
                .whereField("id", isEqualTo: medToDelete.id ?? "")
                .getDocuments { [weak self] (querySnapshot, error) in
                    if let error = error {
                        self?.showAlert(message: "Error deleting medication: \(error.localizedDescription)")
                        return
                    }
                    
                    if let documentToDelete = querySnapshot?.documents.first {
                        documentToDelete.reference.delete { [weak self] error in
                            if let error = error {
                                self?.showAlert(message: "Error deleting medication: \(error.localizedDescription)")
                            } else {
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
