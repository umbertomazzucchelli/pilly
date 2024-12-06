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
    var medicationCheckState: [String: [String: Bool]] = [:]
    var listener: ListenerRegistration?
    let db = Firestore.firestore()

    var viewController: UINavigationController?
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        setupTableViewMed()
        setupDateLabel()
        setupWelcomeLabel()
        setupSearchBar()
        initConstraints()

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
        searchBar.delegate = self
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
            searchBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            dateLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            welcomeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            welcomeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            welcomeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),

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
                self.filteredMeds = fetchedMeds
                self.tableViewMed.reloadData()
            }
        }
    }
    
    func setupRealTimeListener() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let medicationsRef = db.collection("users").document(user.uid).collection("medications")

        listener = medicationsRef.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error listening for updates: \(error.localizedDescription)")
                return
            }

            var updatedMeds: [Med] = []
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
                    updatedMeds.append(med)
                }
            }

            self.meds = updatedMeds
            self.filteredMeds = updatedMeds
            self.tableViewMed.reloadData()
        }
    }
    deinit {
        listener?.remove()
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

        let currentDate = getCurrentDate()
        let isCheckedToday = medicationCheckState[currentDate]?[med.title ?? ""] ?? med.isChecked

        cell.labelTitle.text = med.title
        cell.labelAmount.text = med.amount
        cell.labelDosage.text = med.dosage?.rawValue
        cell.labelFrequency.text = med.frequency?.rawValue ?? "No frequency available"
        cell.labelTime.text = med.time
        cell.checkboxButton.isSelected = isCheckedToday

        cell.checkboxButton.addTarget(self, action: #selector(handleCheckboxTapped(_:)), for: .touchUpInside)
        return cell
    }

    @objc func handleCheckboxTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? TableViewMedCell,
              let indexPath = tableViewMed.indexPath(for: cell) else { return }
        
        let med = filteredMeds[indexPath.row]
        let isChecked = !sender.isSelected
        sender.isSelected = isChecked
        
        let currentDate = getCurrentDate()
        if medicationCheckState[currentDate] == nil {
            medicationCheckState[currentDate] = [:]
        }
        medicationCheckState[currentDate]?[med.title ?? ""] = isChecked

        updateMedicationStatus(med: med, isChecked: isChecked)
    }

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let med = self.isSearching ? self.filteredMeds[indexPath.row] : self.meds[indexPath.row]

            self.deleteMedicationFromFirestore(med: med) {
                success in
                if success {
                    self.meds.removeAll { $0.title == med.title }
                    self.filteredMeds.removeAll { $0.title == med.title }
                    tableView.reloadData()
                } else {
                    print("Failed to delete medication")
                }
                completionHandler(true)
            }
        }
        deleteAction.backgroundColor = UIColor.red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
        
    }

        
    func deleteMedicationFromFirestore(med: Med?, completion: @escaping (Bool) -> Void) {
            guard let user = Auth.auth().currentUser, let med = med else { return }
            
            let db = Firestore.firestore()
            let medicationsRef = db.collection("users").document(user.uid).collection("medications")
            
            medicationsRef.whereField("title", isEqualTo: med.title ?? "").getDocuments { snapshot, error in
                if let error = error {
                    print("Error deleting medication: \(error.localizedDescription)")
                    return
                }
                
                if let document = snapshot?.documents.first {
                    document.reference.delete { error in
                        if let error = error {
                            print("Error deleting medication document: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            print("Medication deleted successfully.")
                            completion(true)
                        }
                    }

                }
            }
        }
  
        
       
}
