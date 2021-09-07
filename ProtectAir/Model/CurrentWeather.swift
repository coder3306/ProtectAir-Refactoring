//
//  CurrentWeather.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/02.
//

import Foundation

struct CurrentWeather: Codable {
    let dt: Int
    
    struct Weather: Codable {
        let id: Int
        let main: String
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
        }
        
        let components: Components
    }
    let list: [List]
}
