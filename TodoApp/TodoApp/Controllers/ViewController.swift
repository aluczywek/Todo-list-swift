//
//  ViewController.swift
//  TodoApp
//
//  Created by Ola Łuczywek on 13/04/2023.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    var tasks = [TodoTask]()
    let cellIdentifier = "TaskCell"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todo List"
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        loadTasks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTasks()
        tableView.reloadData()
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tasks.count != 0 {
            return tasks.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TaskCell
        
        if tasks.count != 0 {
            cell.setName(text: tasks[indexPath.row].name!)
            cell.setCategory(category: tasks[indexPath.row].category!)
            cell.setDate(date: tasks[indexPath.row].date!)
        } else {
            cell.setName(text: "No tasks")
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return.delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            context.delete(tasks[indexPath.row])
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    
    //MARK: - Add new task
    
    @IBAction func AddButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToTaskCreator", sender: self)
    }
    
    //MARK: - Data manipulation methods
    
    func loadTasks() {
        let request: NSFetchRequest<TodoTask> = TodoTask.fetchRequest()
        do {
            tasks = try context.fetch(request)
        } catch {
            print("Error fetching data from context.")
        }
        tableView.reloadData()
    }
}

