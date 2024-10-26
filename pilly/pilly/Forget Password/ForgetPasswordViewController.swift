//
//  ForgetPasswordViewController.swift
//  pilly
//
//  Created by Belen Tesfaye on 10/25/24.
//

import UIKit

class ForgetPasswordViewController: UIViewController {
    
    let forgetPasswordScreen = ForgetPasswordView()
    
    override func loadView() {
        view = forgetPasswordScreen
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Forgot Password"
        
        forgetPasswordScreen.submitButton.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func sendEmail() {
        if let email = forgetPasswordScreen.emailTextField.text, !email.isEmpty {
            if isValidEmail(email) {
                showAlert(title: "Email Sent", message: "If an email address is linked to an existing account, we will send instructions on how to reset your password.")
            } else {
                showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            }
        } else {
            showAlert(title: "Input Error", message: "Email field cannot be empty.")
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

