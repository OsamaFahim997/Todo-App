//
//  ViewController.swift
//  Todo App
//
//  Created by Osama Fahim on 18/06/2019.
//  Copyright © 2019 Osama Fahim. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    var dummyArray = [ListObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let newItem = ListObject()
        newItem.title = "Buy Apples"
        let newItem2 = ListObject()
        newItem2.title = "Buy Appjadsjasdkjdasles"
        let newItem3 = ListObject()
        newItem3.title = "Bu"
        dummyArray.append(newItem)
        dummyArray.append(newItem2)
        dummyArray.append(newItem3)
        
        if let items = defaults.array(forKey: "ToDoArray") as? [ListObject]{
            dummyArray = items
        }
    }
    
    
    //MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = dummyArray[indexPath.row]
        
        print("Other method\(indexPath.row)")
        cell.textLabel?.text = item.title
        
        //Ternary Operator => value = condition ? if true : if false
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Delegate methods\(indexPath.row)")
        dummyArray[indexPath.row].done = !dummyArray[indexPath.row].done
        print("\(dummyArray[indexPath.row].done)")
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK- Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textt = UITextField()
        let alert = UIAlertController(title: "Add new TODO item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add items", style: .default) { (action) in
            
            // what will happen if user click + button
            let newItem = ListObject()
            newItem.title = textt.text!
            
            self.dummyArray.append(newItem)
            self.defaults.set(self.dummyArray, forKey: "ToDoArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter your Item"
            textt = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
}

