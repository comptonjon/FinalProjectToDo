//
//  DetailVC.swift
//  FinalProjectToDo
//
//  Created by Jonathan Compton on 8/19/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit

class DetailVC: UIViewController, DateDueDelegate {
    
    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var isPriority: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    
    var task: Task?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let task = task {
            label.text = task.title!
        } 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let task = task {
            task.isPriority = self.isPriority.isOn
        }
        CDManager.shared.saveContext()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDateDueVC" {
            let destinationVC = segue.destination as! DateDueVC
            destinationVC.delegate = self
        }
    }
    
    func setDateDue(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, YYYY H:mm a"
        let stringDate = formatter.string(from: date)
        dateLabel.text = stringDate
    }


}
