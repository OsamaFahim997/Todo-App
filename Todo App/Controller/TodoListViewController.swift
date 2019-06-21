//
//  ViewController.swift
//  Todo App
//
//  Created by Osama Fahim on 18/06/2019.
//  Copyright © 2019 Osama Fahim. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var dummyArray = [Item]()
    var selectedCategory: Category? {
        didSet{
            loadData()
        }
    }
    
    let context = (UIApplication.shared.delegate  as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
        
        context.delete(dummyArray[indexPath.row])
        dummyArray.remove(at: indexPath.row)
        
        dummyArray[indexPath.row].done = !dummyArray[indexPath.row].done
        saveData()
        
        //tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK- Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textt = UITextField()
        let alert = UIAlertController(title: "Add new TODO item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add items", style: .default) { (action) in
            
            // what will happen if user click + button
            let newItem = Item(context: self.context)
            newItem.title = textt.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
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
        
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()

    }
    
    func loadData(request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate ,additionalPredicate])
            print("errorjdsjasjkd")
        }
        else{
            request.predicate = categoryPredicate
            print("ERROR")
        }
        
        do{
            dummyArray = try context.fetch(request)
        }catch{
            print("Error in fetching the data \(error)")
         }
        
        tableView.reloadData()
    }
}

    // Search Items
extension TodoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let newRequest : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        newRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(request: newRequest, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchBar.text?.count == 0){
            loadData()
        
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    }
}

