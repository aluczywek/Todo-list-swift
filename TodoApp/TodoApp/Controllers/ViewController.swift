//
//  ViewController.swift
//  TodoApp
//
//  Created by Ola Łuczywek on 13/04/2023.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    let tasks: [TaskModel] = []
    let cellIdentifier = "TaskCell"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todo List"
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
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
            cell.setName(text: tasks[indexPath.row].name)
        } else {
            cell.setName(text: "No tasks")
        }
       
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    //MARK: - Add new task
    
    @IBAction func AddButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToTaskCreator", sender: self)
    }
}

