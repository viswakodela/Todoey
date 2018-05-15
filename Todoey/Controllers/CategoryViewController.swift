//
//  CategoryViewController.swift
//  Todoey
//
//  Created by viswa kodela on 5/10/18.
//  Copyright © 2018 viswa kodela. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()
    }

    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
        let newCategory = Category()
            newCategory.name = textField.text!
            // As Results<Category> is an auto updating container we don't need to append anything to it.
            //self.categories.append(newCategory)
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Enter your Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        

 }
        
    
    
    //MARK: - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        // ?? is Nil Coalescing Operator which says that, if Caregorites is nil then print only one row
        return categories?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        cell.textLabel?.text =  categories?[indexPath.row].name ?? "No Categories added yet"
        
        return cell
    }
    
    //MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(categoryArray[indexPath.row])
//        tableView.delete(categoryArray[indexPath.row])
    
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK:- prepare for segue i function is going to execute before performSegue line of code
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
        
        
    }
    
    
    
    //MARK: - TableView Data Manipulation
    
    func save(category: Category){
        
        do {
            try realm.write {
                realm.add(category)
            }
        }catch{
           print("Error saving Categories \(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
}
