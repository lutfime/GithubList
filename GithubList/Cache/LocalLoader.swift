//
//  LocalLoader.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import Foundation
import CoreData

class LocalLoader: UsersLoader, UserProfileLoader{
    private let dataProvider: UsersCoreDataRepository

    init(coreDataStack: CoreDataStack) {
        self.dataProvider = UsersCoreDataRepository(coreDataStack: coreDataStack)
    }
    
    func loadGithubUsers(startUserIndex: Int, completion: @escaping (Result<[User], Error>) -> Void) {
        let users = dataProvider.getUsers()?.map({$0.toModel()})
        completion(.success(users ?? []))
    }
    
    struct NotFound: Error {}

    func loadUserProfile(loginName: String, completion: @escaping (Result<User, Error>) -> Void) {
        let fetchRequest: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(UserManagedObject.loginName), loginName)
        fetchRequest.predicate = predicate
        let results = try? dataProvider.coreDataStack.backgroundContext.fetch(fetchRequest)
        
        if let userProfile = results?.first?.toModel(){
            completion(.success(userProfile))
        }
        else{
            completion(.failure(NotFound()))
        }
    }
    
}
