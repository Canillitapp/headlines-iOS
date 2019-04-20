//
//  Throwable.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 06/04/2019.
//  Copyright © 2019 Ezequiel Becerra. All rights reserved.
//

// Took it from https://stackoverflow.com/a/52070521/994129

enum Throwable<T: Decodable>: Decodable {
    case success(T)
    case failure(Error)

    init(from decoder: Decoder) throws {
        do {
            let decoded = try T(from: decoder)
            self = .success(decoded)
        } catch let error {
            self = .failure(error)
        }
    }
}

extension Throwable {
    var value: T? {
        switch self {
        case .failure:
            return nil

        case .success(let value):
            return value
        }
    }
}
