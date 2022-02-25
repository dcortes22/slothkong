//
//  SlothError.swift
//  
//
//  Created by David Cortes on 24/2/22.
//

import Foundation

public enum SlothError: Error, Equatable {
    
    public enum ParameterEncodingFailureReason: Equatable {
        case missingURL
        case jsonEncodingFailed(error: Error)
        case customEncodingFailed(error: Error)
        
        public static func ==(lhs: ParameterEncodingFailureReason, rhs: ParameterEncodingFailureReason) -> Bool {
            switch (lhs, rhs) {
            case (.missingURL, .missingURL):
                return true
            case (.jsonEncodingFailed(_), .jsonEncodingFailed(_)):
                return true
            case (.customEncodingFailed(_), .customEncodingFailed(_)):
                return true
            default:
                return false
            }
        }
    }
    
    public enum NetworkFailureReason: Equatable {
        case unknown(_ description: String)
        case timeout
        case internalError(_ statusCode: Int)
        case serverError(_ statusCode: Int)
        
        public static func ==(lhs: NetworkFailureReason, rhs: NetworkFailureReason) -> Bool {
            switch (lhs, rhs) {
            case (.timeout, .timeout):
                return true
            case (let .unknown(stringlhs), let .unknown(stringrhs)):
                return stringlhs == stringrhs
            case (let .internalError(stringlhs), let .internalError(stringrhs)):
                return stringlhs == stringrhs
            case (let .serverError(stringlhs), let .serverError(stringrhs)):
                return stringlhs == stringrhs
            default:
                return false
            }
        }
    }
    
    public enum DecoderFailureReason: Equatable {
        case jsonDecoder(_ error: Error)
        
        public static func ==(lhs: DecoderFailureReason, rhs: DecoderFailureReason) -> Bool {
            switch (lhs, rhs) {
            case ( .jsonDecoder(_), .jsonDecoder(_)):
                return true
            }
        }
    }
    
    case parameterEncodingFailed(reason: ParameterEncodingFailureReason)
    case decoderFailed(reason: DecoderFailureReason)
    case connectionFailed(reason: NetworkFailureReason)
    
    public static func ==(lhs: SlothError, rhs: SlothError) -> Bool {
        switch (lhs, rhs) {
        case (let .parameterEncodingFailed(lhsString), let .parameterEncodingFailed(rhsString)):
            return lhsString == rhsString
        case (let .decoderFailed(lhsString), let .decoderFailed(rhsString)):
            return lhsString == rhsString
        case (let .connectionFailed(lhsString), let .connectionFailed(rhsString)):
            return lhsString == rhsString
        default:
            return false
        }
    }
}
