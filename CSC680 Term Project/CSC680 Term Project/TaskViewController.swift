//
//  ViewController.swift
//  CSC680 Term Project
//
//  Created by Darren Wong on 11/26/22.
//

import UIKit
import CoreData

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    private let searchVC = UISearchController(searchResultsController: nil)
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var taskModels = [TaskItem]()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "ProcrastiNOTe"
        //navigationItem.searchController = searchController
        createSearchBar()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem (barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        view.addSubview(tableView)
        loadAllTasks()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
    }
    
    //Prompts to Create, Edit, and Delete Tasks
    @objc private func didTapAdd(){
        let alert = UIAlertController(title: "New Item", message: "Enter new item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self?.createTask(name: text)
        }))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = taskModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = taskModels[indexPath.row]
        
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let alert = UIAlertController(title: "Edit Item", message: "Edit your item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
                self?.updateTask(task: item, name: newName)
                
            }))
            self.present(alert, animated: true)
        }))
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteTask(item: item)
        }))

        present(sheet, animated: true)
    }
    
    private func createSearchBar(){
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        loadAllTasks()
    }
    
    //Core Data - Load, Create, Delete, and Update Tasks
    func loadAllTasks(){
        do {
            taskModels = try context.fetch(TaskItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            
        }
    }
    
    func createTask(name: String){
        let newTask = TaskItem(context: context)
        newTask.name = name
        //MARK FIX
        newTask.taskDescription = "Hello"
        newTask.createdAt = Date()
        //MARK: Edit date to take input for a due date for a task
        newTask.doTaskBy = Date()
        
        do {
            try context.save()
            loadAllTasks()
        }
        catch {
            
        }
    }
    
    func deleteTask(item: TaskItem){
        context.delete(item)
        
        do {
            try context.save()
            loadAllTasks()
        }
        catch{
            
        }
    }
    
    func updateTask(task: TaskItem, name: String){
        task.name = name
        task.taskDescription = "Updated"
        
        //MARK: Edit date to take input for a due date for a task
        task.doTaskBy = Date()
        do {
            try context.save()
            loadAllTasks()
        }
        catch{
            
        }
    }


}
