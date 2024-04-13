//
//  MediaContentListInteractor.swift
//  SearchApp
//
//  Created by Олег Романов on 05.04.2024.
//

import Foundation

final class MediaContentListInteractor: MediaContentListBusinessLogic {
    
    // MARK: Instance Properties
    
    private let presenter: MediaContentListPresentationLogic
    
    private let networkService: APIClient
    
    private let storageManager: StorageManagerProtocol
    
    // MARK: Initializers
    
    init(presenter: MediaContentListPresentationLogic) {
        self.presenter = presenter
        networkService = APIClient(baseURL: URL(string: APIConstants.baseURL))
        storageManager = StorageManager()
    }
    
    // MARK: Instance Methods
    
    func fetchContentMediaList(term: String) async {
        let query: [(String, String?)] = [
            ("term", term),
            ("media", "music"),
            ("media", "tvShow"),
            ("limit", "40")
        ]
        do {
            let mediaContentResponse: MediaContentResponse = try await networkService.send(Request(path: "/search", query: query)).value
            presenter.presentContentMedia(from: mediaContentResponse)
        } catch {
            presenter.presentError(error)
        }
    }
    
    func fetchAllHistoryRequests() async {
        let searchHistory = await storageManager.fetchSearchQueries()
        presenter.presentHistoryRequests(searchHistory)
    }
    
    func saveSearchRequest(_ text: String, timestamp: Date) {
        let searchQuery = SearchQuery(text: text, timestamp: timestamp)
        storageManager.saveSearchQuery(searchQuery)
    }
}
