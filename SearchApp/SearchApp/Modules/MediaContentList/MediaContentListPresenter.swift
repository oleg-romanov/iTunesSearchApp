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
        static let songKind: String = "song"
        static let tvEpisodeKind: String = "tv-episode"
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
                let kind = item.kind,
                let artWorkUrl = item.artworkUrl100,
                let trackName = item.trackName,
                let releaseDate = item.releaseDate?.split(separator: "T")[0],
                let date = dateFormatter.date(from: String(releaseDate)),
                let collectionName = item.collectionName,
                let trackViewUrl = item.trackViewUrl,
                let artistId = item.artistId,
                kind == Constants.tvEpisodeKind || kind == Constants.songKind
            else {
                continue
            }
            
            
            dateFormatter.dateFormat = "dd.MM.yyyy"
            
            mediaContentList.append(
                MediaContentListViewModel(
                    artWorkUrl: artWorkUrl,
                    trackName: trackName,
                    artistName: item.artistName,
                    kind: kind,
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
    
    func presentHistoryRequests(_ requests: [SearchQuery]?) {
        guard let allSearchHistory = requests else {
            viewController.displayError(with: "An error occurred in the operation of the local storage")
            return
        }
        
        let sortedSearchHistory = allSearchHistory.sorted { $0.timestamp > $1.timestamp }.prefix(5)
        
        viewController.displaySearchHistory(allSearchHistory, fiveLastRequests: Array(sortedSearchHistory))
    }
    
    func presentError(_ error: Error) {
        viewController.displayError(with: error.localizedDescription)
    }
}
