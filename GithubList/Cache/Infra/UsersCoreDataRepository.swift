//
//  GithubUsersProvider.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 22/11/2022.
//

import CoreData
import UIKit

public class UsersCoreDataRepository: UsersRepository {
        // MARK: - Properties
    let coreDataStack: CoreDataStack
    weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?

    // MARK: - Initializers
    public init(coreDataStack: CoreDataStack) {
      self.coreDataStack = coreDataStack
    }
    
    public func getUsers() -> [User]? {
        let fetchRequest: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(UserManagedObject.userId), ascending: true)]
        if let managedUsers = try? fetchUsers(with: fetchRequest), managedUsers.count > 0{
            return managedUsers.map{$0.toModel()}

        }
        return nil
    }
    
    public func getUser(with loginName: String) -> User? {
        let fetchRequest: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(UserManagedObject.loginName), loginName)
        fetchRequest.predicate = predicate
        if let user = try? fetchUsers(with: fetchRequest).first{
            return user.toModel()
        }
        return nil
    }
    
    public func save(_ users: [User]) {
        for user in users {
            let managedUser = try? fetchOrCreateNewUser(user)
            managedUser?.update(user: user, includeNotes: true)
        }
        coreDataStack.saveContext()
    }
    
    private func fetchOrCreateNewUser(_ user: User) throws -> UserManagedObject{
        if let managedUser = try fetchUser(user){
            return managedUser
        }else{
            let managedUser = UserManagedObject(context: coreDataStack.backgroundContext)
            return managedUser
        }
    }
    
    private func fetchUser(_ user: User) throws -> UserManagedObject?{
        let fetchRequest: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %i", #keyPath(UserManagedObject.userId), user.id)
        let users = try fetchUsers(with: fetchRequest)
        return users.first
    }
    
    private func fetchUsers(with fetchRequest: NSFetchRequest<UserManagedObject>) throws -> [UserManagedObject]{
        let results = try coreDataStack.mainContext.fetch(fetchRequest)
        return results
    }
}
