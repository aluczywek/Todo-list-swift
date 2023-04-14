//
//  TaskCreatorVC.swift
//  TodoApp
//
//  Created by Ola Łuczywek on 14/04/2023.
//

import UIKit
import CoreData

class TaskCreatorVC: UITableViewController {
    
    var category = ""
    weak var delegate: ViewController?

    @IBOutlet weak var taskNoteTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: - Segmented Control
    
    @IBAction func categotySegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            category = "Home"
        }
        else if sender.selectedSegmentIndex == 1 {
            category = "Work"
            
        } else {
            category = "Other"
        }
    }
    
    
    //MARK: - Saving new task
    
    @IBAction func saveButton(_ sender: UIButton) {
        
    }
    
    //MARK: - Create new task
    
    func createNewTask() -> TaskModel {
        var task: TaskModel = TaskModel(
            name: taskNoteTextField.text ?? "",
            date: datePicker.date,
            category: category)
        return task
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
