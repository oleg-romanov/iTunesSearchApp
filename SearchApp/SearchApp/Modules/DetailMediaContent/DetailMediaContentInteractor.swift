//
//  DetailMediaContentInteractor.swift
//  SearchApp
//
//  Created by Олег Романов on 09.04.2024.
//

import Foundation

final class DetailMediaContentInteractor: DetailMediaContentBusinessLogic {
    
    // MARK: Instance Properties
    
    private let presenter: DetailMediaContentPresentationLogic
    
    private let networkService: APIClient
    
    // MARK: Initializers
    
    init(presenter: DetailMediaContentPresentationLogic) {
        self.presenter = presenter
        networkService = APIClient(baseURL: URL(string: APIConstants.baseURL))
    }
    
    // MARK: Instance Methods
    
    func fetchArtistInfo(by artistId: Int) async {
        let query: [(String, String?)] = [
            ("id", "\(artistId)")
        ]
        do {
            let mediaContentResponse: ArtistInfoResponse = try await networkService.send(Request(path: "/lookup", query: query)).value
            presenter.presentArtistInfo(from: mediaContentResponse)
        } catch {
            presenter.presentError(error)
        }
    }
}
