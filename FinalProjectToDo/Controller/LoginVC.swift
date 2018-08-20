//
//  LoginVC.swift
//  FinalProjectToDo
//
//  Created by Jonathan Compton on 8/19/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 

    @IBAction func loginTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email.count > 0, password.count > 0 else {return}
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error Authenticating, \(error.localizedDescription)")
            } else {
                print(result!.user.uid)
                self.performSegue(withIdentifier: "toTasksVCFromLoginVC", sender: nil)
            }
        }
    }
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
