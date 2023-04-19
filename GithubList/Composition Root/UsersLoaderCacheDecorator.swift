//
//  UsersLoaderCacheDecorator.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import Foundation

///This class is used to cache result from UsersLoader
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
                self.dataProvider.save(users)
            }
            completion(result)
        }
    }
}

extension UsersLoader{
    func cachingUserListTo(_ coreDataStack: CoreDataStack) -> UsersLoader{
        return UsersLoaderCacheDecorator(loader: self, coreDataStack: coreDataStack)
    }
    
}
