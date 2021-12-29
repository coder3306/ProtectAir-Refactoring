import Foundation
import RxSwift
import RxCocoa
import RxAlamofire

struct Room: Codable{
    struct Result: Codable {
        let sensor: String
        let collect_time: String
        let value1: String
        let value2: String
    }
    
    let result: [Result]
}

var list: [String:Any] = [:]

let bag = DisposeBag()
let urlStr = "http://192.168.0.15/insert4.php"

requestJSON(.get, urlStr)
    .subscribe(onNext: { res, json in
        self.list = json
    }).disposed(by: bag)
