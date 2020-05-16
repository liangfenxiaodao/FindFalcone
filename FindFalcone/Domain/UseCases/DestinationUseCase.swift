//
//  DestinationUseCase.swift
//  FindFalcone
//
//  Created by Jacky Li on 15/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import Foundation
import RxSwift

class DestinationUseCase {
    let disposeBag = DisposeBag()

    func getAvailablePlanets() -> Observable<[Planet]> {
        return DataStore.observable(path: \.availablePlanets)
    }

    func getAvailbleVehicles() -> Observable<[Vehicle]> {
        return DataStore.observable(path: \.availableVehicles)
    }

    func getDestinations() -> [Destination] {
        return DataStore.shared.destinations
    }

    func saveDestination(_ destination: Destination) {
        DataStore.shared.destinations.append(destination)
        DataStore.shared.availablePlanets.removeAll(where: { $0.name == destination.planet.name })

        if destination.vehicle.total == 1 {
            DataStore.shared.availableVehicles.removeAll(where: { $0.name == destination.vehicle.name })
        } else {
            updateAvailableVehicles(with: destination.vehicle)
        }
    }

    private func updateAvailableVehicles(with vehicle: Vehicle) {
        let updatedVehicle = Vehicle(name: vehicle.name, total: vehicle.total - 1, distance: vehicle.distance, speed: vehicle.speed)
        guard let index = DataStore.shared.availableVehicles.firstIndex(of: vehicle) else { return }
        DataStore.shared.availableVehicles[index] = updatedVehicle
    }
}
