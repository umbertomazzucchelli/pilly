//
//  MedListView.swift
//  pilly
//
//  Created by Samantha Ranjo on 10/27/24.
//
//

import UIKit

class MedListView: UIView, UITableViewDelegate, UITableViewDataSource, AddMedDelegate {
    var tableViewMed: UITableView!
    var dateLabel: UILabel!
    var welcomeLabel: UILabel!
    var searchBar: UISearchBar!
    var meds: [Med] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        // Initialize the TableView
        setupTableViewMed()
        setupDateLabel()
        setupWelcomeLabel()
        
        setupSearchBar()
        initConstraints()
        
        // Load Sample Data
        loadData()
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
        self.addSubview(tableViewMed)
    }
    
    func setupSearchBar() {
           searchBar = UISearchBar()
           searchBar.placeholder = "Search for medications..."
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
            searchBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 32), // Adjusted top margin
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
            tableViewMed.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8), // Updated to use bottomAnchor of welcomeLabel
            tableViewMed.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewMed.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableViewMed.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
        ])
    }


    
    // MARK: - UITableViewDataSource Methods
    
    func delegateOnAddMed(med: Med) {
           addNewMed(med: med)
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "meds", for: indexPath) as? TableViewMedCell else {
            return UITableViewCell()
        }
        
        let med = meds[indexPath.row]
        cell.configure(with: med)
        
        // Handle checklist toggle
        cell.onChecklistToggle = { [weak self] in
            guard let self = self else { return }
            self.meds[indexPath.row].isChecked.toggle()
            self.tableViewMed.reloadRows(at: [indexPath], with: .none)
        }
        
        return cell
    }
    
    // MARK: - Sample Data
    func loadData() {
        meds = [
            Med(title: "Paracetamol", dosage: "500mg", time: "8:00 AM"),
            Med(title: "Ibuprofen", dosage: "200mg", time: "2:00 PM"),
            Med(title: "Aspirin", dosage: "100mg", time: "10:00 PM")
        ]
        tableViewMed.reloadData()
    }
    
    func addNewMed(med: Med) {
           meds.append(med)
           tableViewMed.reloadData()
       }
}
