//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import SwipeCellKit

class TodoListViewController: SwipeTableViewController {

//    let defaults = UserDefaults.standard
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let realm = try! Realm()
    
    var todoItems: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedCategory?.name
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color {
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Navigation Controller Doesn't exist")
            }
            if let navBarColor = UIColor(hexString: colorHex) {
                navBar.backgroundColor = navBarColor
                navBar.barTintColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : navBar.tintColor!]
                navBar.largeTitleTextAttributes = navBar.titleTextAttributes
                
                searchBar.barTintColor = UIColor(hexString: colorHex)
                searchBar.searchTextField.backgroundColor = navBar.tintColor
                searchBar.searchTextField.textColor = navBarColor
            }
        }
    }
    
    // MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            // Teranaty Operator ===>
            // value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggleItem(at: indexPath.row)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            // What will happen once the user clicks the Add Item button on our alert
            if textField.text != "" {
                let newItem = Item()
                newItem.title = textField.text!
                newItem.dateCreated = Date()
                
                self.saveItems(item: newItem)
            }
            print("Success!")
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK- Data Manipulation Methods
    
    func saveItems(item: Item) {
        do {
            try realm.write {
                if let currentCategory = self.selectedCategory {
                    currentCategory.items.append(item)
                }
            }
        } catch {
            print("Error saving item, \(error)")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    func toggleItem(at index: Int) {
        if let item = todoItems?[index] {
            do {
                try realm.write({
                    item.done.toggle()
                })
            } catch {
                print("Error Saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        deletItem(at: indexPath)
    }
    
    func deletItem(at index: IndexPath) {
        if let item = todoItems?[index.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
}


// MARK - SearchBar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.isEmpty ?? false {
            loadItems()
            DispatchQueue.main.async {
                // Notify this object that it has been asked to relinquish its status as first responder in its window.
                searchBar.resignFirstResponder()
            }
        }
    }
}
