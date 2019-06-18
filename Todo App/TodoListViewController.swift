//
//  ViewController.swift
//  Todo App
//
//  Created by Osama Fahim on 18/06/2019.
//  Copyright © 2019 Osama Fahim. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var dummyArray = ["Buy Apples", "Meet someone", "Go to World Tour"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
            cell.textLabel?.text = dummyArray[indexPath.row]
            return cell
    }

    
    //MARK- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK- Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textt = UITextField()
        let alert = UIAlertController(title: "Add new TODO item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add items", style: .default) { (action) in
            
            // what will happen if user click + button
            self.dummyArray.append(textt.text!)
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

