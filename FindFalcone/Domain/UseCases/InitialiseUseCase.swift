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
    let falconeRepository = FalconeRepository()
    let disposeBag = DisposeBag()

    func initialisePlanets() {
        falconeRepository.getPlanets()
            .subscribe(onNext: { planets in
                DataStore.shared.planets = planets
            })
            .disposed(by: disposeBag)
    }

    func initialiseVehicles() {
        falconeRepository.getVehicles()
            .subscribe(onNext: { vehicles in
                DataStore.shared.vehicles = vehicles
            })
            .disposed(by: disposeBag)
    }
}
