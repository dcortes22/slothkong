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
    
    var baseURL: URL {
        switch self {
        case .errorNotFound:
            return URL(string: "http://valid.url")!
        }
    }
    
    var path: String {
        switch self {
        case .errorNotFound:
            return ""
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .errorNotFound:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .errorNotFound:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .errorNotFound:
            return nil
        }
    }
    
    var multiPartData: MultipartData? {
        return nil
    }
    
}
