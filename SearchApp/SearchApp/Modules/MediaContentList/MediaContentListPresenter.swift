//
//  MediaContentListPresenter.swift
//  SearchApp
//
//  Created by Олег Романов on 05.04.2024.
//

import Foundation

final class MediaContentListPresenter: MediaContentListPresentationLogic {
    
    // MARK: Instance Properties
    
    private weak var viewController: MediaContentListDisplayLogic!
    
    // MARK: Initializers
    
    init(viewController: MediaContentListDisplayLogic!) {
        self.viewController = viewController
    }
    
    // MARK: Instance Methods
    
    func presentContentMedia(from response: MediaContentResponse) {
        var mediaContentList: [MediaContentListViewModel] = []
        
        for item in response.results {
            guard
                let artWorkUrl = item.artworkUrl100,
                let trackName = item.trackName,
                let releaseDate = item.releaseDate?.split(separator: "T")[0],
                let country = item.country,
                let trackPrice = item.trackPrice
            else {
                continue
            }
            mediaContentList.append(
                MediaContentListViewModel(
                    artWorkUrl: artWorkUrl,
                    trackName: trackName,
                    artistName: item.artistName,
                    kind: item.kind,
                    releaseDate: String(releaseDate),
                    country: country,
                    trackPrice: trackPrice > 0 ? "\(trackPrice)$" : "Free"
                )
            )
        }
        viewController.displayContentMediaList(mediaContentList: mediaContentList)
    }
    
    func presentError(_ error: Error) {
        viewController.displayError(with: error.localizedDescription)
    }
}
