//
//  SignUpVC.swift
//  FinalProjectToDo
//
//  Created by Jonathan Compton on 8/19/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
