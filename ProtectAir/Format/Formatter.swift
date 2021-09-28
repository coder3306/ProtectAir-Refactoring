//
//  Formatter.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/28.
//

import Foundation

fileprivate let temperatureFormatter: MeasurementFormatter = {
    let f = MeasurementFormatter()
    f.locale = Locale(identifier: "ko_kr")  //로케일 변경
    f.numberFormatter.maximumFractionDigits = 1 // 소숫점이 최대 1자리까지만, 0이면 안보이게함
    f.unitOptions = .temperatureWithoutUnit // 섭씨나 화씨기호가 안보이게, ° 이거는 보임
    return f
}()

extension Double { //더블에 확장해서 .으로 쉽게 사용하게 만듬
    var temperatureString: String {
        let temp = Measurement<UnitTemperature>(value: self, unit: .celsius) //위의 MesurementFormatter()이기 때문에 Mesurement형식으로 만들어줘야 하는것 같다.
        return temperatureFormatter.string(from: temp)
        
    }
}
