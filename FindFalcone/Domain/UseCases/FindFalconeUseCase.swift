//
//  FindFalconeUseCase.swift
//  FindFalcone
//
//  Created by Jacky Li on 17/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import Foundation
import RxSwift

class FalconeUseCase {
    let disposeBag = DisposeBag()
    let falconeProvider = FalconeProvider()

    func findFalcone() -> Observable<Result> {
        falconeProvider.getToken()
            .flatMap { [unowned self] token in
                self.falconeProvider.findFalcone(token: token, destinations: DataStore.shared.destinations)
            }
    }
}
