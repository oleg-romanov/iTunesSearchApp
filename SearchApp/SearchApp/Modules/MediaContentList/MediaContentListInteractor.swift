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
    
    // MARK: Initializers
    
    init(presenter: MediaContentListPresentationLogic) {
        self.presenter = presenter
        networkService = APIClient(baseURL: URL(string: APIConstants.baseURL))
    }
    
    // MARK: Instance Methods
    
    func fetchContentMediaList(term: String) async {
        let query: [(String, String?)] = [
            ("term", term),
            ("limit", "20"),
            ("media", "movie"),
            ("media", "music")
        ]
        do {
            let mediaContentResponse: MediaContentResponse = try await networkService.send(Request(path: "/search", query: query)).value
            presenter.presentContentMedia(from: mediaContentResponse)
        } catch {
            presenter.presentError(error)
        }
    }
}
