//
//  Router.swift
//  FindFalcone
//
//  Created by Jacky Li on 16/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import Foundation
import UIKit

enum Route: String {
    case destination
    case result

    var storyboardName: String {
        switch self {
        case .destination: return "Destination"
        case .result: return "Result"
        }
    }
}

extension UIViewController {
    func route(to route: Route) {
        self.navigationController?.push(route.storyboardName)
    }
}

extension UINavigationController {
    func push(_ storyboardName: String) {
        let viewController = UIStoryboard(named: storyboardName).instantiateInitialViewController()!
        pushViewController(viewController, animated: true)
    }
}

extension UIStoryboard {
    convenience init(named name: String) {
        self.init(name: name, bundle: Bundle.main)
    }
}
