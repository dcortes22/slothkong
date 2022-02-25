//
//  SlothResponse.swift
//  
//
//  Created by David Cortes on 24/2/22.
//

import Foundation
import Combine

protocol SlothResponse {
    var session: URLSession { get }
    
    var progress: PassthroughSubject<(id: Int, progress: Double), Never> { get }
}
