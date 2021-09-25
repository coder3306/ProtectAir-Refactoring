import Foundation
import UIKit

struct RaspData: Codable{
    struct Result: Codable {
        let sensor: String
        let collect_time: String
        let value1: String
        let value2: String
    }
    
    let result: [Result]
}

