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
        request()
    }
    
    func request() {
        requestJSON(.get, urlStr)
            .debug()
            .subscribe(onNext: { res, json in
                if let data = json as? [String: AnyObject]{
                    if let result = data["result"]{
                        for item in result as! [AnyObject]{
                            let time = item["collect_time"]!
                            let name = item["sensor"]!
                            let value1 = item["value1"]!
                            let value2 = item["value2"]!
                            
                            //부연 설명: JSON파일 전송오류로 나뉘어져야 할 데이터가 함께 옴. 우선 하나의 데이터로 구현 먼저 해 놓고, JSON파일 전송을 수정한 다음에 데이터 처리
                            let roomData: [Room] = [
                                Room(roomName: "1호실",sensor: name as! String, collect_time: time as! String, value1: value1 as! String, value2: value2 as! String),
                                Room(roomName: "2호실",sensor: name as! String, collect_time: time as! String, value1: value1 as! String, value2: value2 as! String)
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
