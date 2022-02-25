//
//  BaseRequestHandler.swift
//  
//
//  Created by David Cortes on 24/2/22.
//

import Foundation
import Combine

public protocol BaseRequestHandler: SlothResponse {}

extension BaseRequestHandler where Self: URLRequestBase {
    
    var session: URLSession {
        let sessionConfig = URLSessionConfiguration.ephemeral
        sessionConfig.timeoutIntervalForRequest = 3.0
        sessionConfig.timeoutIntervalForResource = 6.0
        return URLSession(configuration: sessionConfig)
    }
    
    func request() async throws -> (Data, URLResponse) {
        var dataTuple:(Data, URLResponse) = (Data(), URLResponse())
        if #available(iOS 15.0, *) {
            dataTuple = try await session.data(for: self.asURLRequest())
        } else {
            dataTuple = try await session.dataAsync(for: self.asURLRequest())
        }
        return dataTuple
    }
    
//    func requestPublisher<T>(_ decoder: T.Type, data: MultipartData) -> AnyPublisher<T, SlothError> where T:Decodable {
//
//    }
    
    func requestPublisher<T>(_ decoder: T.Type) -> AnyPublisher<T, SlothError> where T: Decodable {
        Future {
            try await self.request()
        }
        .tryMap { (data, response) in
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                switch (response as! HTTPURLResponse).statusCode {
                case (400...499):
                    throw SlothError.connectionFailed(reason: .internalError((response as! HTTPURLResponse).statusCode))
                default:
                    throw SlothError.connectionFailed(reason: .serverError((response as! HTTPURLResponse).statusCode))
                }
            }
            return data
        }
        .decode(type: T.self, decoder: JSONDecoder())
        .mapError { error in
            switch error {
            case is Swift.DecodingError:
                return SlothError.decoderFailed(reason: .jsonDecoder(error))
            case let urlError as URLError:
                if urlError.errorCode == -1001 {
                    return SlothError.connectionFailed(reason: .timeout)
                }
                return SlothError.connectionFailed(reason: .unknown(urlError.localizedDescription))
            default:
                return error as! SlothError
            }
        }
        .eraseToAnyPublisher()
    }
}
