//
//  LocalLoader.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import Foundation
import CoreData

class LocalLoader: UsersLoader, UserProfileLoader{
    private let dataProvider: UsersProvider

    init(coreDataStack: CoreDataStack) {
        self.dataProvider = UsersProvider(coreDataStack: coreDataStack)
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
        let results = try? dataProvider.coreDataStack.mainContext.fetch(fetchRequest)
        
        if let userProfile = results?.first?.toModel(){
            completion(.success(userProfile))
        }
        else{
            completion(.failure(NotFound()))
        }
    }
    
}

extension UserManagedObject{
    func toModel() -> User{
        let user = User()
        user.id = Int(userId)
        user.loginName = loginName
        user.avatarURL = avatarURL
        user.profileURL = profileURL
        user.starredURL = starredURL
        user.name = name
        user.company = company
        user.blog = blog
        user.location = location
        user.email = email
        user.followerCount = Int(followerCount)
        user.followingCount = Int(followingCount)
        return user
    }
}
