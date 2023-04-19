//
//  UsersRepository.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 19/04/2023.
//

import Foundation

public protocol UsersRepository{
    //We not assume async here although we use Core Data, that is because Core Data is implementation details
    func getUsers() -> [User]?
    func getUser(with loginName: String) -> User?
    func save(_ users: [User])
}
