//
//  URLRequestType.swift
//  
//
//  Created by David Cortes on 24/2/22.
//

import Foundation

public protocol URLRequestType {
    func asURLRequest() throws -> URLRequest
}
