//
//  ViewController.swift
//  Todo App
//
//  Created by Osama Fahim on 18/06/2019.
//  Copyright © 2019 Osama Fahim. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    let realm = try! Realm()
    var toDoItems : Results<Item>?
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
        //loadData()
    
    }

    
    //MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            //Ternary Operator => value = condition ? if true : if false
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else{
                cell.textLabel?.text = "No Items Added yet!"
        }
        return cell
    }
    
    
    //MARK- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row]{
            do{
                try realm.write {
                    
                    //for delete
                    //realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("Error in saving done property \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK- Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textt = UITextField()
        let alert = UIAlertController(title: "Add new TODO item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add items", style: .default) { (action) in

            // what will happen if user click + button
            if let category = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textt.text!
                        newItem.dateCreated = Date()
                        category.items.append(newItem)
                    }
                }catch{
                    print("Error saving Data \(error)")
                }
            }
                
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter your Item"
            textt = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)


    }

    //MARK: - Load Items
    func loadData(){
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

    //    //MARK: - Search Items
extension TodoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
          toDoItems = toDoItems?.filter("title CONTAINS[cd] %a", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
          tableView.reloadData()
        
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
