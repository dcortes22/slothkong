//
//  PostsEndpoint.swift
//  
//
//  Created by David Cortes on 24/2/22.
//https://jsonplaceholder.typicode.com/posts

import Foundation
@testable import SlothKong

enum PostsEndpoint: URLRequestBase {
    
    case posts
    case timeout
    case notfound
    case query
    
    var baseURL: URL {
        switch self {
        case .posts, .query:
            return URL(string: "https://jsonplaceholder.typicode.com/")!
        case .timeout:
            return URL(string: "https://httpstat.us/200")!
        case .notfound:
            return URL(string: "https://httpstat.us/404")!
        }
    }
    
    var path: String {
        switch self {
        case .posts, .query:
            return "posts"
        case .timeout, .notfound:
            return ""
        }
        
    }
    
    var parameters: Parameters? {
        switch self {
        case .posts, .notfound:
            return nil
        case .timeout:
            var parameters = Parameters()
            parameters["sleep"] = 100000
            return parameters
        case .query:
            var parameters = Parameters()
            parameters["userId"] = 2
            return parameters
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    
}
