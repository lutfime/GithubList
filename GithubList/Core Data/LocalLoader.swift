//
//  LocalLoader.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import Foundation

class LocalLoader: UsersLoader{
    private let dataProvider: UsersProvider

    init(coreDataStack: CoreDataStack) {
        self.dataProvider = UsersProvider(coreDataStack: coreDataStack)
    }
    
    func loadGithubUsers(startUserIndex: Int, completion: @escaping (Result<[User], Error>) -> Void) {
        
    }
    
}
