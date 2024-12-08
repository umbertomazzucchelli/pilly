//
//  CalendarViewController.swift
//  pilly
//
//  Created by Umberto Mazzucchelli on 12/4/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CalendarViewController: UIViewController {
    
    private let calendarView = CalendarView()
    private let db = Firestore.firestore()
    private var medicationsForSelectedDate: [Med] = []
    private var allMedications: [Med] = []
    private var selectedDate: DateComponents?
    private var medicationStartDate: Date?
    
    override func loadView() {
        view = calendarView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calendar"
        
        calendarView.hideCheckboxButton()
        medicationStartDate = Date() // Set start date to today
        
        setupCalendarSelection()
        setupTableView()
        setupNotifications()
        fetchAllMedications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllMedications()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMedicationsUpdate(_:)),
            name: .medicationsUpdated,
            object: nil
        )
    }
    
    @objc private func handleMedicationsUpdate(_ notification: Notification) {
        fetchAllMedications()
    }
    
    private func setupCalendarSelection() {
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.calendarView.selectionBehavior = dateSelection
        
        // Select today's date by default
        let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        dateSelection.setSelected(today, animated: false)
        updateMedicationsForSelectedDate(today)
    }
    
    private func setupTableView() {
        calendarView.tableViewEvents.delegate = self
        calendarView.tableViewEvents.dataSource = self
    }
    
    private func fetchAllMedications() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).collection("medications")
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching medications: \(error)")
                    return
                }
                
                self?.allMedications = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    let createdTimestamp = data["createdAt"] as? Timestamp
                    let startDate = createdTimestamp?.dateValue() ?? Date()
                    
                    return Med(
                        id: document.documentID,
                        title: data["title"] as? String,
                        amount: data["amount"] as? String,
                        dosage: Dosage(rawValue: (data["dosage"] as? String) ?? ""),
                        frequency: Frequency(rawValue: (data["frequency"] as? String) ?? ""),
                        time: data["time"] as? String,
                        isChecked: data["isChecked"] as? Bool ?? false,
                        startDate: startDate
                    )
                } ?? []
                
                // Update for currently selected date
                if let selectedDate = self?.selectedDate {
                    self?.updateMedicationsForSelectedDate(selectedDate)
                } else {
                    let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                    self?.updateMedicationsForSelectedDate(today)
                }
            }
    }
    
    private func updateMedicationsForSelectedDate(_ dateComponents: DateComponents) {
        self.selectedDate = dateComponents
        guard let targetDate = Calendar.current.date(from: dateComponents) else { return }
        
        // Filter medications based on frequency and start date
        medicationsForSelectedDate = allMedications.filter { medication in
            guard let frequency = medication.frequency,
                  let startDate = medication.startDate else { return false }
            
            // Don't show medications before their start date
            if targetDate < Calendar.current.startOfDay(for: startDate) {
                return false
            }
            
            let calendar = Calendar.current
            let daysSinceStart = calendar.dateComponents([.day], from: calendar.startOfDay(for: startDate), to: targetDate).day ?? 0
            
            switch frequency {
            case .daily:
                return true
                
            case .weekly:
                // Show on the same day of week as start date
                let startWeekday = calendar.component(.weekday, from: startDate)
                let targetWeekday = calendar.component(.weekday, from: targetDate)
                return startWeekday == targetWeekday
                
            case .biWeekly:
                // Show every two weeks from start date
                let startWeekday = calendar.component(.weekday, from: startDate)
                let targetWeekday = calendar.component(.weekday, from: targetDate)
                let weeksFromStart = daysSinceStart / 7
                return startWeekday == targetWeekday && weeksFromStart % 2 == 0
            }
        }
        
        DispatchQueue.main.async {
            self.calendarView.noEventsLabel.isHidden = !self.medicationsForSelectedDate.isEmpty
            self.calendarView.tableViewEvents.reloadData()
        }
    }
}

// MARK: - UICalendarSelectionSingleDateDelegate
extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        if let dateComponents = dateComponents {
            updateMedicationsForSelectedDate(dateComponents)
        }
    }
}

// MARK: - UITableView Delegate & DataSource
extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicationsForSelectedDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "meds", for: indexPath) as! TableViewMedCell
        let medication = medicationsForSelectedDate[indexPath.row]
        cell.configure(with: medication)
        cell.hideCheckboxButton()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let medication = medicationsForSelectedDate[indexPath.row]
        let alert = UIAlertController(title: medication.title,
                                    message: getMedicationDetails(medication),
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func getMedicationDetails(_ medication: Med) -> String {
        var details = "Dosage: \(medication.dosage?.rawValue ?? "N/A")\n"
        details += "Amount: \(medication.amount ?? "N/A")\n"
        details += "Frequency: \(medication.frequency?.rawValue ?? "N/A")\n"
        details += "Time: \(medication.time ?? "N/A")"
        return details
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
