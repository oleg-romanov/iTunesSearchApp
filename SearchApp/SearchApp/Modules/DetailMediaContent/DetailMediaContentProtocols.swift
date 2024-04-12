//
//  DetailMediaContentProtocols.swift
//  SearchApp
//
//  Created by Олег Романов on 09.04.2024.
//

import Foundation

protocol DetailMediaContentBusinessLogic: AnyObject {
    func fetchArtistInfo(by artistId: Int) async
}

protocol DetailMediaContentPresentationLogic: AnyObject {
    func presentArtistInfo(from response: ArtistInfoResponse)
    func presentError(_ error: Error)
}

protocol DetailMediaContentDisplayLogic: AnyObject {
    func displayArtistInfo(artistInfo: ArtistInfoViewModel)
    func displayError(with message: String)
    func configure(by model: MediaContentListViewModel)
}

protocol DetailMediaContentRoutingLogic: AnyObject {
}
