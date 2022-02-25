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
    case multipart
    case post(post: Post)
    
    var baseURL: URL {
        switch self {
        case .posts, .query, .multipart, .post(_):
            return URL(string: "https://jsonplaceholder.typicode.com/")!
        case .timeout:
            return URL(string: "https://httpstat.us/200")!
        case .notfound:
            return URL(string: "https://httpstat.us/404")!
        }
    }
    
    var path: String {
        switch self {
        case .posts, .query, .post(_):
            return "posts"
        case .timeout, .notfound, .multipart:
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
        case .multipart:
            var parameters = Parameters()
            parameters["userId"] = 2
            return parameters
        case .post(post: let post):
            var parameters = Parameters()
            parameters["userId"] = post.userId
            parameters["body"] = post.body
            parameters["title"] = post.title
            return parameters
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .multipart, .post(_):
            return .post
        default:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    
}
