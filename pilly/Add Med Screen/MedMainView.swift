//
//  MedMainView.swift
//  pilly
//
//  Created by Belen Tesfaye on 11/26/24.
//

import UIKit



class MedMainView: UIView {
    
    var searchBar: UISearchBar!
    var dateLabel: UILabel!
    var welcomeLabel: UILabel!
    var footerView: UIView!
    var checklistView: UIStackView!
    var scrollView: UIScrollView!  // Add scroll view
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupScrollView()  // Initialize scroll view
        setupSearchBar()
        setupDateLabel()
        setupWelcomeLabel()
        setupFooter()
        setupChecklist()
    }
    
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        // ScrollView constraints to fill the entire screen
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search for medications..."
        searchBar.barTintColor = .blue  // Set the search bar background color to blue
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(searchBar)
    }
    
    func setupDateLabel() {
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = getCurrentDate() // Set current date
        scrollView.addSubview(dateLabel)
    }
    
    func setupWelcomeLabel() {
        welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome"
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: 24)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(welcomeLabel)
    }
    
    func setupFooter() {
        footerView = UIView()
        footerView.backgroundColor = .lightGray
        footerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(footerView)
        
        // Add footer content (e.g., a label or a button for navigation)
        let footerLabel = UILabel()
        footerLabel.text = "Footer content here"
        footerLabel.textAlignment = .center
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(footerLabel)
    }
    
    func setupChecklist() {
        checklistView = UIStackView()
        checklistView.axis = .vertical
        checklistView.spacing = 10
        checklistView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(checklistView)
        
        // Add checklist items
        for i in 1...5 { // Assuming 5 checklist items
            let itemLabel = UILabel()
            itemLabel.text = "Medication \(i)"
            checklistView.addArrangedSubview(itemLabel)
        }
    }
    
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            // Search Bar Constraints
            searchBar.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32), // Adjusted top margin
            searchBar.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            // Date Label Constraints
            dateLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            // Welcome Label Constraints
            welcomeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            welcomeLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            welcomeLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            // Checklist View Constraints
            checklistView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 16),
            checklistView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            checklistView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            // Footer View Constraints
            footerView.topAnchor.constraint(equalTo: checklistView.bottomAnchor, constant: 16),
            footerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 60), // Footer height
            footerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
