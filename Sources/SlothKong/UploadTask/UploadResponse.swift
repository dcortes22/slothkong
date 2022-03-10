//
//  UploadResponse.swift
//  
//
//  Created by David Cortes on 24/2/22.
//

import Foundation

public enum UploadResponse {
    case progress(percentage: Double)
    case response(data: Data?)
}
