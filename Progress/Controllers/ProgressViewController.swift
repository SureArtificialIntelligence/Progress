//
//  ViewController.swift
//  Progress
//
//  Created by Sure on 09.05.19.
//  Copyright © 2019 Sure. All rights reserved.
//

import UIKit
import CoreData

class ProgressViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : CategoryParent? {
        didSet{
            loadItems()
        }
    }
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        let item1  = Item()
//        item1.title = "vegetables"
//        itemArray.append(item1)
//        let item2  = Item()
//        item2.title = "fruits"
//        itemArray.append(item2)
//        let item3  = Item()
//        item3.title = "meat"
//        itemArray.append(item3)
        
        loadItems()
//        if let items = defaults.array(forKey: "ProgressArray") as? [Item] {
//            itemArray = items
//       }
    }

    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // update data
        //itemArray[indexPath.row].setValue("heiheihei", forKey: "title")
        
        // delete data
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        saveItems()
        tableView.reloadData()
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // add item if click add
            
            let item = Item(context: self.context)
            item.title = textField.text!
            item.done = false
            item.parentCat = self.selectedCategory
            self.itemArray.append(item)
            
            //self.defaults.set(self.itemArray, forKey: "ProgressArray")
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manupulation Methods
    func saveItems() {
        do {
            try context.save()
        }catch{
            print("Error: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categorypredicate = NSPredicate(format: "parentCat.cat MATCHES %@", selectedCategory!.cat!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate, additionalPredicate])
        }else{
            request.predicate = categorypredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        }catch{
            print("Error: \(error)")
        }
        
        self.tableView.reloadData()
    }
}


//MARK - search bar methods
extension ProgressViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)

    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
     }
}

