//
//  DestinationViewModel.swift
//  FindFalcone
//
//  Created by Jacky Li on 16/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import Foundation
import RxSwift

class DestinationViewModel {
    private var disposeBag = DisposeBag()
    private let usecase = DestinationUseCase()

    func getAvailablePlanets() -> Observable<[Planet]> {
        return usecase.getAvailablePlanets()
    }

    func getVehicles() -> Observable<[Vehicle]> {
        return usecase.getVehicles()
    }
}
