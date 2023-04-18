//
//  UserProfileLoaderCacheDecorator.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import Foundation

public class UserProfileLoaderCacheDecorator: UserProfileLoader{
    private let loader: UserProfileLoader
    private let dataProvider: UsersProvider

    public init(loader: UserProfileLoader, coreDataStack: CoreDataStack) {
        self.loader = loader
        self.dataProvider = UsersProvider(coreDataStack: coreDataStack)
    }
    
    public func loadUserProfile(loginName: String, completion: @escaping (Result<User, Error>) -> Void) {
        loader.loadUserProfile(loginName: loginName) {[weak self] result in
            if let user = try? result.get(){
                self?.dataProvider.createOrUpdate(user: user)
                self?.dataProvider.coreDataStack.saveContext()
            }
            completion(result)
        }
    }
}

extension APILoader{
    func cachingUserProfileTo(_ coreDataStack: CoreDataStack) -> UserProfileLoader{
        return UserProfileLoaderCacheDecorator(loader: self, coreDataStack: coreDataStack)
    }
}
