//
//  RestartUseCase.swift
//  FindFalcone
//
//  Created by Jacky Li on 17/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import Foundation

class RestartUseCase {
    func restart() {
        DataStore.shared.availablePlanets = DataStore.shared.planets
        DataStore.shared.availableVehicles = DataStore.shared.vehicles
        DataStore.shared.destinations = []

        NotificationCenter.default.post(name: Constants.NotificationRestart, object: nil)
    }
}
