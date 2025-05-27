//
//  HomeViewController.swift
//  NavigationViewCode
//
//  Created by Barbara Dapper on 05/05/25.
//

import UIKit

class TaskViewController: UIViewController {
    
    // MARK: Subviews
    lazy var addButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "plus"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(tappedButton))
    }()
    
    lazy var tableView: UITableView = {
        var table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "default-cell")
        table.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)
        return table
    }()
    
    lazy var emptyView: EmptyState = {
        var empty = EmptyState()
        empty.translatesAutoresizingMaskIntoConstraints = false
        empty.image = .task
        empty.titleText = "No tasks yet!"
        empty.descriptionText = "Add a new task and it will show up here."
        empty.buttonTitle = "Add New Task"
        empty.buttonAction = { [weak self] in
            self?.tappedButton()
        }
        return empty
    }()
    
    // MARK: Properties
    var tasks = Persintence.getLoggedUser()?.userTaskList {
        didSet {
            buildContent()
            tableView.reloadData()
        }
    }
    
    var sections: [Category] = []
    var rows: [[Task]] = []
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tasks"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = addButtonItem
        navigationController?.navigationBar.prefersLargeTitles = true
        self.tasks = Persintence.getLoggedUser()?.userTaskList
        setup()
    }
    
    @objc func tappedButton() {
        let addTaskVC = AddTaskViewController()
        addTaskVC.delegate = self
        present(addTaskVC, animated: true)
    }
    
    func buildContent() {
        sections = buildSections()
        rows = buildRows()
    }
    
    func buildSections() -> [Category] {
        var sections: [Category] = []
        
        for category in Category.allCases {
            
            if let tasks = tasks {
                let hasCategory = tasks.contains(where: {$0.Category == category})
                
                if hasCategory {
                    sections.append(category)
                }
            }
        }
        
        return sections
    }
    
    func buildRows() -> [[Task]] {
        var rows: [[Task]] = []
        
        for section in sections {
            if let tasks = tasks {
                rows.append(tasks.filter({ $0.Category == section }))
            }
        }
        
        return rows
    }

    func getTask(by indexPath: IndexPath) -> Task {
        let tasksOfSection = rows[indexPath.section]
        let task = tasksOfSection[indexPath.row]
        return task
    }

}

// MARK: AddTaskDelegate
extension TaskViewController: AddTaskDelegate {
    func didAddTask(task: Task) {
        tasks = Persintence.getLoggedUser()?.userTaskList
    }
}

// MARK: UITableViewDelegate
extension TaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let task = getTask(by: indexPath)
        
        let taskDetailsVC = TaskDetailsViewController()
        taskDetailsVC.taskId = task.id
        taskDetailsVC.taskName = task.name
        taskDetailsVC.taskCategory = task.Category
        taskDetailsVC.taskIsDone = task.isDone
        taskDetailsVC.taskDescription = task.description
        taskDetailsVC.delegate = self
        present(taskDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            [weak self] (action, view, completionHandler) in
            
            if let taskToDelete = self?.getTask(by: indexPath) {
                Persintence.deleteTask(by: taskToDelete.id)
                self?.tasks = Persintence.getLoggedUser()?.userTaskList
            }
            
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipe
        
    }
}

// MARK: UITableViewDataSource
extension TaskViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].rawValue.uppercased()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        emptyView.isHidden = !sections.isEmpty
        tableView.isHidden = sections.isEmpty
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let task = getTask(by: indexPath)
        
        cell.config(labelText: task.name, isDone: task.isDone) { [weak self] in
            Persintence.toogleTaskStatus(by: task.id)
            self?.tasks = Persintence.getLoggedUser()?.userTaskList
//            task.isDone.toggle()
        }
        
        return cell
    }
    
    
}


// MARK: ViewCodeProtocol
extension TaskViewController: ViewCodeProtocol {
    
    func addSubViews() {
        view.addSubview(emptyView)
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
}
