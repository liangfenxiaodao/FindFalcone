//
//  Result.swift
//  FindFalcone
//
//  Created by Jacky Li on 17/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import Foundation

struct Result: Codable {
    let status: String
    let planet_name: String?

    var isSuccess: Bool {
        return status == "success"
    }
}
