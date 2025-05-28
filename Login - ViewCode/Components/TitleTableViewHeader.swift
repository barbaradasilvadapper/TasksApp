//
//  TitleTableViewHeader.swift
//  Login - ViewCode
//
//  Created by Bárbara Dapper on 28/05/25.
//

import UIKit
class TitleTableViewHeader: UITableViewHeaderFooterView {
    static let reuseIdentifier = "TitleTableViewHeader"
    
    lazy var headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .labelSecondary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProRounded-Bold", size: 17)
        label.textColor = .labelSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .labelSecondary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerImageView, titleLabel, chevronImageView])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.backgroundColor = .backgroundSecondary
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func config(category: Category, isCollapsed: Bool) {
        titleLabel.text = category.rawValue.uppercased()
        headerImageView.image = UIImage(systemName: category.imageName)
        chevronImageView.image = UIImage(systemName: isCollapsed ? "chevron.down" : "chevron.up")
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
}

extension TitleTableViewHeader: ViewCodeProtocol {
    func addSubViews() {
        contentView.addSubview(stackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            headerImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            headerImageView.heightAnchor.constraint(equalToConstant: 21),
            
            chevronImageView.widthAnchor.constraint(equalToConstant: 16),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16),
            chevronImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            ])
    }
}
