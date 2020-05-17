//
//  FindFalconeTests.swift
//  FindFalconeTests
//
//  Created by Jacky Li on 15/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import XCTest
@testable import FindFalcone

class DestinationUseCaseTests: XCTestCase {
    let usecase = DestinationUseCase()

    override func setUp() {
        DataStore.shared = DataStore()
    }

    func test_save_destination_should_succeed() {

        let planet1 = Planet(name: "p1", distance: 1)
        let vehicle1 = Vehicle(name: "v1", total: 1, distance: 1, speed: 1)
        let destination = Destination(planet: planet1, vehicle: vehicle1)

        usecase.saveDestination(destination)

        XCTAssertEqual(DataStore.shared.destinations.count, 1)
        XCTAssertTrue(DataStore.shared.destinations[0] == destination)
    }

    func test_save_destination_should_remove_selected_planet_and_vehicle_from_available() {
        let planet1 = Planet(name: "p1", distance: 1)
        let planet2 = Planet(name: "p2", distance: 1)

        let vehicle1 = Vehicle(name: "v1", total: 1, distance: 1, speed: 1)
        let vehicle2 = Vehicle(name: "v2", total: 1, distance: 1, speed: 1)

        DataStore.shared.planets = [planet1, planet2]
        DataStore.shared.vehicles = [vehicle1, vehicle2]

        let destination = Destination(planet: planet1, vehicle: vehicle1)
        usecase.saveDestination(destination)

        XCTAssertTrue(DataStore.shared.availablePlanets.count == 1)
        XCTAssertTrue(DataStore.shared.availablePlanets[0] == planet2)
        XCTAssertTrue(DataStore.shared.availableVehicles.count == 1)
        XCTAssertTrue(DataStore.shared.availableVehicles[0] == vehicle2)
    }

    func test_save_destination_should_reduce_vehicle_amount_if_its_total_number_is_more_than_1() {
        let planet1 = Planet(name: "p1", distance: 1)
        let vehicle1 = Vehicle(name: "v1", total: 2, distance: 1, speed: 1)

        DataStore.shared.planets = [planet1]
        DataStore.shared.vehicles = [vehicle1]

        let destination = Destination(planet: planet1, vehicle: vehicle1)
        usecase.saveDestination(destination)

        XCTAssertTrue(DataStore.shared.availableVehicles.count == 1)
        XCTAssertTrue(DataStore.shared.availableVehicles[0].name == "v1")
        XCTAssertTrue(DataStore.shared.availableVehicles[0].total == 1)
    }
}
