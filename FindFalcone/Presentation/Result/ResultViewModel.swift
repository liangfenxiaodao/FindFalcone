//
//  ResultViewModel.swift
//  FindFalcone
//
//  Created by Jacky Li on 17/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import Foundation
import RxSwift

class ResultViewModel {
    let falconeUseCase = FalconeUseCase()

    func findFalcone() -> Observable<Result> {
        return falconeUseCase.findFalcone()
    }
}
