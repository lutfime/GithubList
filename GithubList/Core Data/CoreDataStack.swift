//
//  CoreDataStack.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 22/11/2022.
//

import CoreData
import Foundation

class CoreDataStack: NSObject {
    public static let modelName = "GithubUsers"

    public static let model: NSManagedObjectModel = {
      // swiftlint:disable force_unwrapping
      let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
      return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    public lazy var storeContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: CoreDataStack.modelName, managedObjectModel: CoreDataStack.model)
      container.loadPersistentStores { _, error in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      }
      return container
    }()

    lazy var mainContext: NSManagedObjectContext = self.storeContainer.viewContext
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.storeContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    @objc func saveContext() {
        backgroundContext.performAndWait{
            guard self.backgroundContext.hasChanges else {
                return
            }
            do {
                try self.backgroundContext.save()
            } catch let error as NSError {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
