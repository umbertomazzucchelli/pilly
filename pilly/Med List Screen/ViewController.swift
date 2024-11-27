//
//  ViewController.swift
//  pilly
//
//  Created by Belen Tesfaye on 10/24/24.
//
//

import UIKit

class ViewController: UIViewController {
    
    let medScreen = MedListView()
    
    var meds = [Med]()
    
    let times = ["Morning", "Afternoon", "Evening"]
    
    func delegateOnAddMed(med: Med) {
        meds.append(med)
        medScreen.tableViewMed.reloadData()
    }
    
    override func loadView() {
        view = medScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Medication"
        
        // patching table view delegate and datasource to controller
        medScreen.tableViewMed.delegate = self
        medScreen.tableViewMed.dataSource = self
        
        // MARK: setting add button to nav controller
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddBarButtonTapped)
        )
        
        //dummmmy code :-)
//        meds.append(Med(title: "Tylenol", dosage: "500mg", time: times[1]))
//        meds.append(Med(title: "Welbutrin", dosage: "150mg", time: times[2]))
//        meds.append(Med(title: "Zyrtec", dosage: "10mg", time: times[2]))
    }
    
    @objc func onAddBarButtonTapped() {
        let addMedController = AddMedViewController()
        addMedController.delegate = self
        navigationController?.pushViewController(addMedController, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "meds", for: indexPath) as! TableViewMedCell
        cell.labelTitle.text = meds[indexPath.row].title
        if let uwDosage = meds[indexPath.row].dosage{
            cell.labelDosage.text = "Dosage: \(uwDosage)"
        }
        if let uwTime = meds[indexPath.row].time{
            cell.labelTime.text = "Time: \(uwTime)"
        }
        return cell
    }
}

