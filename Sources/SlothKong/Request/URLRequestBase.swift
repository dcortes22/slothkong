//
//  URLRequestBase.swift
//  
//
//  Created by David Cortes on 23/2/22.
//

import Foundation
import Combine

public typealias Parameters = [String: Any]

protocol URLRequestBase: URLRequestType, BaseRequestHandler {
    
    var baseURL: URL { get }
    
    var path: String { get }
    
    var parameters: Parameters? { get }
    
    var method: HTTPMethod { get }
    
    var headers: HTTPHeaders? { get }
}

extension URLRequestBase {
    
    var requestURL: URL {
        return baseURL.appendingPathComponent(path)
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
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
    
    func asUploadRequest() throws -> URLRequest {
        var request = try encoding.encode(urlRequest, with: nil)
        if let headers = self.headers {
            request.headers = headers
        }
        return request
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = try encoding.encode(urlRequest, with: parameters)
        if let headers = self.headers {
            request.headers = headers
        }
        return request
    }
}
