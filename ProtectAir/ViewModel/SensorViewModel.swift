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
    
    func requestData(_ url:String) {
        requestJSON(.get, url)
            .subscribe(onNext: { res, json in
                print(json)
            }).disposed(by: bag)
    }
}
