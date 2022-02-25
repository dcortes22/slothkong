//
//  Data.swift
//  
//
//  Created by David Cortes on 24/2/22.
//

import Foundation

extension Data {

    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
