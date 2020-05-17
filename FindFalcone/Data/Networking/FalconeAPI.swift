//
//  FalconeAPI.swift
//  FindFalcone
//
//  Created by Jacky Li on 15/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import Foundation
import Moya

enum FalconeAPI {
    case getPlanets
    case getVehicles
    case getToken
    case findFalcone(token: Token, destinations: [Destination])
}

extension FalconeAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://findfalcone.herokuapp.com/")!
    }

    var path: String {
        switch self {
        case .getPlanets: return "planets"
        case .getVehicles: return "vehicles"
        case .getToken: return "token"
        case .findFalcone: return "find"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getPlanets, .getVehicles: return .get
        case .getToken, .findFalcone: return .post
        }
    }

    var task: Task {
        switch self {
        case .getPlanets, .getVehicles:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        case .getToken:
            return .requestPlain
        case let .findFalcone(token, destinations):
            return .requestJSONEncodable(FindFalconeRequest(token: token, destinations: destinations))
        }
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String : String]? {
        switch self {
        case .getPlanets, .getVehicles:
            return [:]
        case .getToken:
            return ["Accept": "application/json"]
        case .findFalcone:
            return ["Accept": "application/json", "Content-type": "application/json"]
        }
    }
}
