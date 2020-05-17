//
//  DestinationViewModelTests.swift
//  FindFalconeTests
//
//  Created by Jacky Li on 17/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import XCTest
import RxBlocking

@testable import FindFalcone

class DestinationViewModelTests: XCTestCase {
    let viewModel = DestinationViewModel()
    
    override func setUp() {
        DataStore.shared = DataStore()
    }

    func test_select_planet_should_filter_available_vehicles_by_distance() {
        let planet1 = Planet(name: "p1", distance: 100)
        let planet2 = Planet(name: "p2", distance: 200)

        let vehicle1 = Vehicle(name: "v1", total: 1, distance: 100, speed: 1)
        let vehicle2 = Vehicle(name: "v2", total: 1, distance: 100, speed: 1)
        let vehicle3 = Vehicle(name: "v3", total: 1, distance: 200, speed: 1)
        let vehicle4 = Vehicle(name: "v3", total: 1, distance: 300, speed: 1)


        viewModel.avaiablePlanets = [planet1, planet2]
        DataStore.shared.availableVehicles = [vehicle1, vehicle2, vehicle3, vehicle4]

        viewModel.selectPlanet(index: 1)
        let availableVehicles = try! viewModel.loadAvailableVehicles().toBlocking().first()!

        XCTAssertEqual(availableVehicles.count, 2)
        XCTAssertEqual(availableVehicles[0], vehicle3)
        XCTAssertEqual(availableVehicles[1], vehicle4)
    }
}
