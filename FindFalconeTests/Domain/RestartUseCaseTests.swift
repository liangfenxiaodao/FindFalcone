//
//  RestartUseCaseTests.swift
//  FindFalconeTests
//
//  Created by Jacky Li on 17/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import XCTest
@testable import FindFalcone

class RestartUseCaseTests: XCTestCase {
    let usecase = RestartUseCase()

    override func setUp() {
        DataStore.shared = DataStore()
    }

    func test_restart_should_reset_avaible_planets_and_vehicles() {
        let planet1 = Planet(name: "p1", distance: 1)
        let planet2 = Planet(name: "p2", distance: 1)

        let vehicle1 = Vehicle(name: "v1", total: 1, distance: 1, speed: 1)
        let vehicle2 = Vehicle(name: "v2", total: 1, distance: 1, speed: 1)

        DataStore.shared.planets = [planet1, planet2]
        DataStore.shared.vehicles = [vehicle1, vehicle2]

        DataStore.shared.availablePlanets = [planet1]
        DataStore.shared.availableVehicles = [vehicle1]

        usecase.restart()

        XCTAssertEqual(DataStore.shared.availablePlanets.count, 2)
        XCTAssertEqual(DataStore.shared.availableVehicles.count, 2)
    }

    func test_restart_should_remove_all_destinations() {
        let planet1 = Planet(name: "p1", distance: 1)
        let vehicle1 = Vehicle(name: "v1", total: 1, distance: 1, speed: 1)
        let destination = Destination(planet: planet1, vehicle: vehicle1)

        DataStore.shared.destinations = [destination]

        usecase.restart()

        XCTAssertEqual(DataStore.shared.destinations.count, 0)
    }
}
