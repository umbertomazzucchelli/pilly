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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "My Medications"
        
        setupMedListView()
        setupAddButton()
        setupNotifications()
    }
    
    private func setupNotifications() {
        NotificationManager.shared.addObserver(
            for: Notification.Name("MedicationClicked"),
            identifier: "HomeVC_MedicationClicked",
            using: { [weak self] notification in
                self?.handleMedicationClicked(notification)
            }
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        medListView.fetchMedsFromFirestore()
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
        guard let med = notification.object as? Med else { return }
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
    
    deinit {
        NotificationManager.shared.removeObserver(identifier: "HomeVC_MedicationClicked")
    }
}

// MARK: - AddMedViewControllerDelegate
extension HomeViewController: AddMedViewControllerDelegate {
    func delegateOnAddMed(med: Med) {
        medListView.fetchMedsFromFirestore()
    }
}

// MARK: - TableView Delegate Methods
// MARK: - TableView Delegate Methods
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Get the medication to delete
            let medToDelete = medListView.meds[indexPath.row]
            
            guard let medicationId = medToDelete.id else {
                showAlert(message: "Error: Could not find medication ID")
                return
            }
            
            DataSyncManager.shared.deleteMedication(medicationId: medicationId) { [weak self] error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.showAlert(message: "Error deleting medication: \(error.localizedDescription)")
                    } else {
                        // Refresh the medications list after successful deletion
                        self?.medListView.fetchMedsFromFirestore()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
}
