import Foundation
import UIKit

struct raspData: Codable{
    let id: String
    let time: String
    let pm25: Int
    let pm100: Int
     
     let microDust: [raspData]
}
