
//  ViewController.swift
//  Todoey
//
//  Created by viswa kodela on 4/27/18.
//  Copyright © 2018 viswa kodela. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet{
            
            loadItem()
            
        }
        
    }
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
     //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        

        
    }
    
    // MARK: - Tavleview Datasourse Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            // Terenary Operator
            // Value = Contion ? ValueIfTrue : ValueIfFalse
            
            cell.accessoryType = item.done == true ? .checkmark : .none
        }
        else {
            
            cell.textLabel?.text = "No items Added"
            
        }
        
        
        
        
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        
        
        return cell
    }

    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        // MARK: Delete in CURD
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
        if let item = todoItems?[indexPath.row] {
            do{
            try realm.write {
                //realm.delete(item)
               item.done = !item.done
            }
            }catch{
                print("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        
        // deselectRow() is a method whcich is used to controle the animations, when the user presses any row its color will chnages to gray and will become still with that grey color. If we use deselect() method we can animate the pressed row in thetable with grey color.
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add new Todo Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            // anything written in this clousers, is the code this happens when the user clicks the "Add Items" Button in the Alert Cotroller.

            // let newItem = item()


            if let currentCategory = self.selectedCategory {
                
                do{
                    // Saving the Data
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch {
                    print("Error saving new item \(error)")
                
            }
            
                self.tableView.reloadData()
            
            // the line below is the reason for attaching the parent and the item
            //newItem.parentCategory = self.selectedCategory?
            


        }
    }

        alert.addTextField { (alertTextField) in

            alertTextField.placeholder = "Create new item"
            textField = alertTextField

        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

    
    func loadItem() {

 
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }


}

// MARK: - UISearchBar Delegate Methods

extension ToDoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadItem()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }

    
}
    
    


