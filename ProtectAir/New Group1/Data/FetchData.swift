//
//  CurrentWeatherData.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/04.
//

import Foundation
import CoreLocation

import Foundation
import CoreLocation

class FetchData{
    let api = DispatchQueue(label: "ApiQueue", attributes: .concurrent)
    let group = DispatchGroup()
    var summary: CWeather?
    var dust: DustData?
    static let shared = FetchData()
    static let weatherUpdate = Notification.Name(rawValue: "weatherUpdate")

    private init () {
        NotificationCenter.default.addObserver(forName: Location.LocationUpdate, object: nil, queue: .main){ (noti) in
            if let location = noti.userInfo?["location"] as? CLLocation{
                self.fetchPasingData(location: location){
                    NotificationCenter.default.post(name: Self.weatherUpdate, object: nil)
                }
            }
        }
    }

    func fetchPasingData(location: CLLocation, completion: @escaping () -> ()) {
        group.enter()
        api.async {
            self.fetchWeather(location: location) {(result) in
                switch result {
                case .success(let data):
                    self.summary = data
                default:
                    self.summary = nil
                }
            self.group.leave()
            }
        }
        group.enter()
        api.async {
            self.fetchDust(location: location){(result) in
                switch result{
                case .success(let data):
                    self.dust = data
                default:
                    self.dust = nil
                }
                self.group.leave()
            }
        }
        
        group.notify(queue: .main){
            completion()
        }
    }

}

extension FetchData{
    private func fetch<PasingType: Codable>(urlStr: String, completion: @escaping(Result<PasingType,Error>) -> ()) {
        guard let requesturl = URL(string: urlStr) else {
            completion(.failure(ApiError.invalidURL(urlStr)))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: requesturl) { (data, response, error) in
            guard error == nil else { return }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
            
            let successRange = 200..<300
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ApiError.invalidResponse))
                return
            }
            
            guard successRange.contains(statusCode) else {
                completion(.failure(ApiError.failed(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(ApiError.emptyData))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let response = try decoder.decode(PasingType.self, from: data)
                
                completion(.success(response))

            }catch{
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    private func fetchWeather(location: CLLocation, completion: @escaping(Result<CWeather,Error>) -> ()){
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=a3d53c4b7a0f558bcce4af29031a28e4&units=metric&lang=en"
        fetch(urlStr: urlStr, completion: completion)
    }
    
    private func fetchDust(location: CLLocation, completion: @escaping(Result<DustData,Error>) ->()){
        let urlStr = "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=ebb2a9c22933e32d59f761c0c9fc6096"
        fetch(urlStr: urlStr, completion: completion)
    }
}
