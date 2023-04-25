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
    var filteredTasks = [TodoTask]()
    let cellIdentifier = "TaskCell"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var defaultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todo List"
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        loadTasks()
        filteredTasks = tasks
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTasks()
        tableView.reloadData()
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredTasks.count != 0 {
            defaultLabel.isHidden = true
            return filteredTasks.count
        } else {
            defaultLabel.isHidden = false
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TaskCell
        let taskCategory = filteredTasks[indexPath.row].category
        
        cell.setName(text: filteredTasks[indexPath.row].name!)
        cell.setCategory(category: filteredTasks[indexPath.row].category!)
        cell.setDate(date: filteredTasks[indexPath.row].date!)
        if taskCategory == "Home" {
            cell.taskBuble.backgroundColor = .systemMint
        } else if taskCategory == "Work" {
            cell.taskBuble.backgroundColor = .systemCyan
        } else if taskCategory == "Other" {
            cell.taskBuble.backgroundColor = .systemGreen
        }
//        else {
//            cell.taskBuble.backgroundColor = .systemGray
//        }
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
            let alert = UIAlertController(title: nil, message: "Are you sure you'd like to delete this task?", preferredStyle: .actionSheet)
            let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
                tableView.beginUpdates()
                self.context.delete(self.tasks[indexPath.row])
                self.tasks.remove(at: indexPath.row)
                self.filteredTasks = self.tasks
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(delete)
            present(alert, animated: true)
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
            filteredTasks = tasks
        } catch {
            print("Error fetching data from context.")
        }
        tableView.reloadData()
    }
}

//MARK: - Search bar methods

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text != "" {
            filteredTasks = tasks.filter { task in
                guard let name = task.name?.uppercased()
                else {
                    return false
                }
                return name.contains(searchText.uppercased())
            }
            tableView.reloadData()
        } else {
            loadTasks()
        }
    }
}
