//
//  FutureExtensions.swift
//  
//
//  Created by David Cortes on 24/2/22.
//

import Foundation
import Combine

extension Future where Failure == Error {
    convenience init(operation: @escaping () async throws -> Output) {
        self.init { promise in
            Task {
                do {
                    let output = try await operation()
                    promise(.success(output))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}

extension PassthroughSubject where Failure == Error {
    static func emittingValues<T: AsyncSequence>(from sequence: T) -> Self where T.Element == Output {
        let subject = Self()
        Task {
            do {
                for try await value in sequence {
                    subject.send(value)
                }

                subject.send(completion: .finished)
            } catch {
                subject.send(completion: .failure(error))
            }
        }
        return subject
    }
}
