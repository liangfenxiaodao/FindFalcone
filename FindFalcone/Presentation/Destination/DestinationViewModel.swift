//
//  DestinationViewModel.swift
//  FindFalcone
//
//  Created by Jacky Li on 16/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DestinationViewModel {
    private var disposeBag = DisposeBag()
    private let destinationUsecase = DestinationUseCase()
    private let restartUseCase = RestartUseCase()

    var avaiablePlanets: [Planet] = []
    var avaiableVehicles: [Vehicle] = []

    private var selectedPlanet = BehaviorRelay<Planet?>(value: nil)
    private var selectedVehicle = BehaviorRelay<Vehicle?>(value: nil)

    func loadAvailablePlanets() -> Observable<[Planet]> {
        return destinationUsecase.getAvailablePlanets()
            .map { [weak self] planets in
                self?.avaiablePlanets = planets
                return planets
            }
    }

    func loadAvailableVehicles() -> Observable<[Vehicle]> {
        return Observable.combineLatest(selectedPlanet, destinationUsecase.getAvailbleVehicles())
            .map { [weak self] (selectedPlanet, vehicles) in
                guard let selectedPlanet = selectedPlanet else {
                    return []
                }
                let filterVehicles = vehicles.filter { vehicle in
                    vehicle.distance >= selectedPlanet.distance
                }
                self?.avaiableVehicles = filterVehicles
                return filterVehicles
            }
    }

    func selectPlanet(index: Int) {
        guard !avaiablePlanets.isEmpty else { return }
        selectedPlanet.accept(avaiablePlanets[index])
    }

    func selectVehicle(index: Int) {
        if index >= avaiableVehicles.count {
            selectedVehicle.accept(nil)
        } else {
            selectedVehicle.accept(avaiableVehicles[index])
        }
    }

    var buttonText: String {
        if destinationUsecase.getDestinations().count == DataStore.maxNumberOfDestinations - 1 {
            return "Find Falcone!"
        } else {
            return "Next"
        }
    }

    var destinationLabelText: String {
        return "Destination: \(destinationUsecase.getDestinations().count + 1)"
    }

    var shouldHideResetButton: Bool {
        return destinationUsecase.getDestinations().count == 0
    }

    var timeTakenText: Observable<String?> {
        Observable.combineLatest(selectedPlanet, selectedVehicle)
            .map { [weak self] (planet, vehicle) in
                guard let self = self, let planet = planet, let vehicle = vehicle else { return nil }
                let time = planet.distance / vehicle.speed + self.destinationUsecase.getTotalTimeTaken()
                return "Time taken: \(time)"
            }
    }

    func goToNextStep() -> Route? {
        guard let planet = selectedPlanet.value, let vehicle = selectedVehicle.value else {
            return nil
        }

        let destination = Destination(planet: planet, vehicle: vehicle)
        destinationUsecase.saveDestination(destination)

        if destinationUsecase.getDestinations().count == DataStore.maxNumberOfDestinations {
            return Route.result
        }
        return Route.destination
    }

    func restart() {
        restartUseCase.restart()
    }
}
