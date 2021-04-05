//
//  signInViewController.swift
//  CenticBids
//
//  Created by Pruthvi Nithyanandan on 2021-03-29.
//

import UIKit
import FirebaseAuth

class signInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Text field delegate
        self.usernameField.delegate = self
        self.passwordField.delegate = self
    }
    
    // user clicks on sign in button to submit sign in form
    @IBAction func signInBtnPressed(_ sender: UIButton) {
        self.signInUser()
    }
    
    // close sign in modal
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    // sign in form submition method
    func signInUser() {
        // simple required validation for required fields
        guard let email = usernameField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            let alert = Alert.triggerAlert(title: "Error", msg: "Username & Password fields are required")
            self.present(alert, animated: true)
            return
        }
        
        // sign in API call
        SignInService.shared.signInUser(email: email, password: password, completion: {success, msg in
            if success {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: CommonConfig.signInCompleted, object: nil)
                    self.dismiss(animated: true)
                }
            } else {
                print("error", msg)
                // Alert error message
                let alert = Alert.triggerAlert(title: "Error", msg: msg)
                self.present(alert, animated: true)
            }
        })
    }
    
    // method to hide keyboard when press return key on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }

}
