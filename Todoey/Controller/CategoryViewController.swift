//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Oybek on 2/8/21.
//

import UIKit
import RealmSwift
import ChameleonFramework
class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = .systemBlue
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
    }
    
    
    // MARK: - Table View DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            cell.backgroundColor = UIColor(hexString: category.color)
            cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: category.color)!, returnFlat: true)
        }
        
        return cell
    }
    
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    
    // MARK: - Add new Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        var textField = UITextField()
        alert.addTextField { (alerttextField) in
            alerttextField.placeholder = "Type Category"
            textField = alerttextField
        }
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            self.save(category: newCategory)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Data manipulation
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            } catch {
                print(error)
            }
            
        }
        
    }
}

