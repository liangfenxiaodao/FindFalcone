//
//  FalconeProvider.swift
//  FindFalcone
//
//  Created by Jacky Li on 15/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import Foundation
import Moya
import RxSwift

struct FalconeProvider {
    let provider = MoyaProvider<FalconeAPI>()

    func getPlanets() -> Observable<[Planet]> {
        let request = provider.rx.request(.getPlanets)
        let mapping = { response -> Observable<[Planet]> in
            self.mapResponseTo(response: response)
        }
        return executeRequest(request: request, mapping: mapping)
    }

    func getVehicles() -> Observable<[Vehicle]> {
        let request = provider.rx.request(.getVehicles)
        let mapping = { response -> Observable<[Vehicle]> in
            self.mapResponseTo(response: response)
        }
        return executeRequest(request: request, mapping: mapping)
    }

    private func executeRequest<T>(request: PrimitiveSequence<SingleTrait, Response>, mapping: @escaping (Response) -> Observable<T> ) -> Observable<T> where T: Codable {
        return Observable.just(true)
            .flatMap { _ in
                request
        }
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
        .flatMap { (response) -> Observable<T> in
            return mapping(response)
        }
        .catchError({ (error) in
            return Observable.error(error)
        })
    }

    private func mapResponseTo<T>(response: Response) -> Observable<T> where T: Codable {
        do {
            let filteredResponse = try response.filterSuccessfulStatusCodes()
            return try Observable.just(JSONDecoder().decode(T.self, from: filteredResponse.data))
        } catch let error {
            return Observable.error(error)
        }
    }
}
