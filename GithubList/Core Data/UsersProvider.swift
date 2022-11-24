//
//  GithubUsersProvider.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 22/11/2022.
//

import CoreData
import UIKit

class UsersProvider {
    
    
    // MARK: - Properties
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: CoreDataStack
    weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?

    // MARK: - Initializers
    public init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
      self.managedObjectContext = managedObjectContext
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
            let results = try managedObjectContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return nil
    }
    
    func createOrUpdate(user: User, includeNotes: Bool = true) {
        let userId = user.id
        let newUserFetch: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
        let userIDPredicate = NSPredicate(format: "%K == %i", #keyPath(UserManagedObject.userId), userId)
        newUserFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userIDPredicate])
        do {
            let results = try managedObjectContext.fetch(newUserFetch)
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
    
    @discardableResult
    public func add(_ user:User) -> UserManagedObject {
        let userManagedObject = UserManagedObject(context: managedObjectContext)
        userManagedObject.update(user: user, includeNotes: true)
        coreDataStack.saveContext()
        return userManagedObject
    }
    
    @discardableResult
    public func update(_ userManagedObject: UserManagedObject) -> UserManagedObject {
      coreDataStack.saveContext()
      return userManagedObject
    }
}
