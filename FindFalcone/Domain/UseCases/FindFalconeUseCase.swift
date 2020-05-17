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
    let falconeRepository = FalconeRepository()

    func findFalcone() -> Observable<Result> {
        falconeRepository.getToken()
            .flatMap { [unowned self] token in
                self.falconeRepository.findFalcone(token: token, destinations: DataStore.shared.destinations)
            }
    }
}
