//
//  CurrentWeather.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/02.
//

import Foundation
import RxSwift

struct CWeather: Codable {
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

//struct refindData{
//    let refindDesc: String
//    let refindIcon: String
//    let refindTemp: Double
//    let refindTemp_min: Double
//    let refindTemp_max: Double
//    
//    init(refindDesc: String, refindIcon: String, refindTemp: Double, refindTemp_min: Double, refindTemp_max: Double){
//        self.refindDesc = refindDesc
//        self.refindIcon = refindIcon
//        self.refindTemp = refindTemp
//        self.refindTemp_min = refindTemp_min
//        self.refindTemp_max = refindTemp_max
//    }
//}

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
