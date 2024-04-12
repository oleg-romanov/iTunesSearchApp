//
//  DetailMediaContentRouter.swift
//  SearchApp
//
//  Created by Олег Романов on 09.04.2024.
//

import UIKit

final class DetailMediaContentRouter: DetailMediaContentRoutingLogic {
    
    // MARK: Instance Properties
    
    private weak var viewController: UIViewController!
    
    // MARK: Initializers
    
    init(viewController: UIViewController!) {
        self.viewController = viewController
    }
}
