//
//  GithubUsersProvider.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 22/11/2022.
//

import CoreData
import UIKit

class UsersCoreDataRepository: UsersRepository {
        // MARK: - Properties
    let coreDataStack: CoreDataStack
    weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?

    // MARK: - Initializers
    public init(coreDataStack: CoreDataStack) {
      self.coreDataStack = coreDataStack
    }
    
    public func getUsers(filterKey: String! = nil) -> [UserManagedObject]? {
        let fetchRequest: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(UserManagedObject.userId), ascending: true)]
        if let filterKey, filterKey.count > 0{
            let predicate = NSPredicate(format: "loginName CONTAINS[cd] %@ OR notes CONTAINS[cd] %@", filterKey, filterKey)
            fetchRequest.predicate = predicate
        }
        do {
            let results = try coreDataStack.mainContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return nil
    }
    
    func createOrUpdate(user: User, includeNotes: Bool = true) {
        let context = coreDataStack.backgroundContext
        context.perform {
            let userId = user.id
            let newUserFetch: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
            let userIDPredicate = NSPredicate(format: "%K == %i", #keyPath(UserManagedObject.userId), userId)
            newUserFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userIDPredicate])
            do {
                let results = try context.fetch(newUserFetch)
                if results.isEmpty {
                    self.add(user)
                } else if let foundUser = results.first{
                    foundUser.update(user: user, includeNotes: includeNotes)
                    self.update(foundUser)
                }
            } catch let error as NSError {
                print("Fetch error: \(error) description: \(error.userInfo)")
            }
        }
        
    }
    
    @discardableResult
    public func add(_ user:User) -> UserManagedObject {
        let userManagedObject = UserManagedObject(context: coreDataStack.backgroundContext)
        userManagedObject.update(user: user, includeNotes: true)
        coreDataStack.saveContext()
        return userManagedObject
    }
    
    @discardableResult
    public func update(_ userManagedObject: UserManagedObject) -> UserManagedObject {
      coreDataStack.saveContext()
      return userManagedObject
    }
    
    // MARK: Users Repository
    
    public func getUsers() -> [User]? {
        let fetchRequest: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(UserManagedObject.userId), ascending: true)]
        let managedUsers = try? fetchUsers(with: fetchRequest)
        return managedUsers?.map{$0.toModel()}
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
