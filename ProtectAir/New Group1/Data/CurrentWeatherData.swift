//
//  CurrentWeatherData.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/04.
//

import Foundation
import CoreLocation

class CurrentWeatherData{
    static let shared = CurrentWeatherData()
    private init () {
        NotificationCenter.default.addObserver(forName: LocationManager.currentLocationDidUpdate, object: nil, queue: .main){ (noti) in
            if let location = noti.userInfo?["location"] as? CLLocation{
                self.fetch(location: location){
                    NotificationCenter.default.post(name: Self.weatherInfoDidUpdate, object: nil)
                }
            }
        }
    }

    static let weatherInfoDidUpdate = Notification.Name(rawValue: "weatherInfoDidUpdate")
    
    var summary: CurrentWeather?
    //var dust: DustData?
    let apiQueue = DispatchQueue(label: "ApiQueue", attributes: .concurrent)
    let group = DispatchGroup()

    func fetch(location: CLLocation, completion: @escaping () -> ()) {
        group.enter()
        apiQueue.async {
            self.fetchCurrentWeather(location: location) {(result) in
                switch result {
                case .success(let data):
                    self.summary = data
                    print(data)
                default:
                    self.summary = nil
                }
            self.group.leave()
            }
        }
        
        group.notify(queue: .main){
            completion()
        }
    }
//    let tlocation = CLLocation(latitude: 37.498206, longitude: 127.02761)
//    func fetch(location: tlocation, completion: @escaping () -> ()) {
//        group.enter()
//        apiQueue.async {
//            self.fetchDustData(location: self.tlocation){ (result) in
//                switch result {
//                case .success(let dust):
//                    self.dust = dust
//                    print("미세먼지 데이터 파싱 위치-->\(dust)")
//                default:
//                    self.dust = nil
//                    print("않됢")
//                }
//                self.group.leave()
//            }
//        }
//
//        group.notify(queue: .main){
//            completion()
//        }
//    }
}

extension CurrentWeatherData{
    private func fetch<PasingType: Codable>(urlStr: String, completion: @escaping(Result<PasingType,Error>) -> ()){
        guard let url = URL(string: urlStr) else {
            completion(.failure(ApiError.invalidURL(urlStr)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){(data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ApiError.invalidResponse))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(ApiError.failed(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(ApiError.emptyData))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let data = try decoder.decode(PasingType.self, from: data)
                completion(.success(data))
            }catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func fetchCurrentWeather(location: CLLocation, completion: @escaping(Result<CurrentWeather,Error>) -> ()){
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=a3d53c4b7a0f558bcce4af29031a28e4&units=metric&lang=kr"
        fetch(urlStr: urlStr, completion: completion)
    }
    
//    private func fetchDustData(location: CLLocation, completion: @escaping(Result<DustData,Error>) ->()){
//        let urlStr = "http://api.openweathermap.org/data/2.5/air_pollution?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=ebb2a9c22933e32d59f761c0c9fc6096"
//        fetch(urlStr: urlStr, completion: completion)
//    }
}
