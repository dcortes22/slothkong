//
//  Endpoint.swift
//  
//
//  Created by David Cortes on 23/2/22.
//

import Foundation
import Combine

public typealias Parameters = [String: Any]

public protocol Endpoint: URLRequestType, BaseRequestHandler {
    
    var baseURL: URL { get }
    
    var path: String { get }
    
    var parameters: Parameters? { get }
    
    var method: HTTPMethod { get }
    
    var headers: HTTPHeaders? { get }
    
    var multiPartData: MultipartData? { get }
}

extension Endpoint {
    
    var requestURL: URL {
        return baseURL.appendingPathComponent(path)
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        case .post:
            if let _ = multiPartData {
                return MultipartEncoding.default
            } else {
                return JSONEncoding.default
            }
        default:
            return JSONEncoding.default
        }
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        request.cachePolicy = .returnCacheDataElseLoad
        return request
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = try encoding.encode(urlRequest, with: parameters, multiPartData: multiPartData)
        
        if let headers = self.headers {
            request.headers = headers
        }
        return request
    }
}
