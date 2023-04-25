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
    
    //MARK: - IBAction func
    
    @IBAction func categotySegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            category = "Work"
        } else {
            category = "Other"
        }
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        createNewTask()
        saveNewTask()
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - Private func

private extension TaskCreatorVC {
    func saveNewTask() {
        do {
            try context.save()
            showSuccessAlert()
        } catch {
            print("Error saving context \(error)")
            showFailAlert()
        }
    }
    
    func showSuccessAlert() {
        let dialogMessage = UIAlertController(title: "Success!", message: "New task created", preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.navigationController?.popToRootViewController(animated: true)
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true)
    }
    
    func showFailAlert() {
        let dialogMessage = UIAlertController(title: "Fail", message: "Error saving data", preferredStyle: .actionSheet)
        let tryAgainButton = UIAlertAction(title: "Try again", style: .default, handler: { (action) -> Void in
            self.saveNewTask()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        dialogMessage.addAction(tryAgainButton)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true)
    }
        
    func createNewTask() {
        let newTask = TodoTask(context: self.context)
        newTask.name = taskNoteTextField.text ?? ""
        newTask.date = datePicker.date
        newTask.category = category
    }
}
