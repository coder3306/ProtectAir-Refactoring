import Foundation
import UIKit

struct raspData: Codable{
    let id: String
    let time: String
    let pm25: Int
    let pm100: Int
    
    let microDust: [raspData]
}

//import UIKit
//
//struct infoData{
//    var name: String
//    var time: String
//    var myImg: UIImage?
//
//    init(name: String, time: String, myImg: UIImage){
//        self.name = name
//        self.time = time
//        self.myImg = myImg
//    }
//}
