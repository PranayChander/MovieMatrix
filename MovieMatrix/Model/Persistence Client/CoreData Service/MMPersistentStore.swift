//
//  MMPersistentStore.swift
//  MovieMatrix
//
//  Created by pranay chander on 23/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MMPersistentStore {
    
    static let sharedInstance = MMPersistentStore()
    private init() {}
    
    //NSMergeByPropertyObjectTrumpMergePolicy - uses the store values at merge conflicts
    //NSMergeByPropertyStoreTrumpMergePolicy - uses the updated object values at merge conflicts
    
//    lazy var applicationsDocumentsDirectory: URL = {
//        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return urls[urls.count - 1]
//    }()
//
//
//    private lazy var managedObjectModel: NSManagedObjectModel = {
//        let modelURL = Bundle.main.url(forResource: "MovieMatrix", withExtension: "momd")!
//        return NSManagedObjectModel(contentsOf: modelURL)!
//    }()
//
//    private var persistentStoreCoordinator: NSPersistentStoreCoordinator {
//        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
//        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
//        let url = self.applicationsDocumentsDirectory.appendingPathComponent("MovieMatrix.sqlite")
//        do {
//            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
//        } catch {
//            print("Error Creating Persistent Store")
//        }
//        return coordinator
//    }
    
    // Used to load/reset the data model
    func resetMemoryContext() {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        managedObjectContext.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
        managedObjectContext.undoManager = nil
        self.mainManagedObjectContext = managedObjectContext
    }
    
    lazy var mainManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        managedObjectContext.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
        managedObjectContext.undoManager = nil
        return managedObjectContext
    }()
    
    func childManagedObjectyContext() -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        managedObjectContext.parent = self.mainManagedObjectContext
        return managedObjectContext
    }
    
    lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        managedObjectContext.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
        managedObjectContext.undoManager = nil
        return managedObjectContext
    }()
    
    func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieMatrix")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                print("Unable to load Persistence Container")
            }
        }
        return container
    }()
}
