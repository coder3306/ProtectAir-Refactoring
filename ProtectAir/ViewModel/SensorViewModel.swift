//
//  SensorViewModel.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/12/29.
//

import Foundation
import RxSwift
import RxAlamofire

class SensorViewModel {
    static let shared = SensorViewModel()
    private let bag = DisposeBag()
    private let urlStr = "http://192.168.0.15/insert4.php"
    
    var roomValue = BehaviorSubject<[Room]>(value: [])
    
    private init() {
        let dummy: [Room] = [
            Room(sensor: "123", collect_time: "123", value1: "234", value2: "345")
        ]
        roomValue.onNext(dummy)
        
        request()
    }
    
    func request() {
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
                            
                            let roomData: [Room] = [
                                Room(sensor: name as! String, collect_time: time as! String, value1: value1 as! String, value2: value2 as! String)
                            ]
                            print(roomData)
                            self.roomValue.onNext(roomData)
                        }
                    }
                }
            }, onError: { error in
                print(error)
            }).disposed(by: bag)
    }
}
