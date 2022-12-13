//
//  CoreData.swift
//  CSC680 Term Project
//
//  Created by Darren Wong on 12/12/22.
//

import Foundation
import CoreData

func loadAllTasks(){
    do {
        taskModels = try context.fetch(TaskItem.fetchRequest())
        DispatchQueue.main.async {
            tableView.reloadData()
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
