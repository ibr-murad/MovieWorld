//
//  MWPersistenceService.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 4/22/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import Foundation
import CoreData

class MWPersistenceService {
    // MARK: - variables
    static let shared = MWPersistenceService()
    var context: NSManagedObjectContext { return persistentContainer.viewContext }
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MWGenresList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - initialization
    private init() {
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    // MARK: - helpers
    func save(completion: @escaping () -> Void) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion()
            } catch {
                print("Unresolved error \(error)")
            }
        }
    }
    
    func fetch<T: NSManagedObject>(_ type: T.Type, completion: @escaping ([T]) ->Void) {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        do {
            let objects = try context.fetch(request)
            completion(objects)
        } catch {
            print(error)
            completion([])
        }
    }
}
