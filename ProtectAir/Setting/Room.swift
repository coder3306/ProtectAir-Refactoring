import Foundation
import UIKit

struct Room: Codable{
    struct Result: Codable {
        let sensor: String
        let collect_time: String
        let value1: String
        let value2: String
    }
    
    let result: [Result]
}

struct SRoom: Codable{
    struct Result: Codable {
        let sensor: String
        let collect_time: String
        let value1: String
        let value2: String
    }
    let result: [Result]
}

struct MotorForce: Codable{
     struct Result: Codable{
          var no1motor: String
     }
     var result: [Result]
}
