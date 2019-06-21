//
//  CategoryTableViewController.swift
//  Todo App
//
//  Created by Osama Fahim on 21/06/2019.
//  Copyright © 2019 Osama Fahim. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate  as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadData()
    }
    
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destination.selectedCategory = categoryArray [indexPath.row]
        }
    }
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textt = UITextField()
        let alert = UIAlertController(title: "Add new TODO Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            // what will happen if user click + button
            let newItem = Category(context: self.context)
            newItem.name = textt.text!
            
            self.categoryArray.append(newItem)
            self.saveData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter category"
            textt = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

    
    //MARK: - Data Manipulation Methods
    func saveData(){
        
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadData(request : NSFetchRequest<Category> = Category.fetchRequest()){
        let request : NSFetchRequest <Category> = Category.fetchRequest()
        
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("Error in fetching the data \(error)")
        }
        
        tableView.reloadData()
    }
    
}