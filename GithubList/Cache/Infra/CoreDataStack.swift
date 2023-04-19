//
//  CoreDataStack.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 22/11/2022.
//

import CoreData
import Foundation

public class CoreDataStack: NSObject {
    public static let modelName = "GithubUsers"

    public static let model: NSManagedObjectModel = {
      // swiftlint:disable force_unwrapping
      let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
      return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    let storeContainer: NSPersistentContainer

    lazy var mainContext: NSManagedObjectContext = self.storeContainer.viewContext
    public lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.storeContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
        
    public init(storeURL: URL) throws {
        do {
            storeContainer = try NSPersistentContainer.load(name: CoreDataStack.modelName, model: CoreDataStack.model, url: storeURL)
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    @objc func saveContext() {
        backgroundContext.perform{
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

extension NSPersistentContainer {
    static func load(name: String, model: NSManagedObjectModel, url: URL) throws -> NSPersistentContainer {
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]
        
        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw $0 }
        
        return container
    }
}
