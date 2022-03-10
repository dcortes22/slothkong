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
    case multipart(parameters:Int, multipartData: MultipartData)
    
    var baseURL: URL {
        switch self {
        case .list, .new, .multipart(_,_):
            return URL(string: "http://url.com")!
        }
    }
    
    var path: String {
        switch self {
        case .list, .new, .multipart(_,_):
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
        case .multipart(let parameters,_):
            var params = Parameters()
            params["user"] = parameters
            return params
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        case .new:
            return .post
        case .multipart(_,_):
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .list, .new:
            return [
                .contentType("application/json")
            ]
        default:
            return nil
        }
    }
    
    var multiPartData: MultipartData? {
        switch self {
        case .multipart(_, let multipartData):
            return multipartData
        default:
            return nil
        }
    }
    
}
