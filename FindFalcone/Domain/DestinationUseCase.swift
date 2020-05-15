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
    let falconeProvider = FalconeProvider()

    func getPlanets() -> Observable<[Planet]> {
        return falconeProvider.getPlanets()
    }

    func getVehicles() -> Observable<[Vehicle]> {
        return falconeProvider.getVehicles()
    }
}
