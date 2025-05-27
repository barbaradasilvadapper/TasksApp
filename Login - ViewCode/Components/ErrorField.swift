//
//  ErrorField.swift
//  Login - ViewCode
//
//  Created by Bárbara Dapper on 06/05/25.
//
import UIKit

class ErrorField: UIView {
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "SFProRounded-Regular", size: 13)
        label.textAlignment = .left
        label.textColor = .labelPrimary
        return label
    }()
    
    private lazy var stack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [imageView, descriptionLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ErrorField: ViewCodeProtocol {
    func addSubViews() {
        addSubview(stack)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 18)
        ])
    }
    
}
