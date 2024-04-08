//
//  MediaContentListRouter.swift
//  SearchApp
//
//  Created by Олег Романов on 05.04.2024.
//

import UIKit

final class MediaContentListRouter: MediaContentListRoutingLogic {
    
    // MARK: Instance Properties
    
    private weak var viewController: UIViewController!
    
    // MARK: Initializers
    
    init(viewController: UIViewController!) {
        self.viewController = viewController
    }
}
