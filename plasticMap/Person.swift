


import SwiftUI

struct Person: Codable, Identifiable{
    
    var id: String = UUID().uuidString
    var email: String
    var identity: String
    var name: String
    var point: Int
}

struct Store: Codable, Identifiable{
    
    var id: String = UUID().uuidString
    var name: String
    var address: String
    var discount: String
    var point: Int
}

struct Location: Codable, Identifiable{
    
    var id: String = UUID().uuidString
    var name: String
    var latitude: Double
    var longtitude: Double
    var bag: Int
}

