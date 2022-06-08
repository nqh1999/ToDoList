//
//  ViewController.swift
//  DemoToDoList
//
//  Created by Nguyen Quang Huy on 24/05/2022.
//

import UIKit
import CoreData

protocol TaskProtocol {
    func updateTask(task: Task, title: String, isDone: Bool)
    func createTask(title: String, isDone: Bool)
    func strikethroughStyle(isDone: Bool)
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    var fetchedResultsController: NSFetchedResultsController<Task>!
    var allTasks = [Task]()
    var tableViewCell = TableViewCell()
    var addTableViewCell = AddTableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    func setupUI() {
        title = "List"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        getAllTasks()
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAll))
        let nib = UINib(nibName: "TableViewCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        let addnib = UINib(nibName: "addTableViewCell", bundle: .main)
        tableView.register(addnib, forCellReuseIdentifier: "addCell")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupData() {
        createTask(title: "Test", isDone: false)
    }
    
    @objc func tapHandler() {
        view.endEditing(true)
    }
    
    @objc func deleteAll() {
        let alert = UIAlertController(title: "",
                                       message: "Do you want to delete all tasks?",
                                       preferredStyle: .alert)
         
        let saveAction = UIAlertAction(title: "Delete", style: .destructive) { (alert) in
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            do {
                try self.appDelegate.persistentContainer.viewContext.execute(deleteRequest)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            self.allTasks.removeLast(self.allTasks.count - 1)
            self.appDelegate.saveContext()
            self.tableView.reloadData()
        }
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
         alert.addAction(saveAction)
         alert.addAction(cancelAction)
         present(alert, animated: true)
    }
    
    func getAllTasks() {
        let request = Task.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        do {
            allTasks = try appDelegate.persistentContainer.viewContext.fetch(request)
            self.tableView.reloadData()
        } catch {
            //
        }
    }
    
    func createTask(title: String, isDone: Bool) {
        let newTask = Task(context: appDelegate.persistentContainer.viewContext)
        newTask.title = title
        newTask.isDone = isDone
        newTask.index = Int32(allTasks.count)
        allTasks.append(newTask)
        
        ReorderBase()
        appDelegate.saveContext()
        tableView.reloadData()
    }
    
    func updateTask(task: Task, title: String, isDone: Bool) {
        if task.title != title || task.isDone != isDone {
            task.title = title
            task.isDone = isDone
            appDelegate.saveContext()
        }
        tableView.reloadData()
    }
    
    func ReorderBase() {
        for (i, item) in allTasks.enumerated() {
            item.index = Int32(i)
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == allTasks.count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as! AddTableViewCell
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
            let task: Task
            task = allTasks[indexPath.row]
            cell.taskTextField.text = task.title
            let attributeString = NSMutableAttributedString(string: cell.taskTextField.text!)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: task.isDone ? 1 : 0, range: NSRange(location: 0, length: attributeString.length))
            cell.taskTextField.textColor = task.isDone ? .darkGray : .black
            cell.taskTextField.isEnabled = task.isDone ? false : true
            cell.taskTextField.attributedText = attributeString
            cell.completeButton.isHidden = task.isDone ? false : true
            cell.incompleteButton.isHidden = !cell.completeButton.isHidden
            return cell
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task: Task
            task = allTasks[indexPath.row]
            allTasks.remove(at: indexPath.row)
            appDelegate.persistentContainer.viewContext.delete(task)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ReorderBase()
            appDelegate.saveContext()
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.allTasks[sourceIndexPath.row]
        allTasks.remove(at: sourceIndexPath.row)
        allTasks.insert(movedObject, at: destinationIndexPath.row)
        ReorderBase()
        appDelegate.saveContext()
    }
}
