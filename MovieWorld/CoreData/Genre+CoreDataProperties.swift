//
//  Genre+CoreDataProperties.swift
//  
//
//  Created by Murad Ibrohimov on 4/22/20.
//
//

import CoreData

extension Genre {
    // MARK: - variables
    @NSManaged public var id: Int32
    @NSManaged public var name: String
    // MARK: - setters / helpers / actions / handlers / utility
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Genre> {
        return NSFetchRequest<Genre>(entityName: "Genre")
    }
}
