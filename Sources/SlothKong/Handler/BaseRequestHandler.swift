//
//  BaseRequestHandler.swift
//  
//
//  Created by David Cortes on 24/2/22.
//

import Foundation
import Combine

protocol BaseRequestHandler: SlothResponse {}

extension BaseRequestHandler where Self: URLRequestBase {
    
    var progress: PassthroughSubject<(id: Int, progress: Double), Never> {
        return .init()
    }
    
    var session: URLSession {
        let sessionConfig = URLSessionConfiguration.ephemeral
        sessionConfig.timeoutIntervalForRequest = 3.0
        sessionConfig.timeoutIntervalForResource = 6.0
        return URLSession(configuration: sessionConfig, delegate: UploadResponseDelegate(subjec: progress), delegateQueue: nil)
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
    
    func requestPublisher(_ data:MultipartData) -> AnyPublisher<UploadResponse, SlothError> {
        let subject: PassthroughSubject<UploadResponse, SlothError> = .init()
        let boundary = UUID().uuidString
        var request = try! self.asUploadRequest()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var dataObject = Data()
        
        if let parameters = self.parameters {
            parameters.forEach { parameter in
                dataObject.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                dataObject.append("Content-Disposition: form-data; name=\"\(parameter.key)\"\r\n\r\n".data(using: .utf8)!)
                dataObject.append("\(parameter.value)".data(using: .utf8)!)
            }
        }
        
        dataObject.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        dataObject.append("Content-Disposition: form-data; name=\"\(data.name)\"; filename=\"\(data.fileName)\"\r\n".data(using: .utf8)!)
        dataObject.append("Content-Type: \(data.mimeType.rawValue)\r\n\r\n".data(using: .utf8)!)
        dataObject.append(data.data)
        
        dataObject.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        let task: URLSessionUploadTask = session.uploadTask(with: request, from: dataObject) { data, response, error in
            if let error = error {
                subject.send(completion: .failure(SlothError.connectionFailed(reason: .unknown(error.localizedDescription))))
                return
            }
            
            switch (response as! HTTPURLResponse).statusCode {
            case (200...299):
                subject.send(.response(data: data))
                return
            case (400...499):
                subject.send(completion: .failure(SlothError.connectionFailed(reason: .internalError((response as! HTTPURLResponse).statusCode))))
                return
            case (500...599):
                subject.send(completion: .failure(SlothError.connectionFailed(reason: .serverError((response as! HTTPURLResponse).statusCode))))
                 return
            default:
                subject.send(.response(data: nil))
            }
        }
        task.resume()
        return progress
                .filter{ $0.id == task.taskIdentifier }
                .setFailureType(to: SlothError.self)
                .map { .progress(percentage: $0.progress) }
                .merge(with: subject)
                .eraseToAnyPublisher()
    }
    
    func requestUploadPublisher(_ data: MultipartData) throws -> AnyPublisher<UploadResponse, SlothError> {
        let subject: PassthroughSubject<UploadResponse, SlothError> = .init()
        
        let task: URLSessionUploadTask = session.uploadTask(with: try self.asUploadRequest(), from: data.data) { data, response, error in
            if let error = error {
                subject.send(completion: .failure(SlothError.connectionFailed(reason: .unknown(error.localizedDescription))))
                return
            }
            
            switch (response as! HTTPURLResponse).statusCode {
            case (200...299):
                subject.send(.response(data: data))
                return
            case (400...499):
                subject.send(completion: .failure(SlothError.connectionFailed(reason: .internalError((response as! HTTPURLResponse).statusCode))))
                return
            case (500...599):
                subject.send(completion: .failure(SlothError.connectionFailed(reason: .serverError((response as! HTTPURLResponse).statusCode))))
                 return
            default:
                subject.send(.response(data: nil))
            }
        }
        task.resume()
        return progress
                .filter{ $0.id == task.taskIdentifier }
                .setFailureType(to: SlothError.self)
                .map { .progress(percentage: $0.progress) }
                .merge(with: subject)
                .eraseToAnyPublisher()
    }
    
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
