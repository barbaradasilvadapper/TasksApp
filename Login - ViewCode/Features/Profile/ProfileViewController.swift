//
//  ProfileViewController.swift
//  NavigationViewCode
//
//  Created by Barbara Dapper on 05/05/25.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    var userName = Persintence.getLoggedUser()?.name
    var userBirth = Persintence.getLoggedUser()?.birthDate
    var userEmail = Persintence.getLoggedUser()?.email
    
    // MARK: Name
    lazy var nameComponent : NamedTextField = {
        var view = NamedTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.name = "Name:"
        view.placeholder = userName
        view.nameTextField.isEnabled = false
        view.delegate = self
        view.nameTextField.layer.borderWidth = 0
        return view
    }()
    
    
    // MARK: Birth Date
    lazy var birthLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Date of birth"
        label.font = UIFont(name: "SFPro-Regular", size: 16)
        return label
    }()
    
    lazy var birthDatePicker: UIDatePicker = {
        var datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "en_US_POSIX")
        datePicker.date = userBirth ?? Date()
        datePicker.isEnabled = false
        return datePicker
    }()
    
    lazy var birthStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [birthLabel, birthDatePicker])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    
    // MARK: Email
    lazy var emailComponent : NamedTextField = {
        var view = NamedTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.name = "Email:"
        view.placeholder = userEmail
        view.nameTextField.isEnabled = false
        view.nameTextField.layer.borderWidth = 0
        view.delegate = self
        return view
    }()
    
    lazy var profileStackView : UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [nameComponent, birthStack, emailComponent])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: Logout button
    lazy var logoutButton : UIButton = {
        let button = UIButton()
        button.setTitle("Signout", for: .normal)
        button.configuration = .filled()
        button.tintColor = .backgroundTertiary
        button.layer.cornerRadius = 12
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProRound-SemiBold", size: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: Delete button
    lazy var deleteButton : UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.configuration = .filled()
        button.tintColor = .backgroundTertiary
        button.layer.cornerRadius = 12
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProRound-SemiBold", size: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedDeleteButton), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonStackView : UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [logoutButton, deleteButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        title = "Profile"
        view.backgroundColor = .backgroundSecondary
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupConstraints()
    }
    
    
    
    @objc func tappedButton() {
        let loginViewController = UINavigationController(rootViewController: LoginViewController())
        
        let getLoggedUser = Persintence.getLoggedUser()
        let getUsers = Persintence.getUsers()
        
        if let loggedUser = getLoggedUser, var users = getUsers{
            users.removeAll(where: { $0.email == loggedUser.email })
            Persintence.saveUser(newUser: loggedUser)
        }
        
        UserDefaults.standard.removeObject(forKey: Persintence.userKey)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginViewController)
    }
    
    @objc func tappedDeleteButton() {
        
        Persintence.deleteUser()
        
        UserDefaults.standard.removeObject(forKey: Persintence.userKey)
        
        guard let users = Persintence.getUsers() else { return }
        users.forEach { print($0) }
        
        let loginViewController = UINavigationController(rootViewController: LoginViewController())
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginViewController)
    }

}

extension ProfileViewController: ViewCodeProtocol {
    func addSubViews() {
        view.addSubview(profileStackView)
        view.addSubview(buttonStackView)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            profileStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            profileStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            
            buttonStackView.topAnchor.constraint(equalTo: profileStackView.bottomAnchor, constant: 227),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}
