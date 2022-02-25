//
//  File.swift
//  
//
//  Created by David Cortes on 24/2/22.
//

import Foundation

public protocol ParameterEncoding {
    func encode(_ urlRequest: URLRequestType, with parameters: Parameters?) throws -> URLRequest
}
