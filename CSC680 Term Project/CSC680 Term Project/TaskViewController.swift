//
//  ViewController.swift
//  CSC680 Term Project
//
//  Created by Darren Wong on 11/26/22.
//

import UIKit
import CoreData

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, AddTodoProtocol {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var taskModels = [TaskItem]()
    var filteredData = [TaskItem]()
    
    private let searchVC = UISearchController(searchResultsController: nil)
    
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
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem (barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        view.addSubview(tableView)
        loadAllTasks()
        
        filteredData = taskModels
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = taskModels[indexPath.row]
        self.deleteTask(item: item)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = taskModels[indexPath.row]
        
//
//         let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
//
//        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
//            let alert = UIAlertController(title: "Edit Item", message: "Edit your item", preferredStyle: .alert)
//            alert.addTextField(configurationHandler: nil)
//            alert.textFields?.first?.text = item.name
//            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
//                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
//                    return
//                }
//                self?.updateTask(task: item, name: newName)
//
//            }))
//            self.present(alert, animated: true)
//        }))
        
//        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
//
//        }))

        //present(sheet, animated: true)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SeeTaskViewController") as? SeeTaskViewController {
            self.navigationController?.pushViewController(vc, animated: true)
//            vc.title1TF?.text = item.name
//            vc.desc1TF?.text = item.taskDescription
            vc.taskTitle = item.name ?? ""
            vc.taskDesc = item.taskDescription ?? ""
            print(item.name)
            //vc.desc1TF?.text = item.taskDescription
        }
    }
    
    private func createSearchBar(){
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filteredData = taskModels
        }
        else{
            loadAllTasks(name: searchText)
            //filteredData = taskModels
            self.tableView.reloadData()
        }
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
    func loadAllTasks(name: String){
        do {
            let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
            let predicate = NSPredicate(format: "name CONTAINS %a", name)
            fetchRequest.predicate = predicate
            taskModels = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            
        }
    }
    
    func createTask(name: String, desc: String){
        let newTask = TaskItem(context: context)
        newTask.name = name
        //MARK FIX
        newTask.taskDescription = desc
        newTask.createdAt = Date()
        //MARK: Edit date to take input for a due date for a task
        newTask.doTaskBy = Date()
        
        do {
            try context.save()
            loadAllTasks()
            filteredData = taskModels
        }
        catch {
            
        }
    }
    
    func deleteTask(item: TaskItem){
        context.delete(item)
        
        do {
            try context.save()
            loadAllTasks()
            filteredData = taskModels
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
            filteredData = taskModels
        }
        catch{
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addTodoViewController = segue.destination as? AddTodoViewController {
            addTodoViewController.delegate = self
        }
    }
}

