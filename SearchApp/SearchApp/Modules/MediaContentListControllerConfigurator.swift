//
//  MediaContentListControllerConfigurator.swift
//  SearchApp
//
//  Created by Олег Романов on 05.04.2024.
//

import Foundation

final class MediaContentListControllerConfigurator {
    
    // MARK: Instance Methods
    
    func setupModule() -> MediaContentListController {
        let viewController = MediaContentListController()
        let presenter = MediaContentListPresenter(viewController: viewController)
        let interactor = MediaContentListInteractor(presenter: presenter)
        
        let router = MediaContentListRouter(viewController: viewController)
        viewController.setupComponents(
            interactor: interactor,
            router: router
        )
        return viewController
    }
}
