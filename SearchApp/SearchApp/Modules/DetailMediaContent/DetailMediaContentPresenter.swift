//
//  DetailMediaContentPresenter.swift
//  SearchApp
//
//  Created by Олег Романов on 09.04.2024.
//

import Foundation

final class DetailMediaContentPresenter: DetailMediaContentPresentationLogic {
    
    // MARK: Instance Properties
    
    private weak var viewController: DetailMediaContentDisplayLogic!
    
    // MARK: Initializers
    
    init(viewController: DetailMediaContentDisplayLogic!) {
        self.viewController = viewController
    }
    
    // MARK: Instance Methods
    
    func presentArtistInfo(from response: ArtistInfoResponse) {
        guard 
            let artistInfo = response.results.first,
            let wrapperType = artistInfo.wrapperType,
            let artistType = artistInfo.artistType,
            let artistName = artistInfo.artistName,
            let artistLinkUrl = artistInfo.artistLinkUrl,
            let primaryGenreName = artistInfo.primaryGenreName
        else {
            viewController.displayError(with: "Failed to receive artist info...")
            return
        }
        
        let artistInfoViewModel = ArtistInfoViewModel(
            wrapperType: wrapperType,
            artistType: artistType,
            artistName: artistName,
            artistLinkUrl: artistLinkUrl,
            primaryGenreName: primaryGenreName
        )
        viewController.displayArtistInfo(artistInfo: artistInfoViewModel)
    }
    
    func presentError(_ error: Error) {
        viewController.displayError(with: error.localizedDescription)
    }
}
