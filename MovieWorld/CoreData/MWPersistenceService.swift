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
    lazy var persistentContainer: NSPersistentContainer = {
        let conteiner = NSPersistentContainer(name: "MWGenresList")
        conteiner.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return conteiner
    }()
    // MARK: - initialization
    private init() {
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    // MARK: - setters / helpers / actions / handlers / utility
    func save(completion: @escaping () ->Void) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion()
            } catch {
                fatalError("Unresolved error \(error)")
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
    // MARK: - request
    func requestGenres(completion: @escaping ([Genre]) -> Void) {
        MWNetwork.shared.request(url: "genre/movie/list", okHandler: { [weak self] (data: APIGenres, response) in
            guard let self = self else { return }
            data.genres.forEach {
                let genre = Genre(context: self.context)
                genre.id = Int32($0.id)
                genre.name = $0.name
            }
            let group = DispatchGroup()
            group.enter()
            DispatchQueue.main.async {
                self.save {
                    self.fetch(Genre.self, completion: { (genres) in
                        completion(genres)
                        group.leave()
                    })
                }
            }
        }) { (error, response) in
            print(error.localizedDescription)
        }
    }
}
