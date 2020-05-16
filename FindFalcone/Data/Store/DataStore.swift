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
    static var observable = BehaviorRelay<DataStore>(value: .shared)
    static var shared: DataStore = DataStore() {
        didSet {
            observable.accept(shared)
        }
    }

    var vehicles: [Vehicle] = []
    var planets: [Planet] = []
    var availableVehicles: [Vehicle] = []
    var availablePlanets: [Planet] = []
}

extension DataStore {
    static func observable<T: Equatable>(path: KeyPath<DataStore, T>) -> Observable<T> {
        return observable
                   .map { store in store[keyPath: path] }
                   .distinctUntilChanged()
    }
}
