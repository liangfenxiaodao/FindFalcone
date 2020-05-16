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

    func getVehicles() -> Observable<[Vehicle]> {
        return DataStore.observable(path: \.availableVehicles)
    }
}
