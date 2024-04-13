//
//  SearchQueryDB+CoreDataProperties.swift
//  SearchApp
//
//  Created by Олег Романов on 12.04.2024.
//
//

import Foundation
import CoreData


extension SearchQueryDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchQueryDB> {
        return NSFetchRequest<SearchQueryDB>(entityName: "SearchQueryDB")
    }

    @NSManaged public var text: String
    @NSManaged public var timestamp: Date

}

extension SearchQueryDB : Identifiable {

}
