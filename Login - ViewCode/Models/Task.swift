//
//  Task.swift
//  Login - ViewCode
//
//  Created by Bárbara Dapper on 06/05/25.
//

import Foundation

struct Task: Codable {
    var id = UUID()
    let name: String
    let Category: Category
    let description: String
    var isDone: Bool = false
}

struct Tasks: Codable {
    var tasksList: [Task] = []
}
