//
//  UsersLoaderCacheDecorator.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import Foundation

public class UsersLoaderCacheDecorator: UsersLoader{
    private let loader: UsersLoader
    private let dataProvider: UsersCoreDataRepository

    public init(loader: UsersLoader, coreDataStack: CoreDataStack) {
        self.loader = loader
        self.dataProvider = UsersCoreDataRepository(coreDataStack: coreDataStack)
    }
    
    public func loadGithubUsers(startUserIndex: Int, completion: @escaping (Result<[User], Error>) -> Void) {
        loader.loadGithubUsers(startUserIndex: startUserIndex) { result in
            if let users = try? result.get(){
                //Merge data from API or create new one if not available in core data. Do not save not because load only available locally from core data
                for user in users{
                    self.dataProvider.createOrUpdate(user: user, includeNotes: false)
                }
                //Save core data
                self.dataProvider.coreDataStack.saveContext()
            }
            completion(result)
        }
    }
}

extension APILoader{
    func cachingUserListTo(_ coreDataStack: CoreDataStack) -> UsersLoader{
        return UsersLoaderCacheDecorator(loader: self, coreDataStack: coreDataStack)
    }
    
}
