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
import MapKit

class ViewController: UIViewController, AddAccountDelegate {
    
    let notificationCenter = NotificationCenter.default
    var currentUser: FirebaseAuth.User?
    var handleAuth: AuthStateDidChangeListenerHandle?
    let database = Firestore.firestore()
    
    var medList = [Med]()
    var mainScreenView = MainScreenView()
    var medListView = MedListView()
    let mapView = MapView()
    var locationManager: CLLocationManager!
    
    override func loadView() {
        view = mainScreenView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager = CLLocationManager()
        
        handleAuth = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            
            if user == nil {
                // User is logged out
                self.currentUser = nil
                self.presentLoginScreen()
            } else {
                // User is logged in
                self.currentUser = user
                self.switchToMedListView()
                self.switchToMainTabBar()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        medListView.frame = self.view.bounds
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func didCompleteAccountCreation() {
        let medMainVC = HomeViewController() // Update with correct controller
        navigationController?.pushViewController(medMainVC, animated: true)
    }

    func switchToMainTabBar() {
        DispatchQueue.main.async {
            guard !(self.view.window?.rootViewController is MainTabBarController) else { return }
            let mainTabBarController = MainTabBarController()
            self.view.window?.rootViewController = mainTabBarController
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    func switchToMedListView() {
        let medVC = HomeViewController()
        navigationController?.pushViewController(medVC, animated: true)
//        view = medListView
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
            
            DispatchQueue.main.async {
                let mainVC = ViewController()
                let navigationController = UINavigationController(rootViewController: mainVC)
                self.view.window?.rootViewController = navigationController
                self.view.window?.makeKeyAndVisible()
            }
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
            guard let email = signInAlert.textFields?[0].text,
                  let password = signInAlert.textFields?[1].text else { return }
            self?.signInToFirebase(email: email, password: password)
        }
        
        let registerAction = UIAlertAction(title: "Register", style: .default) { [weak self] _ in
            let addAccountVC = AddAccountViewController()
            addAccountVC.delegate = self
            self?.navigationController?.pushViewController(addAccountVC, animated: true)
        }
        
        let forgotPasswordAction = UIAlertAction(title: "Forgot Password?", style: .default) { [weak self] _ in
            self?.resetPassword()
        }
        
        signInAlert.addAction(signInAction)
        signInAlert.addAction(registerAction)
        signInAlert.addAction(forgotPasswordAction)
        present(signInAlert, animated: true)
    }
    
    func resetPassword() {
        let resetPasswordAlert = UIAlertController(
            title: "Reset Password",
            message: "Enter your email address to receive a password reset link.",
            preferredStyle: .alert)
        
        resetPasswordAlert.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }
        
        let resetAction = UIAlertAction(title: "Reset Password", style: .default) { [weak self] _ in
            guard let email = resetPasswordAlert.textFields?.first?.text, !email.isEmpty else {
                self?.showAlert(message: "Please enter your email.")
                return
            }
            
            self?.sendPasswordResetEmail(email: email)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        resetPasswordAlert.addAction(resetAction)
        resetPasswordAlert.addAction(cancelAction)
        present(resetPasswordAlert, animated: true)
    }

    func sendPasswordResetEmail(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error {
                self?.showAlert(message: "Error: \(error.localizedDescription)")
            } else {
                self?.showAlert(message: "Password reset email sent. Please check your inbox.")
            }
        }
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
            self?.switchToMainTabBar()
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
            "amount": med.amount ?? "",
            "dosage": med.dosage?.rawValue ?? "",
            "frequency": med.frequency?.rawValue ?? "",
            "time": med.time ?? "",
            "completionDates": [:],
            "createdAt": FieldValue.serverTimestamp()
        ]
        
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
extension MKMapView{
    func centerToLocation(location: CLLocation, radius: CLLocationDistance = 1000){
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: radius,
            longitudinalMeters: radius
        )
        setRegion(coordinateRegion, animated: true)
    }
}

