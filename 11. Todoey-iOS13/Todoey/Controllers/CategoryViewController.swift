//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Usama Fouad on 09/10/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    // realm.objects(): Returns a data of type Results
    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0
    }

    
    // MARK - TableView DataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name 
                
            cell.backgroundColor = UIColor(hexString: category.color )
        }
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    // MARK - Data Manapulation Methods
    
    func saveCategories(category: Category) {
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        deleteCategory(at: indexPath)
    }
    
    func deleteCategory(at index: IndexPath) {
        if let category = categories?[index.row] {
            do {
                try realm.write {
                    realm.delete(category)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    // MARK - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            // What will happen once the user clicks the Add Category button on our alert
            if textField.text != "" {
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.color = UIColor.randomFlat().hexValue()
                // We don't need to append category any more as the "Result" data-type is auto updated container.
                
                self.saveCategories(category: newCategory)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
            
        alert.addTextField { field in
            field.placeholder = "Create New category"
            textField = field
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
            
    }

    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}
