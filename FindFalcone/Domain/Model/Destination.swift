//
//  Destination.swift
//  FindFalcone
//
//  Created by Jacky Li on 16/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import Foundation

struct Destination: Equatable {
    let planet: Planet
    let vehicle: Vehicle
    var timeTaken: Int {
        planet.distance / vehicle.speed
    }
}
