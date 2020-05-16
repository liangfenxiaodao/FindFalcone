//
//  DataStore.swift
//  FindFalcone
//
//  Created by Jacky Li on 16/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct DataStore {
    static let maxNumberOfDestinations = 4
    static var observable = BehaviorRelay<DataStore>(value: .shared)
    static var shared: DataStore = DataStore() {
        didSet {
            observable.accept(shared)
        }
    }

    var planets: [Planet] = [] {
        didSet {
            availablePlanets = planets
        }
    }
    var availablePlanets: [Planet] = []

    var vehicles: [Vehicle] = [] {
        didSet {
            availableVehicles = vehicles
        }
    }
    var availableVehicles: [Vehicle] = []

    var destinations: [Destination] = []
}

extension DataStore {
    static func observable<T: Equatable>(path: KeyPath<DataStore, T>) -> Observable<T> {
        return observable
                   .map { store in store[keyPath: path] }
                   .distinctUntilChanged()
    }
}
