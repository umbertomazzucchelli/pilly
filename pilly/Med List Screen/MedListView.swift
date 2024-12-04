//
//  MedListView.swift
//  pilly
//
//  Created by Samantha Ranjo on 10/27/24.
//
//

//import UIKit
//import FirebaseFirestore
//
//class MedListView: UIView, UITableViewDelegate {
//    var tableViewMed: UITableView!
//    var dateLabel: UILabel!
//    var welcomeLabel: UILabel!
//    var searchBar: UISearchBar!
//    var meds: [Med] = []
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .white
//        
//        // Initialize the TableView
//        setupTableViewMed()
//        setupDateLabel()
//        setupWelcomeLabel()
//        
//        setupSearchBar()
//        initConstraints()
//        
//    }
//    
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setupTableViewMed() {
//        tableViewMed = UITableView()
//        tableViewMed.register(TableViewMedCell.self, forCellReuseIdentifier: "meds")
//        tableViewMed.translatesAutoresizingMaskIntoConstraints = false
//
//        self.addSubview(tableViewMed)
//    }
//    
//    func setupSearchBar() {
//           searchBar = UISearchBar()
//           searchBar.placeholder = "Search for medications..."
//           searchBar.backgroundImage = UIImage() // Removes default background
//           searchBar.backgroundColor = UIColor(red: 179/255, green: 235/255, blue: 242/255, alpha: 0.5)
//           searchBar.layer.cornerRadius = 10
//           searchBar.layer.masksToBounds = true
//           searchBar.searchTextField.font = UIFont(name: "OpenSans", size: 16)
//           searchBar.translatesAutoresizingMaskIntoConstraints = false
//           self.addSubview(searchBar)
//    }
////    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
////        // Filter the meds array based on searchText
////        meds = allMeds.filter { med in
////            med.title.lowercased().contains(searchText.lowercased())
////        }
////        tableViewMed.reloadData()
////    }
//
//    
//    func setupWelcomeLabel() {
//        welcomeLabel = UILabel()
//        welcomeLabel.text = "Good Morning 🌞 Today’s Task"
//        welcomeLabel.font = UIFont(name: "OpenSans-Bold", size: 24)
//        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(welcomeLabel)
//    }
//    
//    func getCurrentDate() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .long
//        let currentDate = Date()
//        return dateFormatter.string(from: currentDate)
//    }
//    func setupDateLabel() {
//        dateLabel = UILabel()
//        dateLabel.translatesAutoresizingMaskIntoConstraints = false
//        dateLabel.text = getCurrentDate() // Set current date
//        self.addSubview(dateLabel)
//    }
//    
//    func initConstraints() {
//        NSLayoutConstraint.activate([
//            // Search Bar Constraints
//            searchBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 32), // Adjusted top margin
//            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
//            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
//            searchBar.heightAnchor.constraint(equalToConstant: 40),
//            
//            // Date Label Constraints
//            dateLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
//            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
//            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
//            
//            // Welcome Label Constraints
//            welcomeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
//            welcomeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
//            welcomeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
//            
//            // TableView Constraints
//            tableViewMed.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8), // Updated to use bottomAnchor of welcomeLabel
//            tableViewMed.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
//            tableViewMed.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
//            tableViewMed.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
//        ])
//    }
//
//}
import UIKit
import FirebaseFirestore
import FirebaseAuth

class MedListView: UIView, UITableViewDelegate, UITableViewDataSource {
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
        
        // Fetch medications from Firestore
        fetchMedsFromFirestore()
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

                        let dosage = Dosage(rawValue: dosageString ?? "") // Assuming Dosage is an enum
                        let frequency = Frequency(rawValue: frequencyString ?? "") // Assuming Frequency is an enum
                        
                        // Create a Med object and append to the array
                        let med = Med(title: title, amount: amount, dosage: dosage, frequency: frequency, time: time, isChecked: isChecked)
                        fetchedMeds.append(med)
                    }
                }
                
                // Update the meds array and reload the table view
                self.meds = fetchedMeds
                self.tableViewMed.reloadData()
            }
        }
    }


    // MARK: - TableView Delegate and DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "meds", for: indexPath) as! TableViewMedCell
        let med = meds[indexPath.row]
        
        // Configure the cell with medication data
        cell.labelTitle.text = med.title
        cell.labelAmount.text = med.amount
        cell.labelDosage.text = med.dosage?.rawValue
        if let frequency = med.frequency {
            cell.labelFrequency.text = med.frequency?.rawValue ?? "No frequency available"
        } else {
            cell.labelFrequency.text = "No frequency available" // or some default text
        }

        cell.labelTime.text = med.time
        cell.checkboxButton.isSelected = med.isChecked

        
        return cell
    }
}

