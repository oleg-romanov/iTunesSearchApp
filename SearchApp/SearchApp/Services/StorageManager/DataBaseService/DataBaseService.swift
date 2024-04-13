//
//  DataBaseService.swift
//  SearchApp
//
//  Created by Олег Романов on 12.04.2024.
//

import Foundation
import CoreData

protocol DataBaseServiceProtocol: AnyObject {
    func get<T>(with _: T.Type, predicate: NSPredicate?, fetchLimit: Int) -> [T]? where T: NSManagedObject
}

final class DataBaseService: DataBaseServiceProtocol {
    
    // MARK: - Constants
    
    private enum Constants {
        static let dbName = "SearchAppModel"
    }
    
    // MARK: - Properties
    
    public static let shared = DataBaseService()
    
    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.dbName)
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Functions
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    public func get<T>(with _: T.Type, predicate: NSPredicate?, fetchLimit: Int = .zero) -> [T]? where T: NSManagedObject {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.predicate = predicate
        if fetchLimit != .zero {
            request.fetchLimit = fetchLimit
        }
        do {
            return try persistentContainer.viewContext.fetch(request)
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
            return nil
        }
    }
}
