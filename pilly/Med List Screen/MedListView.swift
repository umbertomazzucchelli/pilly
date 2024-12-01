//
//  MedListView.swift
//  pilly
//
//  Created by Samantha Ranjo on 10/27/24.
//
//

import UIKit

class MedListView: UIView, UITableViewDelegate, UITableViewDataSource {
    var tableViewMed: UITableView!
    var meds: [Med] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        // Initialize the TableView
        setupTableViewMed()
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
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            tableViewMed.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableViewMed.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewMed.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableViewMed.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
        ])
    }
    
    // MARK: - UITableViewDataSource Methods
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
}
