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
    
    override func loadView() {
        view = calendarView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calendar"
        
        calendarView.hideCheckboxButton() 
        
        setupCalendarSelection()
        setupTableView()
        fetchAllMedications()
        NotificationCenter.default.addObserver(self, selector: #selector(handleMedicationsUpdate(_:)), name: .medicationsUpdated, object: nil)
    }
    
    @objc private func handleMedicationsUpdate(_ notification: Notification) {
        guard let updatedMeds = notification.object as? [Med] else { return }
        allMedications = updatedMeds
        
        if let selectedDate = selectedDate {
            updateMedicationsForSelectedDate(selectedDate)
        }
    }
    
    private func setupCalendarSelection() {
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.calendarView.selectionBehavior = dateSelection
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
                    return Med(
                        title: data["title"] as? String,
                        amount: data["amount"] as? String,
                        dosage: Dosage(rawValue: (data["dosage"] as? String) ?? ""),
                        frequency: Frequency(rawValue: (data["frequency"] as? String) ?? ""),
                        time: data["time"] as? String,
                        isChecked: data["isChecked"] as? Bool ?? false
                    )
                } ?? []
                
                // Update for today's date
                if let today = Calendar.current.dateComponents([.year, .month, .day], from: Date()) as DateComponents? {
                    self?.updateMedicationsForSelectedDate(today)
                }
            }
    }
    
    private func updateMedicationsForSelectedDate(_ dateComponents: DateComponents) {
        guard let date = Calendar.current.date(from: dateComponents) else { return }
        
        // Filter medications based on frequency and selected date
        medicationsForSelectedDate = allMedications.filter { med in
            switch med.frequency {
            case .daily:
                return true
            case .weekly:
                return Calendar.current.component(.weekday, from: date) == 2 // Monday
            case .biWeekly:
                let weekNumber = Calendar.current.component(.weekOfYear, from: date)
                return weekNumber % 2 == 0
            case .none:
                return false
            }
        }
        
        calendarView.noEventsLabel.isHidden = !medicationsForSelectedDate.isEmpty
        calendarView.tableViewEvents.reloadData()
    }
}

// MARK: - UICalendarSelectionSingleDateDelegate
extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        self.selectedDate = dateComponents
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
            let alert = UIAlertController(title: medication.title, message: getMedicationDetails(medication), preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
        
        private func getMedicationDetails(_ medication: Med) -> String {
            var details = "Dosage: \(medication.dosage?.rawValue ?? "N/A")\n"
            details += "Frequency: \(medication.frequency?.rawValue ?? "N/A")\n"
            details += "Amount: \(medication.amount ?? "N/A")\n"
            details += "Time: \(medication.time ?? "N/A")\n"
            return details
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
