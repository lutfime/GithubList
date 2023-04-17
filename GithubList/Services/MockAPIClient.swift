//
//  MockAPIClient.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 24/11/2022.
//

import UIKit

class MockAPIClient: APIClientProtocol {
    func loadGithubUsers(startUserIndex: Int, completion: @escaping (Result<[User], Error>) -> Void) {
        let pathString = Bundle(for: type(of: self)).path(forResource: "users", ofType: "json")!
        let url = URL(fileURLWithPath: pathString)
        let jsonData = try! Data(contentsOf: url)
        let users = try! JSONDecoder().decode([User].self, from: jsonData)
        completion(.success(users))
    }
    
    func loadUserProfile(loginName: String, completion: @escaping (Result<User, Error>) -> Void) {
        let pathString = Bundle(for: type(of: self)).path(forResource: "userProfile", ofType: "json")!
        let url = URL(fileURLWithPath: pathString)
        let jsonData = try! Data(contentsOf: url)
        let users = try! JSONDecoder().decode(User.self, from: jsonData)
        completion(.success(users))
    }
    
}
