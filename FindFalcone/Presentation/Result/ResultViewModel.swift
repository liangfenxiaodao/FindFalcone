//
//  ResultViewModel.swift
//  FindFalcone
//
//  Created by Jacky Li on 17/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ResultViewModel {
    private let falconeUseCase = FalconeUseCase()
    private let destinationUseCase = DestinationUseCase()
    private let restartUseCase = RestartUseCase()

    private var planetName = BehaviorRelay<String?>(value: nil)

    func findFalcone() -> Observable<Result> {
        return falconeUseCase.findFalcone().do(onNext: { [weak self] result in
            if result.isSuccess {
                self?.planetName.accept(result.planet_name)
            }
        })
    }

    var successResultText: String = "Success! Congradulations on Finding Falcone. King Shan is mightly pleased."

    var failureResultText: String = "Sorry! You didn't find falcone. Please try again."

    var totalTimeTakenText: String {
        "Time taken: \(destinationUseCase.getTotalTimeTaken())"
    }

    var planetNameText: Observable<String> {
        planetName
            .compactMap { $0 }
            .map { "Planet: \($0)"}
    }

    func restart() {
        restartUseCase.restart()
    }
}
