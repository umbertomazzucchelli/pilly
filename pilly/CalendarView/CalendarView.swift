//
//  CalendarView.swift
//  pilly
//
//  Created by Umberto Mazzucchelli on 12/5/24.
//

import UIKit

class CalendarView: UIView {
    
    var calendarView: UICalendarView!
    var tableViewEvents: UITableView!
    var noEventsLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupCalendar()
        setupTableViewEvents()
        setupNoEventsLabel()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCalendar() {
        calendarView = UICalendarView()
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.backgroundColor = .white
        calendarView.tintColor = UIColor.systemPink.withAlphaComponent(0.3)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(calendarView)
    }
    
    func setupTableViewEvents() {
        tableViewEvents = UITableView()
        tableViewEvents.register(TableViewMedCell.self, forCellReuseIdentifier: "meds")
        tableViewEvents.backgroundColor = .white
        tableViewEvents.isScrollEnabled = true
        tableViewEvents.rowHeight = UITableView.automaticDimension
        tableViewEvents.estimatedRowHeight = 100
        tableViewEvents.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewEvents)
    }
    
    func setupNoEventsLabel() {
        noEventsLabel = UILabel()
        noEventsLabel.text = "No medications scheduled for this day"
        noEventsLabel.textAlignment = .center
        noEventsLabel.textColor = .gray
        noEventsLabel.isHidden = true
        noEventsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(noEventsLabel)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Calendar constraints - increased height
            calendarView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            calendarView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            calendarView.heightAnchor.constraint(equalToConstant: 380), // Increased from 300
            
            // Table view constraints
            tableViewEvents.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 20), // Reduced spacing
            tableViewEvents.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tableViewEvents.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            tableViewEvents.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            // No events label constraints
            noEventsLabel.centerXAnchor.constraint(equalTo: tableViewEvents.centerXAnchor),
            noEventsLabel.centerYAnchor.constraint(equalTo: tableViewEvents.centerYAnchor)
        ])
    }
    
    func hideCheckboxButton() {
        tableViewEvents.reloadData()
        tableViewEvents.visibleCells.forEach { cell in
            if let medCell = cell as? TableViewMedCell {
                medCell.checkboxButton.isHidden = true
            }
        }
    }

    func showCheckboxButton() {
        tableViewEvents.visibleCells.forEach { cell in
            if let medCell = cell as? TableViewMedCell {
                medCell.checkboxButton.isHidden = false
            }
        }
    }
}
