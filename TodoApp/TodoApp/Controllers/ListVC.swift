//
//  ViewController.swift
//  TodoApp
//
//  Created by Ola Łuczywek on 13/04/2023.
//

import UIKit
import CoreData

class ListVC: UITableViewController {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTasksAndReloadTableView()
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
        
        cell.setName(text: filteredTasks[indexPath.row].name!)
        cell.setCategory(category: filteredTasks[indexPath.row].category!)
        cell.setDate(date: filteredTasks[indexPath.row].date!)
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = self.createDeleteAlert(indexPath: indexPath)
            present(alert, animated: true)
        }
    }
    
    //MARK: - IBAction func
    
    @IBAction func AddButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToTaskCreator", sender: self)
    }
}

//MARK: - UISearchBarDelegate

extension ListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTasksUsing(searchText: searchText)
    }
}

// MARK: - Private func

private extension ListVC {
    func createDeleteAlert(indexPath: IndexPath) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Are you sure you'd like to delete this task?", preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteTaskFromDB(indexPath: indexPath)
            self.loadTasksAndReloadTableView()
            self.filterTasksUsing(searchText: self.searchBar.text ?? "")
        }

        alert.addAction(cancel)
        alert.addAction(delete)
        
        return alert
    }
    
    //MARK: - Data manipulation methods
    
    func deleteTaskFromDB(indexPath: IndexPath) {
        self.context.delete(self.filteredTasks[indexPath.row])
        do {
            try self.context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadTasksAndReloadTableView() {
        let request: NSFetchRequest<TodoTask> = TodoTask.fetchRequest()
        do {
            tasks = try context.fetch(request)
            filteredTasks = tasks
        } catch {
            print("Error fetching data from context.")
        }
        tableView.reloadData()
    }
    
    func filterTasksUsing(searchText: String) {
        if searchText != "" {
            filteredTasks = tasks.filter { task in
                guard let name = task.name?.uppercased()
                else {
                    return false
                }
                return name.contains(searchText.uppercased())
            }
            tableView.reloadData()
        } else {
            loadTasksAndReloadTableView()
        }
    }
}
