//
//  CurrentWeather.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/02.
//

import Foundation
import RxSwift

struct CWeather: Codable {
    struct Weather: Codable {
        let description: String
        let icon: String
    }
    let weather: [Weather]
    
    struct Main: Codable {
        let temp: Double
        let temp_min: Double
        let temp_max: Double
    }
    
    let main: Main
}

struct DustData: Codable{
    struct List: Codable {
        let dt: Int
        
        struct Main: Codable {
            let aqi: Int
        }
        
        let main: Main
        
        struct Components: Codable {
            let pm2_5: Double
            let pm10: Double
            let no2: Double
            let so2: Double
            let o3: Double
        }
        
        let components: Components
    }
    let list: [List]
}
