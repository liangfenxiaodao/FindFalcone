//
//  InitialiseUseCase.swift
//  FindFalcone
//
//  Created by Jacky Li on 16/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import Foundation
import RxSwift

class InitialiseUseCase {
    let falconeProvider = FalconeProvider()
    let disposeBag = DisposeBag()

    func initialisePlanets() {
        falconeProvider.getPlanets()
            .subscribe(onNext: { planets in
                DataStore.shared.planets = planets
            })
            .disposed(by: disposeBag)
    }

    func initialiseVehicles() {
        falconeProvider.getVehicles()
            .subscribe(onNext: { vehicles in
                DataStore.shared.vehicles = vehicles
            })
            .disposed(by: disposeBag)
    }
}
