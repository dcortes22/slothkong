//
//  MockBaseRequestHandlerError.swift
//  
//
//  Created by David Cortes on 9/3/22.
//

import Combine
import Foundation
@testable import SlothKong

extension BaseRequestHandler where Self: MockEndpointError  {
    
    func requestPublisher<T>(_ decoder: T.Type) -> AnyPublisher<T, SlothError> where T: Decodable {
        return Future { completion in
            completion(.failure(SlothError.connectionFailed(reason: .internalError(404))))
        }
        .delay(for: 0.5, scheduler: RunLoop.main)
        .eraseToAnyPublisher()
    }
}


