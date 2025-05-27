//
//  Category.swift
//  Login - ViewCode
//
//  Created by Bárbara Dapper on 06/05/25.
//

import Foundation

enum Category: String, Codable, CaseIterable {
    case Education, Fitness, Groceries, Health, Home, Personal, Reading, Shopping, Travel, Other
    
    var imageName: String {
        switch self {
        case .Education: return "graduationcap.fill"
        case .Fitness: return "dumbbell.fill"
        case .Groceries: return "fork.knife"
        case .Health: return "pills.fill"
        case .Home: return "house.fill"
        case .Personal: return "person.fill"
        case .Reading: return "book.fill"
        case .Shopping: return "cart.fill"
        case .Travel: return "airplane"
        default: return "ellipsis"
        }
    }
    
}
