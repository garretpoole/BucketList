//
//  Location.swift
//  BucketList
//
//  Created by Garret Poole on 4/21/22.
//

import Foundation

struct Location: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
}
