//
//  EncodableExtension.swift
//  TaxiApp
//
//  Created by Ihor Vozhdai on 17.03.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Foundation

enum TaxiAppError: Error {
    case encodingError
}

extension Encodable {

    func toJson(excluding keys: [String] = [String]()) throws -> [String: Any] {
        let objectData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        guard var json = jsonObject as? [String: Any] else { throw TaxiAppError.encodingError}

        for key in keys {
            json[key] = nil
        }
        return json
    }
}
