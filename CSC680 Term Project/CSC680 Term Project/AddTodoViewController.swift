//
//  AddTodoViewController.swift
//  CSC680 Term Project
//
//  Created by Darren Wong on 12/12/22.
//

import Foundation
import CoreData
import UIKit

protocol AddTodoProtocol {
    func createTask(name: String)
}
class AddTodoViewController: UIViewController{
    var delegate: AddTodoProtocol?
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var descTF: UITextView!
    
    @IBAction func addAction(_ sender: Any) {
        guard
            let name = nameTF.text,
            let desc = descTF.text
        else {
            return
        }
        delegate?.createTask(name: name)
        navigationController?.popViewController(animated: true)
    }
    
}
