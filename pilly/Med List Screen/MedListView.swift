//
//  MedListView.swift
//  pilly
//
//  Created by Umberto Mazzucchelli on 12/6/24.
//
//

import UIKit
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
        startMedicationSync()
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
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor(red: 179/255, green: 235/255, blue: 242/255, alpha: 0.5)
        searchBar.layer.cornerRadius = 10
        searchBar.layer.masksToBounds = true
        searchBar.searchTextField.font = UIFont(name: "OpenSans", size: 16)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(searchBar)
    }

    func setupWelcomeLabel() {
        welcomeLabel = UILabel()
        welcomeLabel.text = "Good Morning 🌞 Today's Task"
        welcomeLabel.font = UIFont(name: "OpenSans-Bold", size: 24)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(welcomeLabel)
    }

    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: Date())
    }

    func setupDateLabel() {
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = getCurrentDate()
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

    // MARK: - Data Management
    func updateSelectedDate(_ date: DateComponents) {
        self.selectedDate = date
    }

    func fetchMedsFromFirestore() {
        guard AuthManager.shared.isUserLoggedIn else {
            print("User not authenticated.")
            return
        }

        DataSyncManager.shared.fetchMedications { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let medications):
                self.meds = medications
                self.filteredMeds = medications
                DispatchQueue.main.async {
                    self.tableViewMed.reloadData()
                }
                
            case .failure(let error):
                print("Error fetching medications: \(error)")
            }
        }
    }
    
    private func startMedicationSync() {
        guard AuthManager.shared.isUserLoggedIn else { return }
        
        DataSyncManager.shared.startMedicationSync { [weak self] medications in
            guard let self = self else { return }
            self.meds = medications
            self.filteredMeds = self.isSearching ?
            medications.filter { $0.title!.lowercased().contains(self.searchBar.text!.lowercased()) } :
                medications
            
            DispatchQueue.main.async {
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

        cell.configure(with: med)
        cell.onChecklistToggle = { [weak self] in
            self?.handleMedicationStatusUpdate(med: med, isChecked: cell.isChecked)
        }
        
        return cell
    }
    
    private func handleMedicationStatusUpdate(med: Med, isChecked: Bool) {
        guard let medId = med.id else { return }
        
        DataSyncManager.shared.updateMedicationStatus(medId: medId, isChecked: isChecked) { error in
            if let error = error {
                print("Error updating medication status: \(error)")
            }
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let med = self.isSearching ? self.filteredMeds[indexPath.row] : self.meds[indexPath.row]
            
            guard let medId = med.id else {
                completionHandler(false)
                return
            }

            DataSyncManager.shared.deleteMedication(medicationId: medId) { error in
                if let error = error {
                    print("Failed to delete medication: \(error)")
                    completionHandler(false)
                } else {
                    completionHandler(true)
                }
            }
        }
        
        deleteAction.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    deinit {
        DataSyncManager.shared.stopMedicationSync()
    }
}
