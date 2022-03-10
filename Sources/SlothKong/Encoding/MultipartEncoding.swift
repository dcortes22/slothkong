//
//  MultipartEncoding.swift
//  
//
//  Created by David Cortes on 10/3/22.
//

import Foundation

public struct MultipartEncoding: ParameterEncoding {
    
    public static var `default`: MultipartEncoding { MultipartEncoding() }
    
    public func encode(_ urlRequest: URLRequestType, with parameters: Parameters?, multiPartData: MultipartData?) throws -> URLRequest {
        
        var urlRequest = try urlRequest.asURLRequest()
        
        let boundary = UUID().uuidString
        
        var dataObject = Data()
        
        if let params = parameters {
            params.forEach { parameter in
                dataObject.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                dataObject.append("Content-Disposition: form-data; name=\"\(parameter.key)\"\r\n\r\n".data(using: .utf8)!)
                dataObject.append("\(parameter.value)".data(using: .utf8)!)
            }
        }
        
        guard let multiPartData = multiPartData else { return urlRequest }
        
        dataObject.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        dataObject.append("Content-Disposition: form-data; name=\"\(multiPartData.name)\"; filename=\"\(multiPartData.fileName)\"\r\n".data(using: .utf8)!)
        dataObject.append("Content-Type: \(multiPartData.mimeType.rawValue)\r\n\r\n".data(using: .utf8)!)
        dataObject.append(multiPartData.data)
        
        dataObject.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        if urlRequest.allHTTPHeaderFields?["Content-Type"] == nil {
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        } else {
            if let currentValue = urlRequest.allHTTPHeaderFields?["Content-Type"] {
                urlRequest.setValue("\(currentValue); boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            }
        }
        
        urlRequest.httpBody = dataObject
        
        return urlRequest
    }
}
