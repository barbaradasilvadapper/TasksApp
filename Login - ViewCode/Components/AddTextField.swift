//
//  AddTextField.swift
//  Login - ViewCode
//
//  Created by Bárbara Dapper on 06/05/25.
//

import UIKit

class AddTextField: UIView {
    
    // MARK: Subviews
    lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "SFProRounded-Semibold", size: 17)
        return label
    }()
    
    lazy var textField: UITextField = {
       var textField = PaddedTextField()
        textField.backgroundColor = .backgroundTertiary
        textField.textAlignment = .left
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    lazy var stack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [nameLabel, textField])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        stack.axis = .vertical
        return stack
    }()
    
    // MARK: Properties
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    var text: String? {
        get {
            textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    var delegate: UITextFieldDelegate? {
        didSet {
            textField.delegate = delegate
        }
    }
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AddTextField: ViewCodeProtocol {
    
    func addSubViews() {
        addSubview(stack)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
}
