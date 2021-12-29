import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import UIKit

struct Room: Codable{
    let sensor: String
    let collect_time: String
    let value1: String
    let value2: String
}
var room1 = [Room]()
var list: Dictionary<String,Any> = [:]

let bag = DisposeBag()
let urlStr = "http://192.168.0.15/insert4.php"

requestJSON(.get, urlStr)
    .debug()
    .subscribe(onNext: { res, json in
        if let json = json as? [String: AnyObject]{
            if let jsonf = json["result"]{
                for item in jsonf as! [AnyObject]{
                    let time = item["collect_time"]!
                    let name = item["sensor"]!
                    let value1 = item["value1"]!
                    let value2 = item["value2"]!
                    
                }
            }
        }
    }, onError: { error in
        print(error)
    }).disposed(by: bag)
