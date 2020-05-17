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

class FalconeRepository {
    let provider = MoyaProvider<FalconeAPI>()

    func getPlanets() -> Observable<[Planet]> {
        return executeRequest(provider.rx.request(.getPlanets))
    }

    func getVehicles() -> Observable<[Vehicle]> {
        return executeRequest(provider.rx.request(.getVehicles))
    }

    func getToken() -> Observable<Token> {
        return executeRequest(provider.rx.request(.getToken))
    }

    func findFalcone(token: Token, destinations: [Destination]) -> Observable<Result> {
        return executeRequest(provider.rx.request(.findFalcone(token: token, destinations: destinations)))
    }

    private func executeRequest<T>(_ request: PrimitiveSequence<SingleTrait, Response>) -> Observable<T> where T: Codable {
        return Observable.just(true)
            .flatMap { _ in request }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .flatMap { [unowned self] (response) -> Observable<T> in
                return self.mapResponseTo(response: response)
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
