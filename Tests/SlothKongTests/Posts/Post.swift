//
//  File.swift
//  
//
//  Created by David Cortes on 24/2/22.
//

import Foundation

struct Post: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
