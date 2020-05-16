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
    }

    func selectPlanet(index: Int) {
        guard !avaiablePlanets.isEmpty else { return }
        selectedPlanet.accept(avaiablePlanets[index])
    }

    func selectVehicle(index: Int) {
        guard !avaiableVehicles.isEmpty else { return }
        selectedVehicle.accept(avaiableVehicles[index])
    }

    var buttonText: Observable<String> {
        usecase.getDestinations().map { destinations in
            if destinations.count == DataStore.maxNumberOfDestinations - 1 {
                return "Find Falcone!"
            } else {
                return "Next"
            }
        }
    }

    var destinationLabelText: Observable<String> {
        usecase.getDestinations().map { "Destination: \($0.count + 1)" }
    }

    var timeTakenText: Observable<String?> {
        Observable.combineLatest(selectedPlanet, selectedVehicle)
            .map { (planet, vehicle) in
                guard let planet = planet, let vehicle = vehicle else { return nil }
                let time = planet.distance / vehicle.speed
                return "Time taken: \(time)"
            }
    }

    func goToNextStep() {
        guard let planet = selectedPlanet.value, let vehicle = selectedVehicle.value else {
            return
        }

        let destination = Destination(planet: planet, vehicle: vehicle)
        usecase.saveDestination(destination)
    }
}
