//
//  ViewCodeProtocol.swift
//  Login - ViewCode
//
//  Created by Barbara Dapper on 29/04/25.
//

import Foundation

protocol ViewCodeProtocol {
    func addSubViews()
    func setupConstraints()
    func setup()
}

extension ViewCodeProtocol {
    func setup() {
        addSubViews()
        setupConstraints()
    }
}
