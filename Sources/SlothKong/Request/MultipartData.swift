//
//  File.swift
//  
//
//  Created by David Cortes on 24/2/22.
//

import Foundation

public struct MultipartData {
    var data: Data
    var mimeType: MimeType
    var fileName, name: String
}
