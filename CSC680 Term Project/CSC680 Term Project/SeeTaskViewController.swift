//
//  SeeTaskViewController.swift
//  CSC680 Term Project
//
//  Created by Darren Wong on 12/12/22.
//

import Foundation
import UIKit

class SeeTaskViewController: UIViewController {
    
    @IBOutlet weak var title1TF: UILabel!
    
    @IBOutlet weak var desc1TF: UILabel!
    
    var taskTitle = ""
    var taskDesc = ""
    
    override func viewDidLoad() {
        title1TF?.text = taskTitle
        desc1TF?.text = taskDesc
        
    }
}
