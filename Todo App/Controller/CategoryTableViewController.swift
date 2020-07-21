//
//  CategoryTableViewController.swift
//  Todo App
//
//  Created by Osama Fahim on 21/06/2019.
//  Copyright © 2019 Osama Fahim. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryTableViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("UID is \(UIDevice.current.identifierForVendor!.uuidString)")
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadData()
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let navBar = navigationController?.navigationBar  {
            navBar.barTintColor = UIColor(hexString: "8186D5")
        }
    }
    
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet!"
       
        cell.backgroundColor = UIColor(hexString: categoryArray?[indexPath.row].hexcode ?? "1D9BF3") 

        return cell
    }
    
    
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destination.selectedCategory = categoryArray? [indexPath.row]
        }
    }
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textt = UITextField()
        let alert = UIAlertController(title: "Add new Name", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add name", style: .default) { (action) in
            
            // what will happen if user click + button
            let newItem = Category()
            newItem.name = textt.text!
            newItem.hexcode = UIColor.randomFlat.hexValue()
        //    print(newItem.hexcode)
            self.saveData( category: newItem)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter name"
            textt = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

    
    //MARK: - Data Manipulation Methods
    func saveData( category : Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadData(){
        categoryArray = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    override func updateModal(at indexPath: IndexPath) {
           if let item = self.categoryArray?[indexPath.row]{
                do{
                    try self.realm.write {
                    self.realm.delete(item)
                   }
                }catch{
                    print("Error in saving done property \(error)")
                }
                            //tableView.reloadData()
          }
    }
    
}
