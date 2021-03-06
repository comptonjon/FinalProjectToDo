//
//  MasterVC.swift
//  FinalProjectToDo
//
//  Created by Jonathan Compton on 8/18/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit
import CoreData
import FirebaseDatabase
import FirebaseAuth

class MasterVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref : DatabaseReference!
    var addHandle : DatabaseHandle!
    var deleteHandle: DatabaseHandle!
    var changeHandle: DatabaseHandle!
    
    var tasks = [Task]()
    var selectedTask: Task!
    
    let context = CDManager.shared.context()

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(unwindFunction))
        let prioritySort = NSSortDescriptor(key: "isPriority", ascending: false)
        let nameSort = NSSortDescriptor(key: "title", ascending: false)
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        fetchRequest.sortDescriptors = [prioritySort, nameSort]
        do {
            let results = try context.fetch(fetchRequest) as [Task]
            tasks = results
        } catch {
            print("Error Fetching")
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 140
        tableView.layer.borderWidth = 2
        
    }
    
    @objc func unwindFunction() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserManager.shared.loggedIn = false
            performSegue(withIdentifier: "unwindToHomeVC", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addHandle = ref.child("Tasks").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            let key = snapshot.key
            if self.tasks.filter({$0.uid! == key}).isEmpty {
                let value = snapshot.value as! [String: Any]
                let title = value["title"] as! String
                let isPriority = value["isPriority"] as! Bool
                let newTask = Task(context: self.context)
                newTask.title = title
                newTask.uid = key
                newTask.isPriority = isPriority
                newTask.lastUpdated = value["lastUpdated"] as! Double
                CDManager.shared.saveContext()
                self.tasks.append(newTask)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            }
        })
        
        deleteHandle = ref.child("Tasks").observe(.childRemoved, with: { (snapshot) in
            let key = snapshot.key
            if let taskToDelete = self.tasks.filter({$0.uid! == key}).first {
                self.context.delete(taskToDelete)
                let index = self.tasks.index(of: taskToDelete)
                self.tasks.remove(at: index!)
                CDManager.shared.saveContext()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
        
        changeHandle = ref.child("Tasks").observe(.childChanged, with: { (snapshot) in
            let key = snapshot.key
            let value = snapshot.value as! [String:Any]
            let lastUpdated = value["lastUpdated"] as! Double
            if let task = self.tasks.filter({ $0.uid! == key }).first {
                if task.lastUpdated < lastUpdated {
                    task.title = (value["title"] as! String)
                    task.isPriority = value["isPriority"] as! Bool
                    task.lastUpdated = (value["lastUpdated"] as! Double)
                    CDManager.shared.saveContext()
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
        
        tableView.reloadData()
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Add Item", message: "Enter a new item", preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        ac.addTextField(configurationHandler: nil)
        ac.textFields?.first?.placeholder = "Add Task"
        ac.textFields?.last?.placeholder = "Add Details"
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            let title = ac.textFields?.first?.text!
            let id = UUID().uuidString
            let newTask = Task(context: self.context)
            let timeCreated = Date().timeIntervalSince1970
            newTask.title = title
            newTask.uid = id
            newTask.isPriority = false
            newTask.lastUpdated = timeCreated
            CDManager.shared.saveContext()
            self.tasks.append(newTask)
            self.tableView.reloadData()
            let value : [String : Any] = ["title" : title!, "lastUpdated" : timeCreated, "isPriority" : false]
            self.ref.child("Tasks").child(id).setValue(value)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("Dismissed")
        }
        ac.addAction(cancelAction)
        ac.addAction(addAction)
        present(ac, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVCFromTaskVC" {
            let destinationVC = segue.destination as! DetailVC
            let indexPath = tableView.indexPathForSelectedRow
            destinationVC.task = tasks[indexPath!.row]
        }
    }

}

extension MasterVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TaskCell
        cell.titleLabel.text = tasks[indexPath.row].title
        return cell
    }
}

extension MasterVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            let id = task.uid
            tasks.remove(at: indexPath.row)
            context.delete(task)
            CDManager.shared.saveContext()
            ref.child("Tasks").child(id!).removeValue()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let task = tasks[indexPath.row]
        let priority = task.isPriority
        task.lastUpdated = Date().timeIntervalSince1970
        let value : [String : Any] = ["title" : task.title!, "lastUpdated" : task.lastUpdated, "isPriority" : priority]
        ref.child("Tasks").child(task.uid!).setValue(value)
        CDManager.shared.saveContext()
        performSegue(withIdentifier: "toDetailVCFromTaskVC", sender: nil)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
