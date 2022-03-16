//
//  MockEndpointInvalid.swift
//  
//
//  Created by David Cortes on 9/3/22.
//

import Foundation

@testable import SlothKong

enum MockEndpointInvalid: MockEndpointError {
    
    case errorNotFound
    case timeout
    
    var maxTimeout: Double {
        switch self {
        case .errorNotFound:
            return defaultTimeout
        case .timeout:
            return 10.0
        }
    }
    
    var baseURL: URL {
        switch self {
        case .errorNotFound, .timeout:
            return URL(string: "http://valid.url")!
        }
    }
    
    var path: String {
        switch self {
        case .errorNotFound, .timeout:
            return ""
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .errorNotFound, .timeout:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .errorNotFound, .timeout:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .errorNotFound, .timeout:
            return nil
        }
    }
    
    var multiPartData: MultipartData? {
        return nil
    }
    
}
