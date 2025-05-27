//
//  Username.swift
//  Login - ViewCode
//
//  Created by Bárbara Dapper on 06/05/25.
//

import Foundation

struct User: Codable {
    let name: String
    let birthDate: Date
    let email: String
    let password: String
    let terms: Bool
    var userTaskList: [Task] = []
}

//struct Users: Codable {
//    var accounts: [User]
//}
