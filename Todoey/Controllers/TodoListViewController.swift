//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NavigationDesign().navigationSetting(naviController: self)
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        
        //        let newItem = Item()
        //        newItem.title = "Work"
        //        itemArray.append(newItem)
        //
        //        let newItem2 = Item()
        //        newItem2.title = "Study"
        //        itemArray.append(newItem2)
        //
        //        let newItem3 = Item()
        //        newItem3.title = "Shopping"
        //        itemArray.append(newItem3)
        
        //    loadItems()
        
    }
    
    //MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            //Ternary operator ==>
            //value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        return cell
    }
    
    
    //MARK: - TableView Delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write({
                    // realm.delete(item)
                    item.done = !item.done
                })
            } catch {
                print("Error saving done status \(error)")
            }
        }
        tableView.reloadData()
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey item.", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //What will happen when user clicks the Add Item button on our UIAlert
          
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving context \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manupulation Methods
    
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

//MARK: - search bar method

extension TodoListViewController: UISearchBarDelegate {
    
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
    
//            let request: NSFetchRequest<Item> = Item.fetchRequest()
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//            loadItems(with: request, predict: predicate)
        
    
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0 {
                loadItems()
    
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }
        }
}
