//
//  Double+Formatter.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/04.
//

import Foundation

fileprivate let temperatureFormatter: MeasurementFormatter = {
    let f = MeasurementFormatter()
    f.locale = Locale(identifier: "ko_kr")
    f.numberFormatter.maximumFractionDigits = 1
    f.unitOptions = .temperatureWithoutUnit
    return f
}()

extension Double{
    var temperatureString: String{
        let temp = Measurement<UnitTemperature>(value: self, unit: .celsius)
        return temperatureFormatter.string(from: temp)
    }
}
