//
//  ViewController.swift
//  Todo App
//
//  Created by Osama Fahim on 18/06/2019.
//  Copyright © 2019 Osama Fahim. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var dummyArray = [ListObject]()
    //File where data is storing
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadData()
    }
    
    
    //MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = dummyArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary Operator => value = condition ? if true : if false
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dummyArray[indexPath.row].done = !dummyArray[indexPath.row].done
        saveData()
        
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
            self.saveData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter your Item"
            textt = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK - Saving Encoded Data
    func saveData(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(dummyArray)
            try data.write(to : dataFilePath!)
        }catch{
            print("Error in encoding the data \(error)")
        }
        
        self.tableView.reloadData()

    }
    
    func loadData(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                dummyArray = try decoder.decode([ListObject].self, from: data)
            }catch{
                print("Error in decoding the data \(error)")
            }
        }
    }
}

