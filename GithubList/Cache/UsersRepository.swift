//
//  UsersRepository.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 19/04/2023.
//

import Foundation

public protocol UsersRepository{
    func getUsers() -> [User]?
//    func getUser(with loginName: String) -> User
    func save(_ users: [User])
}
