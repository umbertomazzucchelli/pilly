//
//  MedListView.swift
//  pilly
//
//  Created by Samantha Ranjo on 10/27/24.
//
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MedListView: UIView, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var tableViewMed: UITableView!
    var dateLabel: UILabel!
    var welcomeLabel: UILabel!
    var searchBar: UISearchBar!
    var meds: [Med] = []
    var filteredMeds: [Med] = []
    var isSearching = false
    var selectedDate: DateComponents?


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        // Initialize the TableView
        setupTableViewMed()
        setupDateLabel()
        setupWelcomeLabel()
        setupSearchBar()
        initConstraints()

        // Fetch medications from Firestore
        fetchMedsFromFirestore()
        setupRealTimeListener()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTableViewMed() {
        tableViewMed = UITableView()
        tableViewMed.register(TableViewMedCell.self, forCellReuseIdentifier: "meds")
        tableViewMed.translatesAutoresizingMaskIntoConstraints = false
        tableViewMed.delegate = self
        tableViewMed.dataSource = self
        tableViewMed.isScrollEnabled = true
        tableViewMed.rowHeight = UITableView.automaticDimension
        tableViewMed.estimatedRowHeight = 100
        self.addSubview(tableViewMed)
    }

    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search for medications..."
        searchBar.delegate = self // Set the delegate
        searchBar.backgroundImage = UIImage() // Removes default background
        searchBar.backgroundColor = UIColor(red: 179/255, green: 235/255, blue: 242/255, alpha: 0.5)
        searchBar.layer.cornerRadius = 10
        searchBar.layer.masksToBounds = true
        searchBar.searchTextField.font = UIFont(name: "OpenSans", size: 16)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(searchBar)
    }

    func setupWelcomeLabel() {
        welcomeLabel = UILabel()
        welcomeLabel.text = "Good Morning 🌞 Today’s Task"
        welcomeLabel.font = UIFont(name: "OpenSans-Bold", size: 24)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(welcomeLabel)
    }

    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }

    func setupDateLabel() {
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = getCurrentDate() // Set current date
        self.addSubview(dateLabel)
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            // Search Bar Constraints
            searchBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 40),

            // Date Label Constraints
            dateLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),

            // Welcome Label Constraints
            welcomeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            welcomeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            welcomeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),

            // TableView Constraints
            tableViewMed.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8),
            tableViewMed.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewMed.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableViewMed.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
        ])
    }
    func updateSelectedDate(_ date: DateComponents) {
            self.selectedDate = date
        }
    func updateMedicationStatus(med: Med, isChecked: Bool) {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let medicationsRef = db.collection("users").document(user.uid).collection("medications")

        medicationsRef.whereField("title", isEqualTo: med.title ?? "").getDocuments { snapshot, error in
            guard let document = snapshot?.documents.first else { return }

            document.reference.updateData(["isChecked": isChecked]) { error in
                if let error = error {
                    print("Error updating medication: \(error.localizedDescription)")
                } else {
                    print("Medication status updated successfully.")
                }
            }
        }
    }


    // MARK: - Firestore Data Fetching
    func fetchMedsFromFirestore() {
        let db = Firestore.firestore()

        guard let user = Auth.auth().currentUser else {
            print("User not authenticated.")
            return
        }

        let medicationsRef = db.collection("users").document(user.uid).collection("medications")
        medicationsRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching medications: \(error.localizedDescription)")
            } else {
                var fetchedMeds: [Med] = []
                if let documents = snapshot?.documents {
                    for document in documents {
                        let data = document.data()
                        let title = data["title"] as? String ?? "Unknown"
                        let amount = data["amount"] as? String
                        let dosageString = data["dosage"] as? String
                        let frequencyString = data["frequency"] as? String
                        let time = data["time"] as? String
                        let isChecked = data["isChecked"] as? Bool ?? false

                        let dosage = Dosage(rawValue: dosageString ?? "")
                        let frequency = Frequency(rawValue: frequencyString ?? "")
                        
                        let med = Med(title: title, amount: amount, dosage: dosage, frequency: frequency, time: time, isChecked: isChecked)
                        fetchedMeds.append(med)
                    }
                }
                
                self.meds = fetchedMeds
                self.filteredMeds = fetchedMeds // Initialize filteredMeds
                self.tableViewMed.reloadData()
            }
        }
    }

    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredMeds = meds
        } else {
            isSearching = true
            filteredMeds = meds.filter { $0.title!.lowercased().contains(searchText.lowercased()) }
        }
        tableViewMed.reloadData()
    }

    // MARK: - TableView Delegate and DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredMeds.count : meds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "meds", for: indexPath) as! TableViewMedCell
        let med = isSearching ? filteredMeds[indexPath.row] : meds[indexPath.row]

        cell.labelTitle.text = med.title
        cell.labelAmount.text = med.amount
        cell.labelDosage.text = med.dosage?.rawValue
        cell.labelFrequency.text = med.frequency?.rawValue ?? "No frequency available"
        cell.labelTime.text = med.time
        cell.checkboxButton.isSelected = med.isChecked

        return cell
    }
    func setupRealTimeListener() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let medicationsRef = db.collection("users").document(user.uid).collection("medications")
        
        medicationsRef.addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                print("Error listening for changes: \(error.localizedDescription)")
                return
            }
            
            var updatedMeds: [Med] = []
            snapshot?.documents.forEach { document in
                let data = document.data()
                let med = Med(
                    title: data["title"] as? String ?? "Unknown",
                    amount: data["amount"] as? String,
                    dosage: Dosage(rawValue: data["dosage"] as? String ?? ""),
                    frequency: Frequency(rawValue: data["frequency"] as? String ?? ""),
                    time: data["time"] as? String,
                    isChecked: data["isChecked"] as? Bool ?? false
                )
                updatedMeds.append(med)
            }
            
            self?.meds = updatedMeds
            self?.filteredMeds = updatedMeds
            self?.tableViewMed.reloadData()
            
            // Notify other parts of the app
            NotificationCenter.default.post(name: .medicationsUpdated, object: updatedMeds)
        }
    }

    func deleteMedication(med: Med, at indexPath: IndexPath) {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let medicationsRef = db.collection("users").document(user.uid).collection("medications")
        
        medicationsRef.whereField("title", isEqualTo: med.title ?? "").getDocuments { [weak self] (snapshot, error) in
            guard let documents = snapshot?.documents, let document = documents.first else {
                print("Medication not found for deletion.")
                return
            }

            // Delete the document
            document.reference.delete { error in
                if let error = error {
                    print("Error deleting medication: \(error.localizedDescription)")
                } else {
                    print("Medication deleted successfully.")

                    // Update the correct data source and table view
                    if self?.isSearching == true {
                        self?.filteredMeds.remove(at: indexPath.row)
                    }
                    self?.meds.removeAll { $0.title == med.title }

                    DispatchQueue.main.async {
                        self?.tableViewMed.performBatchUpdates {
                            self?.tableViewMed.deleteRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            }
        }
    }

    func editMedication(med: Med) {
        // Handle the logic for editing
        // You can present a new view controller or a popup to allow the user to modify the medication details.
        print("Editing medication: \(med.title ?? "Unknown")")
    }


}
// MARK: - UITableViewDelegate: Swipe Actions
extension MedListView {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let med = isSearching ? filteredMeds[indexPath.row] : meds[indexPath.row]

        // Delete action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            self?.deleteMedication(med: med, at: indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed

        // Edit action
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, completionHandler in
            self?.editMedication(med: med)
            completionHandler(true)
        }
        editAction.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var med = isSearching ? filteredMeds[indexPath.row] : meds[indexPath.row]
        med.isChecked.toggle() // Toggle the checked state

        // Ensure that you use the selected date for updating the correct document
        guard let user = Auth.auth().currentUser, let selectedDate = selectedDate else { return }
        
        let db = Firestore.firestore()
        let medicationsRef = db.collection("users").document(user.uid).collection("medications")
        
        // Search for the medication by title and date
        let selectedDateString = DateFormatter.localizedString(from: selectedDate.date!, dateStyle: .short, timeStyle: .none) // Convert to string representation
        medicationsRef.whereField("title", isEqualTo: med.title ?? "").whereField("date", isEqualTo: selectedDateString).getDocuments { snapshot, error in
            if let document = snapshot?.documents.first {
                // Update the specific medication for the selected date
                document.reference.updateData(["isChecked": med.isChecked]) { error in
                    if let error = error {
                        print("Error updating medication: \(error.localizedDescription)")
                    } else {
                        print("Medication status updated successfully.")
                    }
                }
            }
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

}
