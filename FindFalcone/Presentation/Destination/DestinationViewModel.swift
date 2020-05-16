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
    private let usecase = DestinationUseCase()

    var avaiablePlanets: [Planet] = []
    var avaiableVehicles: [Vehicle] = []

    private var selectedPlanet = BehaviorRelay<Planet?>(value: nil)
    private var selectedVehicle = BehaviorRelay<Vehicle?>(value: nil)

    func loadAvailablePlanets() -> Observable<[Planet]> {
        return usecase.getAvailablePlanets()
            .filter { !$0.isEmpty }
            .map { [weak self] planets in
                self?.avaiablePlanets = planets
                return planets
            }
    }

    func loadAvailableVehicles() -> Observable<[Vehicle]> {
        return Observable.combineLatest(selectedPlanet, usecase.getAvailbleVehicles())
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
            .filter { !$0.isEmpty }
    }

    func selectPlanet(index: Int) {
        guard !avaiablePlanets.isEmpty else { return }
        selectedPlanet.accept(avaiablePlanets[index])
    }

    func selectVehicle(index: Int) {
        guard !avaiableVehicles.isEmpty else { return }
        selectedVehicle.accept(avaiableVehicles[index])
    }

    var buttonText: String {
        if usecase.getDestinations().count == DataStore.maxNumberOfDestinations - 1 {
            return "Find Falcone!"
        } else {
            return "Next"
        }
    }

    var destinationLabelText: String {
        return "Destination: \(usecase.getDestinations().count + 1)"
    }

    var timeTakenText: Observable<String?> {
        Observable.combineLatest(selectedPlanet, selectedVehicle)
            .map { [unowned self] (planet, vehicle) in
                guard let planet = planet, let vehicle = vehicle else { return nil }
                let time = planet.distance / vehicle.speed + self.totalTimeTaken()
                return "Time taken: \(time)"
            }
    }

    private func totalTimeTaken() -> Int {
        return usecase.getDestinations().reduce(0, { (accumulation, enumeration) -> Int in
            return accumulation + enumeration.timeTaken
        })
    }

    func goToNextStep() -> Route? {
        guard let planet = selectedPlanet.value, let vehicle = selectedVehicle.value else {
            return nil
        }

        let destination = Destination(planet: planet, vehicle: vehicle)
        usecase.saveDestination(destination)

        if usecase.getDestinations().count == DataStore.maxNumberOfDestinations {
            return Route.result
        }
        return Route.destination
    }
}
