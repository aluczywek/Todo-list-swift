//
//  TaskCreatorVC.swift
//  TodoApp
//
//  Created by Ola Łuczywek on 14/04/2023.
//

import UIKit
import CoreData

class TaskCreatorVC: UITableViewController {
    
    var category = "Home"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var taskNoteTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Segmented Control
    
    @IBAction func categotySegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            category = "Work"
        } else {
            category = "Other"
        }
    }
    
    //MARK: - Saving new task
    
    @IBAction func saveButton(_ sender: UIButton) {
        createNewTask()
        saveNewTask()
    }
    
    fileprivate func showSuccesAlert() {
        let dialogMessage = UIAlertController(title: "Succes!", message: "New task created", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.navigationController?.popToRootViewController(animated: true)
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true)
    }
    
    func saveNewTask() {
        do {
            try context.save()
            showSuccesAlert()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    //MARK: - Create new task
    
    func createNewTask() {
        let newTask = TodoTask(context: self.context)
        newTask.name = taskNoteTextField.text ?? ""
        newTask.date = datePicker.date
        newTask.category = category
    }
   
    // MARK: - Cancel Button
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
