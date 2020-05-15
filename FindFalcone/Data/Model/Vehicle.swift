//
//  Vehicle.swift
//  FindFalcone
//
//  Created by Jacky Li on 15/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import Foundation

struct Vehicle: Codable {
    let name: String
    let total: Int
    let distance: Int
    let speed: Int

    enum CodingKeys: String, CodingKey {
        case name, speed
        case total = "total_no"
        case distance = "max_distance"
    }
}
