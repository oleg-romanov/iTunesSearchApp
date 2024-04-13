//
//  MediaContentListProtocols.swift
//  SearchApp
//
//  Created by Олег Романов on 05.04.2024.
//

import Foundation

protocol MediaContentListBusinessLogic: AnyObject {
    func fetchContentMediaList(term: String) async
    func fetchAllHistoryRequests() async
    func saveSearchRequest(_ text: String, timestamp: Date)
}

protocol MediaContentListPresentationLogic: AnyObject {
    func presentContentMedia(from response: MediaContentResponse)
    func presentHistoryRequests(_ requests: [SearchQuery]?)
    func presentError(_ error: Error)
}

protocol MediaContentListDisplayLogic: AnyObject {
    func displayContentMediaList(mediaContentList: [MediaContentListViewModel])
    func displaySearchHistory(_ searchHistory: [SearchQuery], fiveLastRequests: [SearchQuery])
    func displayError(with message: String)
}

protocol MediaContentListRoutingLogic: AnyObject {
    func routeToDetailMediaContent(with model: MediaContentListViewModel)
}
