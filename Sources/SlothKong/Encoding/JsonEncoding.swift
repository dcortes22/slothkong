//
//  JsonEncoding.swift
//  
//
//  Created by David Cortes on 24/2/22.
//

import Foundation

public struct JSONEncoding: ParameterEncoding {
    public static var `default`: JSONEncoding { JSONEncoding() }
    
    public static var prettyPrinted: JSONEncoding { JSONEncoding(options: .prettyPrinted) }
    
    public let options: JSONSerialization.WritingOptions
    
    public init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }
    
    public func encode(_ urlRequest: URLRequestType, with parameters: Parameters?, multiPartData: MultipartData? = nil) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        guard let parameters = parameters else { return urlRequest }

        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: options)

            if urlRequest.allHTTPHeaderFields?["Content-Type"] == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = data
        } catch {
            throw SlothError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }

        return urlRequest
    }
}
