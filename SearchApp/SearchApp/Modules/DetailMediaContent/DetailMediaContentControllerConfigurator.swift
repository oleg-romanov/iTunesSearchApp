//
//  DetailMediaContentControllerConfigurator.swift
//  SearchApp
//
//  Created by Олег Романов on 09.04.2024.
//

import Foundation

final class DetailMediaContentControllerConfigurator {
    
    // MARK: Instance Methods
    
    func setupModule() -> DetailMediaContentController {
        let viewController = DetailMediaContentController()
        let presenter = DetailMediaContentPresenter(viewController: viewController)
        let interactor = DetailMediaContentInteractor(presenter: presenter)
        
        let router = DetailMediaContentRouter(viewController: viewController)
        viewController.setupComponents(
            interactor: interactor,
            router: router
        )
        return viewController
    }
}
