//
//  CreateAccountViewController.swift
//  Login - ViewCode
//
//  Created by Bárbara Dapper on 30/04/25.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    // MARK: Background
    lazy var backgroundView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundSecondary
        return view
    }()
    
    // MARK: Title
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create Account"
        label.textAlignment = .center
        label.font = UIFont(name: "SFProRounded-Bold", size: 34)
        label.textColor = .labelPrimary
        return label
    }()
    
    // MARK: Name
    lazy var nameComponent : NamedTextField = {
        var view = NamedTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.name = "Name:"
        view.placeholder = "Full name"
        view.nameTextField.autocapitalizationType = .none
        view.delegate = self
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
        view.placeholder = "abc@gmail.com"
        view.nameTextField.autocapitalizationType = .none
        view.delegate = self
        return view
    }()
    
    // MARK: Password
    lazy var passwordComponent : NamedTextField = {
        var view = NamedTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.name = "Password:"
        view.placeholder = "Must be 8 characters"
        view.nameTextField.autocapitalizationType = .none
        view.delegate = self
        return view
    }()
    
//    lazy var passwordErrorLabel: UILabel = {
//        var label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .red
//        label.font = UIFont(name: "SFPro-Regular", size: 13)
//        label.text =
//        "The password does not meet requirements. It must be at least 8 characters long, containing a number, an uppercase letter, and a special character."
//        label.numberOfLines = 0
//        label.textAlignment = .justified
//        label.isHidden = true
//        return label
//    }()
    
    lazy var minimumError: ErrorField = {
        var field = ErrorField()
        field.descriptionText = "At least 8 characters"
        field.image = .xMark
        return field
    }()
    
   lazy var numberError: ErrorField = {
        var field = ErrorField()
        field.descriptionText = "At least 1 number"
        field.image = .xMark
        return field
    }()
    
    lazy var upperError: ErrorField = {
        var field = ErrorField()
        field.descriptionText = "At least 1 uppercase letter"
        field.image = .xMark
        return field
    }()
    
    lazy var specialError: ErrorField = {
        var field = ErrorField()
        field.descriptionText = "At least 1 special character"
        field.image = .xMark
        return field
    }()
    
    lazy var passwordErrorStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [minimumError, numberError, upperError, specialError])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    lazy var passwordStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [passwordComponent, passwordErrorStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    // MARK: Terms
    lazy var switchControl: UISwitch = {
        var switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.isOn = false
        return switchControl
    }()
    
    lazy var termsLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "I accept the term and privacy policy"
        label.font = UIFont(name: "SFPro-Regular", size: 16)
        return label
    }()
    
    lazy var termsStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [switchControl, termsLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 16
        return stack
    }()
    
    // MARK: Big stack
    lazy var bigStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [
            nameComponent, birthStack, emailComponent, passwordStack, termsStack,
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    // MARK: Create button
    lazy var createButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Create Account", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFPro-Regular", size: 17)
        button.layer.cornerRadius = 12
        button.addTarget(
            self,
            action: #selector(createButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordComponent.nameTextField.delegate = self
        passwordComponent.nameTextField.tag = 1
        
        let tapDismissKeyboard = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        
        view.addGestureRecognizer(tapDismissKeyboard)
        view.backgroundColor = .systemBackground
        
        setup()
    }
    
    func cleanViewValues() {
        nameComponent.text = " "
        emailComponent.text = " "
        passwordComponent.text = " "
        switchControl.isOn = false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func createButtonTapped() {
        
        if let name = nameComponent.text, let email = emailComponent.text, let password = passwordComponent.text {
            if !name.isEmpty, !email.isEmpty, !password.isEmpty {
                let newUser = User(
                    name: name,
                    birthDate: birthDatePicker.date,
                    email: email,
                    password: password,
                    terms: switchControl.isOn
                )
                
                Persintence.saveUser(newUser: newUser)
                
                guard let users = Persintence.getUsers() else { return }
                users.forEach { print($0) }
                
                navigationController?.popViewController(animated: true)
            } else {
                print("Invalid")
            }
        }
        
    }
}

extension CreateAccountViewController: ViewCodeProtocol {
    
    func addSubViews() {
        view.addSubview(backgroundView)
        view.addSubview(titleLabel)
        view.addSubview(bigStack)
        view.addSubview(createButton)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 0
            ),
            backgroundView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: 0
            ),
            backgroundView.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: 0
            ),
            backgroundView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: 0
            ),
            
            titleLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 64
            ),
            
            bigStack.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            bigStack.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            bigStack.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 141
            ),
            
            nameComponent.nameTextField.heightAnchor.constraint(equalToConstant: 46),
            emailComponent.nameTextField.heightAnchor.constraint(equalToConstant: 46),
            passwordComponent.nameTextField.heightAnchor.constraint(equalToConstant: 46),
            birthDatePicker.heightAnchor.constraint(equalToConstant: 34),
            switchControl.heightAnchor.constraint(equalToConstant: 31),
            
            createButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            createButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            createButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -66
            ),
            createButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
    }
    
}

// MARK: - Textfield Delegate
extension CreateAccountViewController: UITextFieldDelegate {
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if string.isEmpty {
            return true
        }
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.tag == 1 {
            guard let text = textField.text else { return }
            
            let chars = Array(text)
            
            let hasNumber = chars.contains(where: { $0.isNumber })
            let hasUpperCase = chars.contains(where: { $0.isUppercase })
            let hasSpecialCharacters = chars.contains(where: {
                !$0.isNumber && !$0.isLetter
            })
            let hasMinimumLength = chars.count >= 8

            minimumError.image = hasMinimumLength ? .checkMark : .xMark
            numberError.image = hasNumber ? .checkMark : .xMark
            upperError.image = hasUpperCase ? .checkMark : .xMark
            specialError.image = hasSpecialCharacters ? .checkMark : .xMark
        }
    }
}
