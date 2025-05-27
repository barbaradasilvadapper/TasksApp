//
//  CreateAccount.swift
//  Login
//
//  Created by Bárbara Dapper on 28/04/25.
//

import Foundation

struct Persintence {
    
    private static let key = "accounts"
    static let userKey = "loggedUser"
    private static let taskKey = "tasks"
    
    
    //MARK Users
    static func getUsers() -> [User]? {
        
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            
            do {
                let accounts = try JSONDecoder().decode([User].self, from: data)
                return accounts
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
    
    static func getLoggedUser() -> User? {
        
        if let data = UserDefaults.standard.value(forKey: userKey) as? Data {
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                return user
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
    
    static func saveLoggedUser(_ user: User?) {
        
        do {
            let data = try JSONEncoder().encode(user)
            UserDefaults.standard.setValue(data, forKey: userKey)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func saveUser(newUser: User) {
        
        var users = getUsers() ?? []
        let user = Persintence.getLoggedUser()
        
        if let loggedUser = user {
            users.removeAll { $0.email == loggedUser.email }
        }
        
        users.append(newUser)
        
        do {
            let data = try JSONEncoder().encode(users)
            UserDefaults.standard.setValue(data, forKey: key)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    static func checkUserExists(email: String, password: String) -> Bool {
        guard let users = getUsers() else { return false}
        
        if users.contains(where: {$0.email == email && $0.password == password}) {
            return true
        }
        
        else {
            return false
        }
    }
    
    static func deleteUser() {
        var users = getUsers() ?? []
        let user = Persintence.getLoggedUser()
        
        if let loggedUser = user {
            users.removeAll { $0.email == loggedUser.email }
        }
        
        do {
            let data = try JSONEncoder().encode(users)
            UserDefaults.standard.setValue(data, forKey: key)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func deleteTask(by id: UUID) {
        if var user = getLoggedUser() {
            user.userTaskList.removeAll { $0.id == id}
            saveLoggedUser(user)
        }
    }
    
    static func toogleTaskStatus(by id: UUID) {
        guard var user = getLoggedUser() else { return }
        
        guard let taskIndex = user.userTaskList.firstIndex(where: { $0.id == id }) else { return }
        
        user.userTaskList[taskIndex].isDone.toggle()
        saveLoggedUser(user)
    }
}
