
//  ViewController.swift
//  Todoey
//
//  Created by viswa kodela on 4/27/18.
//  Copyright © 2018 viswa kodela. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    
    var itemArray = [item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    
    override func viewDidLoad() {
        super.viewDidLoad()

        

        
        print(dataFilePath!)
        
        let newItem = item()
        newItem.title = "Buy Eggs"
        itemArray.append(newItem)
        
        let newItem2 = item()
        newItem2.title = "Watch my Phone"
        itemArray.append(newItem2)
        
        let newItem3 = item()
        newItem3.title = "Meeting with Chatby"
        itemArray.append(newItem3)
        
        
        
        loadItem()
        
        
    }
    
    //MARK - Tavleview Datasourse Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Trenary Operator
        // Value = Contion ? ValueIfTrue : ValueIfFalse
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        
        
        return cell
    }

    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
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
            
            let newItem = item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()

            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do{
            
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch {
            
            print("Error encoding item array \(error)")
            
        }
        
        tableView.reloadData()
        
    }
    
    func loadItem() {
        
        let decoder = PropertyListDecoder()
        
        if let data = try? Data(contentsOf: dataFilePath!){
            
            do{
                itemArray = try decoder.decode([item].self, from: data)
            }catch{
                
                print("Error decoding Item Array \(error)")
                
            }
            
        }
        
        
    }


}

