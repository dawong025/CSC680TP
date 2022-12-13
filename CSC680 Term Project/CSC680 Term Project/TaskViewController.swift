//
//  ViewController.swift
//  CSC680 Term Project
//
//  Created by Darren Wong on 11/26/22.
//

import UIKit
import CoreData

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, AddTodoProtocol, EditTodoProtocol {
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

        if let vc = storyboard?.instantiateViewController(withIdentifier: "SeeTaskViewController") as? SeeTaskViewController {
            self.navigationController?.pushViewController(vc, animated: true)
//            vc.title1TF?.text = item.name
//            vc.desc1TF?.text = item.taskDescription

            vc.taskTitle = item.name ?? ""
            vc.taskDesc = item.taskDescription ?? ""
            itemUpdate.append(item)
            print(itemUpdate[0].name)
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
    
    func updateTask(task: TaskItem, name: String, desc: String){
        task.name = name
        task.taskDescription = desc
        
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

