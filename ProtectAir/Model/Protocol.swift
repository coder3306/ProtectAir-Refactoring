//
//  Protocol.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/12/28.
//

import Foundation
import RxSwift

extension NSNotification.Name{
    static let location = NSNotification.Name("location")
    static let fetchWeather = NSNotification.Name("fetchWeather")
    static let fetchDustWeather = NSNotification.Name("fetchDustWeather")
}
