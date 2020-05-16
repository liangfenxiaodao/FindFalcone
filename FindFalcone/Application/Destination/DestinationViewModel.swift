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

    private var avaiablePlanets: [Planet] = []
    private var avaiableVehicles: [Vehicle] = []

    private var selectedPlanet = BehaviorRelay<Planet?>(value: nil)
    private var selectedVehicle = BehaviorRelay<Vehicle?>(value: nil)

    func getAvailablePlanets() -> Observable<[Planet]> {
        return usecase.getAvailablePlanets().do(onNext: { [weak self] planets in
            self?.avaiablePlanets = planets
        })
    }

    func getAvailableVehicles() -> Observable<[Vehicle]> {
        return Observable.combineLatest(selectedPlanet, usecase.getAvailbleVehicles())
            .map { (selectedPlanet, vehicles) in
                guard let selectedPlanet = selectedPlanet else {
                    return []
                }
                return vehicles.filter { vehicle in
                    vehicle.distance >= selectedPlanet.distance
                }
            }.do(onNext: { [weak self] vehicles in
                self?.avaiableVehicles = vehicles
            })
    }

    func selectPlanet(index: Int) {
        selectedPlanet.accept(avaiablePlanets[index])
    }

    func selectVehicle(index: Int) {
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
}
