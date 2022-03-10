//
//  MockBaseRequestHandler.swift
//  
//
//  Created by David Cortes on 9/3/22.
//
import Combine
import Foundation
@testable import SlothKong

extension BaseRequestHandler where Self: MockEndpoint {
    
    func requestPublisher<T>(_ decoder: T.Type) -> AnyPublisher<T, SlothError> where T: Decodable {
        
        let data = """
        [{
                "userId": 1,
                "id": 1,
                "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                "body": "quia et suscipit suscipit recusandae consequuntur expedita et cum reprehenderit molestiae ut ut quas totam nostrum rerum est autem sunt rem eveniet architecto"
            },
            {
                "userId": 1,
                "id": 2,
                "title": "qui est esse",
                "body": "est rerum tempore vitae sequi sint nihil reprehenderit dolor beatae ea dolores neque fugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis qui aperiam non debitis possimus qui neque nisi nulla"
            }
        ]
        """.data(using: .utf8)
        
        let model = try! JSONDecoder().decode(decoder.self, from: data!)
        return Future { completion in
            completion(.success(model))
        }
        .delay(for: 0.5, scheduler: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
