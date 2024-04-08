//
//  MediaContentListProtocols.swift
//  SearchApp
//
//  Created by Олег Романов on 05.04.2024.
//

protocol MediaContentListBusinessLogic: AnyObject {
    func fetchContentMediaList(term: String) async
}

protocol MediaContentListPresentationLogic: AnyObject {
    func presentContentMedia(from response: MediaContentResponse)
    func presentError(_ error: Error)
}

protocol MediaContentListDisplayLogic: AnyObject {
    func displayContentMediaList(mediaContentList: [MediaContentListViewModel])
    func displayError(with message: String)
}

protocol MediaContentListRoutingLogic: AnyObject {
    // TODO: Переход к экрану детального просмотра
}
