//
//  ViewController.swift
//  pilly
//
//  Created by Belen Tesfaye on 10/24/24.
//
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController, AddAccountDelegate {
 
    

      let notificationCenter = NotificationCenter.default
      var currentUser: FirebaseAuth.User?
      var handleAuth: AuthStateDidChangeListenerHandle?
      let database = Firestore.firestore()
    
    var medList = [Med]()
    var mainScreenView = MainScreenView()
    var medListView = MedListView()
    
    var testAddmed = AddMedView()
        
    
    override func loadView() {
        if Auth.auth().currentUser == nil {
            view = mainScreenView
        } else {
            view = medListView
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set up authentication listener
        handleAuth = Auth.auth().addStateDidChangeListener{ [weak self] auth, user in
            guard let self = self else { return }
            
            if user == nil {
                // User is not logged in, present login screen
                self.currentUser = nil
                self.medListView.meds.removeAll()
                self.medListView.tableViewMed.reloadData()
                self.presentLoginScreen()
            } else {
                // User is logged in
                self.currentUser = user
                self.title = "Meds"
                self.setupRightBarButton(isLoggedin: true)
                self.switchToMedListView()
                          
//                self.observeMeds()
            }
        }
    }
    private func switchToMainScreenView() {
           DispatchQueue.main.async {
               self.view = self.mainScreenView
               self.medListView.tableViewMed.isHidden = true
           }
       }
    private func switchToMedListView() {
           DispatchQueue.main.async {
               self.view = self.medListView
               self.medListView.tableViewMed.isHidden = false
           }
       }
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           if let handle = handleAuth {
               Auth.auth().removeStateDidChangeListener(handle)
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pilly"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        mainScreenView.signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
    }
    func didCompleteAccountCreation() {
        let medMainVC = HomeViewController()  // Initialize your MedMainViewController
                navigationController?.pushViewController(medMainVC, animated: true)
//                print("Account creation was successful!") <#code#>
    }

    @objc func signInTapped(){
        presentLoginScreen()
    }
    
    func setupRightBarButton(isLoggedin: Bool) {
        if isLoggedin {
            let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
            navigationItem.rightBarButtonItem = logoutButton
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func logoutTapped() {
        do {
            try Auth.auth().signOut()
            notificationCenter.post(name: .userLoggedout, object: nil)
        } catch {
            showAlert(message: "Error signing out")
        }
    }

    func presentLoginScreen() {
        let signInAlert = UIAlertController(
            title: "Welcome",
            message: "Please sign in or register to continue",
            preferredStyle: .alert)
        
        signInAlert.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }
        
        signInAlert.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        let signInAction = UIAlertAction(title: "Sign In", style: .default) { [weak self] _ in
            if let email = signInAlert.textFields?[0].text,
               let password = signInAlert.textFields?[1].text {
                self?.signInToFirebase(email: email, password: password)
            }
        }
        
        let registerAction = UIAlertAction(title: "Register", style: .default) { [weak self] _ in
            let addAccountVC = AddAccountViewController()
            addAccountVC.delegate = self  // Set ViewController as delegate
            self?.navigationController?.pushViewController(addAccountVC, animated: true)
        }
        
        signInAlert.addAction(signInAction)
        signInAlert.addAction(registerAction)
        
        self.present(signInAlert, animated: true)
    }
    
    func signInToFirebase(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            showAlert(message: "Please enter your email and password.") { [weak self] _ in
                self?.presentLoginScreen()
            }
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.showAlert(message: error.localizedDescription) { [weak self] _ in
                    self?.presentLoginScreen()
                }
                return
            }
            self?.notificationCenter.post(name: .userLoggedin, object: nil)
        }
    }
    
    func showAlert(message: String, completionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completionHandler))
        present(alert, animated: true)
    }
    
    func observeThreads() {
        
    }
    func delegateAddMed(med: Med){
        guard let currentUser = Auth.auth().currentUser else {
               showAlert(message: "User is not logged in.") { [weak self] _ in
                   self?.presentLoginScreen()
               }
               return
           }
        
        saveMedicationToFirestore(med: med, userId: currentUser.uid)
        
    }
    
    func delegateOnAddMed(med: Med) {
        guard let currentUser = Auth.auth().currentUser else {
                    showAlert(message: "User is not logged in.") { [weak self] _ in
                        self?.presentLoginScreen()
                    }
                    return
                }
        medList.append(med)
        medListView.tableViewMed.reloadData()
        
                
        saveMedicationToFirestore(med: med, userId: currentUser.uid)
        
    }
    
    func saveMedicationToFirestore(med: Med, userId: String) {
        let medicationData: [String: Any] = [
            "title": med.title ?? "",
            "dosage": med.dosage ?? "",
            "time": med.time as Any
        ]
        
        // Save medication under the user's document
        let userDocRef = database.collection("users").document(userId)
        userDocRef.updateData([
            "medications": FieldValue.arrayUnion([medicationData])
        ]) { error in
            if let error = error {
                self.showAlert(message: "Failed to save medication: \(error.localizedDescription)")
            } else {
                print("Medication saved successfully under user ID: \(userId)")
            }
        }
    }

}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TableViewMedCell.identifier,
                for: indexPath) as! TableViewMedCell
            
            let med = medList[indexPath.row]
            cell.configure(with: med )
            
            return cell
        }
        
}

