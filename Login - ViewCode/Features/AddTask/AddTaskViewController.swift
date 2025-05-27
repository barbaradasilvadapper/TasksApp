//
//  ModalViewController.swift
//  NavigationViewCode
//
//  Created by Barbara Dapper on 05/05/25.
//


import UIKit

protocol AddTaskDelegate: AnyObject {
    func didAddTask(task: Task)
}

class AddTaskViewController: UIViewController {

    // MARK: Header
    lazy var header: HeaderView = {
        var header = HeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.title = "New Task"
        
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
        view.placeholder = "Your task name here"
        view.delegate = self
        return view
    }()
    
    // MARK: Category Selector
    lazy var categorySelector = CategorySelector()
    
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
        textField.text = "More details about the task"
        textField.font = UIFont(name: "SFPro-Regular", size: 17)
        textField.textColor = .tertiaryLabel
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
        var stack = UIStackView(arrangedSubviews: [nameComponent, categorySelector, descriptionStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()

    // MARK: Properties
    weak var delegate: AddTaskDelegate?
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapDismissKeyboard)
        
        view.backgroundColor = .backgroundSecondary
        
        setup()
    }
    
    func cleanViewValues() {
        nameComponent.text = ""
        categorySelector.selectedCategory = nil
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addButtonTapped() {
        
        let newTask = Task(name: nameComponent.text ?? "no name",
                           Category: categorySelector.selectedCategory ?? .Other,
                           description: descriptionTextField.text ?? "")
        
        var user = Persintence.getLoggedUser()
        user?.userTaskList.append(newTask)
        
        Persintence.saveLoggedUser(user)
        
        cleanViewValues()
        
        let tasks = Persintence.getLoggedUser()?.userTaskList
        tasks?.forEach { print($0) }
        
        delegate?.didAddTask(task: newTask)
        
        dismiss(animated: true)
    }
    
}

// MARK: ViewCodeProtocol
extension AddTaskViewController: ViewCodeProtocol {
    
    func addSubViews() {
        view.addSubview(header)
        view.addSubview(mainStack)
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
            descriptionTextField.heightAnchor.constraint(equalToConstant: 112),
            
        ])
        
    }
    
}

// MARK: UITextFieldDelegate
extension AddTaskViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        header.addButtonIsEnabled = !(range.location == 0 && string.isEmpty)
        return true
    }
}

// MARK: UITextViewDelegate
extension AddTaskViewController: UITextViewDelegate {
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
