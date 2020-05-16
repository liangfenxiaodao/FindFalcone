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
    private var selectedPlanet = BehaviorRelay<Planet?>(value: nil)
    private var avaiablePlanets: [Planet] = []

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
        }
    }

    func selectPlanet(index: Int) {
        selectedPlanet.accept(avaiablePlanets[index])
    }
}
