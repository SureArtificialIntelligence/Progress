//
//  CategoryViewController.swift
//  Progress
//
//  Created by Sure on 13.05.19.
//  Copyright © 2019 Sure. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [CategoryParent]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategory()
    }
    
    //MARK: -TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressCategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].cat
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //tableView.reloadData()
        //tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "go2GG", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ProgressViewController
        
        if let selectedRow = tableView.indexPathForSelectedRow{
            print(selectedRow.row)
            destinationVC.selectedCategory = categoryArray[selectedRow.row]
        }
    }
    
    //MARK: -TableView Manipulation Methods
    
    
    //MARK: -add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textTrans = UITextField()
        let alert = UIAlertController(title: "Add a Tag", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add one Tag"
            textTrans = alertTextField
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newtag = CategoryParent(context: self.context)
            newtag.cat = textTrans.text!
            self.categoryArray.append(newtag)
            self.saveCategory()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
}
    
    
    //MARK: -TableView Delegate Methods
    func saveCategory() {
        do {
            try context.save()
        }catch{
            print("Error: \(error) ")
        }
        self.tableView.reloadData()
    }
    
    func loadCategory(with request: NSFetchRequest<CategoryParent> = CategoryParent.fetchRequest()) {
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("Error loading: \(error)")
        }
        
        tableView.reloadData()
    }
}

//extension CategoryViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSRequest
//    }
//}
