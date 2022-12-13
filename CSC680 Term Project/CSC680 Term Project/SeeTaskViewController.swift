//
//  SeeTaskViewController.swift
//  CSC680 Term Project
//
//  Created by Darren Wong on 12/12/22.
//

import Foundation
import UIKit

protocol DeleteTodoProtocol {
    func deleteTask(item: TaskItem)
}

class SeeTaskViewController: UIViewController {
    
    var itemDelete = [TaskItem]()
    
    @IBOutlet weak var title1TF: UILabel!
    @IBOutlet weak var desc1TF: UILabel!
    var delegate: DeleteTodoProtocol?
    
//    @IBAction func deleteAction(_ sender: Any) {
//        delegate?.deleteTask(item: itemDelete[0])
//        navigationController?.popViewController(animated: true)
////        print("hello")
//    }
    
    
    var taskTitle = ""
    var taskDesc = ""
    
    override func viewDidLoad() {
        title1TF?.text = taskTitle
        desc1TF?.text = taskDesc
        
        self.title = "View Task"
    }
}
