//
//  ModalViewController.swift
//  NavigationViewCode
//
//  Created by Barbara Dapper on 05/05/25.
//


import UIKit

protocol TaskDetailsDelegate: AnyObject {
    func didEditTask(task: Task)
}

class TaskDetailsViewController: UIViewController {
    
    var taskId: UUID?
    var taskName: String?
    var taskCategory: Category?
    var taskIsDone: Bool?
    var taskDescription: String?

    // MARK: Header
    lazy var header: HeaderView = {
        var header = HeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.title = "Task Details"
        header.addButton.setTitle("Done", for: .normal)
        header.addButton.isEnabled = true
        
        header.cancelButtonAction = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        header.addButtonAction = { [weak self] in
            self?.addButtonTapped()
        }
        
        return header
    }()
    
    // MARK: Name
    lazy var nameComponent : AddTextField = {
        var view = AddTextField()
        view.name = "Task"
        view.text = taskName
        //view.delegate = self
        return view
    }()
    
    // MARK: Category Selector
    lazy var categorySelector = CategorySelector()
    
    // MARK: Status
    lazy var statusButton: UIButton = {
        var button = UIButton()
        if let isDone = taskIsDone {
            button.setImage(UIImage(systemName: isDone ? "checkmark.circle.fill" : "circle") , for: .normal)
            button.tintColor = isDone ? .accent : .labelSecondary
        }
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(statusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var statusLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "SFPro-Regural", size: 16)
        label.textColor = .labelPrimary
        label.text = "Status"
        return label
    }()
    
    lazy var statusStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [statusButton, statusLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.backgroundColor = .backgroundTertiary
        stack.layer.cornerRadius = 8
        stack.spacing = 12
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    // MARK: Description
    
    lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.text = "Description"
        label.font = UIFont(name: "SFPro-Regural", size: 16)
        label.textColor = .labelPrimary
        return label
    }()
    
    lazy var descriptionTextField: UITextView = {
       let textField = UITextView()
        textField.text = taskDescription
        textField.font = UIFont(name: "SFPro-Regular", size: 17)
        textField.textColor = .labelPrimary
        textField.delegate = self
        textField.textContainerInset = UIEdgeInsets(top: 12, left: 6, bottom: 12, right: 12)
        textField.backgroundColor = .backgroundTertiary
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    lazy var descriptionStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [descriptionLabel, descriptionTextField])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()

    // MARK: MainStack
    lazy var mainStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [nameComponent, categorySelector, statusStack, descriptionStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    //MARK: Delete button
    lazy var deleteButton : UIButton = {
        let button = UIButton()
        button.setTitle("Delete Task", for: .normal)
        button.configuration = .filled()
        button.tintColor = .backgroundTertiary
        button.layer.cornerRadius = 12
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProRound-SemiBold", size: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedDeleteButton), for: .touchUpInside)
        return button
    }()

    // MARK: Properties
    weak var delegate: AddTaskDelegate?
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapDismissKeyboard)
        
        view.backgroundColor = .backgroundSecondary
        
        categorySelector.selectedCategory = taskCategory
        
        setup()
    }
    
    func cleanViewValues() {
        nameComponent.text = ""
        categorySelector.selectedCategory = nil
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    var action: () -> Void = { }
    
    @objc func statusButtonTapped() {
        if var isDone = taskIsDone {
            isDone.toggle( )
            
            statusButton.setImage(UIImage(systemName: isDone ? "checkmark.circle.fill" : "circle") , for: .normal)
            statusButton.tintColor = isDone ? .accent : .labelSecondary
            
            
            self.taskIsDone = isDone
        }
    }
    
    func addButtonTapped() {
        
        let newTask = Task(name: nameComponent.text ?? "no name",
                           Category: categorySelector.selectedCategory ?? .Other,
                           description: descriptionTextField.text ?? "",
                           isDone: taskIsDone ?? false,)
    
        if let taskId = taskId {
            Persintence.deleteTask(by: taskId)
        }
        
        var user = Persintence.getLoggedUser()
        user?.userTaskList.append(newTask)
        
        Persintence.saveLoggedUser(user)
        
        cleanViewValues()
        
        let tasks = Persintence.getLoggedUser()?.userTaskList
        tasks?.forEach { print($0) }
        
        delegate?.didAddTask(task: newTask)
        
        dismiss(animated: true)
    }
    
    @objc func tappedDeleteButton() {
        
        if let taskId = taskId {
            Persintence.deleteTask(by: taskId)
        }
        
        let tbViewController = UINavigationController(rootViewController: TabBarController())
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tbViewController)
    }
    
}

// MARK: ViewCodeProtocol
extension TaskDetailsViewController: ViewCodeProtocol {
    
    func addSubViews() {
        view.addSubview(header)
        view.addSubview(mainStack)
        view.addSubview(deleteButton)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
        
            header.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            mainStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 20),
            
            nameComponent.textField.heightAnchor.constraint(equalToConstant: 46),
            statusStack.heightAnchor.constraint(equalToConstant: 44),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 112),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ])
        
    }
    
}

// MARK: UITextFieldDelegate
//extension TaskDetailsViewController: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        header.addButtonIsEnabled = !(range.location == 0 && string.isEmpty)
//        return true
//    }
//}

// MARK: UITextViewDelegate
extension TaskDetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "More details about the task" {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "More details about the task"
            textView.textColor = .secondaryLabel
        }
    }
}
