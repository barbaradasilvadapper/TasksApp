//
//  CategorySelector.swift
//  Login - ViewCode
//
//  Created by Bárbara Dapper on 06/05/25.
//

import UIKit

class CategorySelector: UIView {
    // MARK: Subviews
    private lazy var label: UILabel = {
        var label = UILabel()
        label.text = "Category"
        label.font = UIFont(name: "SFProRounded-Semibold", size: 17)
        return label
    }()
    
    lazy var categorySymbol: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = .category
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var button: UIButton = {
        var button = UIButton()
        
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Select"
        configuration.indicator = .popup
        button.configuration = configuration
        
        button.menu = UIMenu(title: "Category", options: [.singleSelection], children: categorySelections)
        button.showsMenuAsPrimaryAction = true
        
        return button
    }()
    
    lazy var categoryStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [label, button])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 0
        stack.alignment = .center
        stack.distribution = .equalCentering
        return stack
    }()

    private lazy var stack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [categorySymbol,categoryStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .backgroundTertiary
        stack.layer.cornerRadius = 8
        stack.spacing = 12
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    // MARK: Properties
    private var categorySelections: [UIAction] {
        return Category.allCases.sorted(by: { $0.rawValue < $1.rawValue })
            .map { category in
                UIAction(
                    title: category.rawValue,
                    image: UIImage(systemName: category.imageName),
                    handler: { [weak self] _ in
                        self?.selectedCategory = category
                    }
                )
            }
    }
    
    var selectedCategory: Category? {
        didSet {
            button.setTitle(
                selectedCategory?.rawValue ?? "Select",
                for: .normal
            )
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

extension CategorySelector: ViewCodeProtocol {
    
    func addSubViews() {
        addSubview(stack)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stack.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
}
