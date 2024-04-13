//
//  SearchQueryDB+CoreDataClass.swift
//  SearchApp
//
//  Created by Олег Романов on 12.04.2024.
//
//

import Foundation
import CoreData


public class SearchQueryDB: NSManagedObject {
    func transformToSearchQuery() -> SearchQuery {
        return SearchQuery(text: text, timestamp: timestamp)
    }
    
    func configureFromSearchQuery(_ searchQuery: SearchQuery) {
        text = searchQuery.text
        timestamp = searchQuery.timestamp
    }
}

extension SearchQueryDB {
    static func fetch(with predicate: NSPredicate? = nil) -> [SearchQueryDB]? {
        guard let searchQueries = DataBaseService.shared.get(with: SearchQueryDB.self, predicate: predicate) else {
            return nil
        }
        return searchQueries
    }
    
    static func save(_ searchQuery: SearchQuery) {
        let context = DataBaseService.shared.persistentContainer.viewContext
        
        if let existingSearchQueries = fetch(with: NSPredicate(format: "text == %@", searchQuery.text)) {
            
            for existingQuery in existingSearchQueries {
                context.delete(existingQuery)
            }
        }
        
        let newSearchQuery = SearchQueryDB(context: context)
        newSearchQuery.configureFromSearchQuery(searchQuery)
        
        do {
            try context.save()
        } catch {
            print("Error saving search query: \(error)")
        }
    }
}
