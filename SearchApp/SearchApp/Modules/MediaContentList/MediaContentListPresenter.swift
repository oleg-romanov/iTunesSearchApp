//
//  MediaContentListPresenter.swift
//  SearchApp
//
//  Created by Олег Романов on 05.04.2024.
//

import Foundation

final class MediaContentListPresenter: MediaContentListPresentationLogic {
    
    // MARK: Constants
    
    private enum Constants {
        static let dateFormatterOriginalFormat: String = "yyyy-MM-dd"
    }
    
    // MARK: Instance Properties
    
    private weak var viewController: MediaContentListDisplayLogic!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormatterOriginalFormat
        return formatter
    }()
    
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
                let date = dateFormatter.date(from: String(releaseDate)),
                let collectionName = item.collectionName,
                let trackViewUrl = item.trackViewUrl,
                let artistId = item.artistId
            else {
                continue
            }
            
            dateFormatter.dateFormat = "dd.MM.yyyy"
            
            mediaContentList.append(
                MediaContentListViewModel(
                    artWorkUrl: artWorkUrl,
                    trackName: trackName,
                    artistName: item.artistName,
                    kind: item.kind,
                    releaseDate: dateFormatter.string(from: date),
                    collectionName: collectionName,
                    description: item.longDescription ?? "",
                    trackViewUrlString: trackViewUrl,
                    artistId: artistId
                )
            )
            
            dateFormatter.dateFormat = Constants.dateFormatterOriginalFormat
        }
        viewController.displayContentMediaList(mediaContentList: mediaContentList)
    }
    
    func presentError(_ error: Error) {
        viewController.displayError(with: error.localizedDescription)
    }
}
