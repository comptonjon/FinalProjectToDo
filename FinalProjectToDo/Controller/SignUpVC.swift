//
//  SignUpVC.swift
//  FinalProjectToDo
//
//  Created by Jonathan Compton on 8/19/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        guard let name = nameTextField.text, name.count > 0, let email = emailTextField.text, email.count > 0, let password = passwordTextField.text, password.count > 0, password == passwordTextField.text! else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let user = result?.user {
                self.setUserName(user: user, name: name)
                self.performSegue(withIdentifier: "signUpVCtoTasksVC", sender: nil)
                
            } else {
                print("Error logging in")
            }
        }
    }
    
    func setUserName(user: User, name: String) {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        
        changeRequest.commitChanges(){ (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            UserManager.shared.didLogIn(user: user)
        }
    }
    
    
}
