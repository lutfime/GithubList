//
//  LocalLoader.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import Foundation
import CoreData

class LocalLoader: UsersLoader, UserProfileLoader{
    private let usersRepository: UsersRepository

    init(usersRepository: UsersRepository) {
        self.usersRepository = usersRepository
    }
    
    func loadGithubUsers(startUserIndex: Int, completion: @escaping (Result<[User], Error>) -> Void) {
        let users = usersRepository.getUsers()
        completion(.success(users ?? []))
    }
    
    struct NotFound: Error {}

    func loadUserProfile(loginName: String, completion: @escaping (Result<User, Error>) -> Void) {
        if let user = usersRepository.getUser(with: loginName){
            completion(.success(user))
        }else{
            completion(.failure(NotFound()))
        }
    }
    
}
