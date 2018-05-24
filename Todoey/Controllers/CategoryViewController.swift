//
//  CategoryViewController.swift
//  Todoey
//
//  Created by viswa kodela on 5/10/18.
//  Copyright © 2018 viswa kodela. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }

    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
        let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
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
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            
            cell.textLabel?.text = category.name
            guard let categoryColor = UIColor(hexString: category.color) else{fatalError()}
            cell.backgroundColor = UIColor(hexString: category.color )
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
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
    
    override func updateTableView(at indexPath: IndexPath) {
        if let categoriesForDeletion = categories?[indexPath.row] {
            do{
                try realm.write {
                    realm.delete(categoriesForDeletion)
                }
            }
            catch {
                    print("Error Deleting the Categories \(error)")
            }
            
        }
    }
    
    
    //MARK: - TableView Data Manipulation
    
    func save(category: Category){
        
        do {
            try realm.write {
                realm.add(category)
            }
        }
        
        catch{
           print("Error saving Categories \(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadCategories() {
        
        // Pulls all of the Objects that are of type Category
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
}
