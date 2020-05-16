//
//  AppDelegate.swift
//  FindFalcone
//
//  Created by Jacky Li on 15/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let disposeBag = DisposeBag()
    private var usecase: InitialiseUseCase = InitialiseUseCase()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initialiseDestinations()
        // Override point for customization after application launch.
        let destinationVC = UIStoryboard(name: "Destination", bundle: nil).instantiateInitialViewController()
        let navigationVC = UINavigationController(rootViewController: destinationVC!)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
        return true
    }

    private func initialiseDestinations() {
        usecase.initialisePlanets()
        usecase.initialiseVehicles()
    }
}
