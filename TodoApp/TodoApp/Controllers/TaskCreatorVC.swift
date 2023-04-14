//
//  TaskCreatorVC.swift
//  TodoApp
//
//  Created by Ola Łuczywek on 14/04/2023.
//

import UIKit

class TaskCreatorVC: UITableViewController {

    @IBOutlet weak var taskNoteTextField: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func saveButton(_ sender: UIButton) {
    }
}
