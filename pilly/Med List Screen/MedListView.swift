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

class MedListView: UIView {
    var tableViewMed: UITableView!
    var dateLabel: UILabel!
    var welcomeLabel: UILabel!
    var searchBar: UISearchBar!
    var meds: [Med] = []
    var filteredMeds: [Med] = []
    var isSearching = false
    var selectedDate: Date = Date()

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
        tableViewMed.delegate = self
        tableViewMed.dataSource = self
        tableViewMed.backgroundColor = .white
        tableViewMed.translatesAutoresizingMaskIntoConstraints = false
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

    func fetchMedsFromFirestore() {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated.")
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(user.uid).collection("medications").getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching medications: \(error.localizedDescription)")
                return
            }

            var fetchedMeds: [Med] = []
            if let documents = snapshot?.documents {
                for document in documents {
                    let data = document.data()
                    let completionDates = data["completionDates"] as? [String: Bool] ?? [:]
                    
                    let med = Med(
                        id: document.documentID,
                        title: data["title"] as? String,
                        amount: data["amount"] as? String,
                        dosage: Dosage(rawValue: (data["dosage"] as? String) ?? ""),
                        frequency: Frequency(rawValue: (data["frequency"] as? String) ?? ""),
                        time: data["time"] as? String,
                        completionDates: completionDates
                    )
                    fetchedMeds.append(med)
                }
            }
            
            self?.meds = fetchedMeds
            self?.filteredMeds = fetchedMeds
            self?.tableViewMed.reloadData()
        }
    }

    func updateMedicationStatus(med: Med, isCompleted: Bool) {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        
        let dateString = Med.dateFormatter.string(from: selectedDate)
        
        guard let docId = med.id else {
            print("Error: Medication document ID is missing")
            return
        }
        
        let docRef = db.collection("users").document(user.uid)
            .collection("medications").document(docId)
        
        docRef.updateData([
            "completionDates.\(dateString)": isCompleted
        ]) { error in
            if let error = error {
                print("Error updating medication status: \(error.localizedDescription)")
            } else {
                print("Successfully updated medication status")
                self.fetchMedsFromFirestore()
            }
        }
    }

    func setupRealTimeListener() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(user.uid)
            .collection("medications")
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Error setting up real-time listener: \(error.localizedDescription)")
                    return
                }
                
                self?.fetchMedsFromFirestore()
            }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MedListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredMeds.count : meds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "meds", for: indexPath) as! TableViewMedCell
        let med = isSearching ? filteredMeds[indexPath.row] : meds[indexPath.row]
        
        cell.configure(with: med, for: selectedDate)
        cell.onChecklistToggle = { [weak self] in
            self?.updateMedicationStatus(med: med, isCompleted: cell.isChecked)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - UISearchBarDelegate
extension MedListView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredMeds = meds
        } else {
            isSearching = true
            filteredMeds = meds.filter { $0.title?.lowercased().contains(searchText.lowercased()) ?? false }
        }
        tableViewMed.reloadData()
    }
}
