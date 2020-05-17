//
//  FindFalconeRequest.swift
//  FindFalcone
//
//  Created by Jacky Li on 17/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import Foundation

struct FindFalconeRequest: Codable {
    let token: String
    var planet_names: [String] = []
    var vehicle_names: [String] = []

    init(token: Token, destinations: [Destination]) {
        self.token = token.token
        destinations.forEach { destination in
            planet_names.append(destination.planet.name)
            vehicle_names.append(destination.vehicle.name)
        }
    }
}
