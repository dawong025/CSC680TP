//
//  EditTaskViewController.swift
//  CSC680 Term Project
//
//  Created by Darren Wong on 12/13/22.
//

import Foundation
import UIKit

var itemUpdate = [TaskItem]()
protocol EditTodoProtocol {
    func updateTask(task: TaskItem, name: String, desc: String)
}
class EditTaskViewController: UIViewController {
    var delegate: EditTodoProtocol?
    
    @IBOutlet weak var editTitleTF: UITextField!
    @IBOutlet weak var editDescTF: UITextView!
    
    @IBAction func editSaveAction(_ sender: Any) {
        let item = itemUpdate[0]
        
        var nameUpdated = ""
        var descUpdated = ""
        
        if editTitleTF.text == nil {
            nameUpdated = item.name ?? "this shouldnt happen"
        }
        else {
            nameUpdated = editTitleTF.text ?? "this shouldnt happen"
        }
        if editDescTF.text == nil {
            descUpdated = item.taskDescription ?? "this shouldnt happen"
        }
        else {
            descUpdated = editDescTF.text
        }
        
        delegate?.updateTask(task: item, name: nameUpdated, desc: descUpdated)
        itemUpdate.removeAll()
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        
        self.title = "Edit Task"
    }
}
