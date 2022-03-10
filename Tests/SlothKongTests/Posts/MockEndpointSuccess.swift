//
//  MockEndpointSuccess.swift
//  
//
//  Created by David Cortes on 24/2/22.
//https://jsonplaceholder.typicode.com/list

import Foundation
@testable import SlothKong

enum MockEndpointSuccess: MockEndpoint {
    
    case list
    case new
    
    var baseURL: URL {
        switch self {
        case .list, .new:
            return URL(string: "http://url.com")!
        }
    }
    
    var path: String {
        switch self {
        case .list, .new:
            return ""
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .list:
            var params = Parameters()
            params["user"] = 1
            return params
        case .new:
            var params = Parameters()
            params["user"] = 1
            return params
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        case .new:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .list, .new:
            return [
                .contentType("application/json")
            ]
        }
    }
    
    
}
