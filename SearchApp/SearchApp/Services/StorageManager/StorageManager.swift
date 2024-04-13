//
//  StorageManager.swift
//  SearchApp
//
//  Created by Олег Романов on 12.04.2024.
//

import Foundation
import CoreData

protocol StorageManagerProtocol {
    func saveSearchQuery(_ searchQuery: SearchQuery)
    func fetchSearchQueries() async -> [SearchQuery]?
}

final class StorageManager: StorageManagerProtocol {
    
    func saveSearchQuery(_ searchQuery: SearchQuery) {
        DispatchQueue.global().async {
            SearchQueryDB.save(searchQuery)
        }
    }
    
    func fetchSearchQueries() async -> [SearchQuery]? {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                if let queries = SearchQueryDB.fetch() {
                    continuation.resume(returning: queries.map { $0.transformToSearchQuery() })
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
