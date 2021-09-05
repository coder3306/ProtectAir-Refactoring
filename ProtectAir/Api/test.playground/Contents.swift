import UIKit
import Foundation
import CoreLocation

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


enum ApiError: Error{
    case unknown
    case invalidURL(String)
    case invalidResponse
    case failed(Int)
    case emptyData
}

import Foundation
import CoreLocation

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


private func fetchCurrentWeather(cityName: String, completion: @escaping(Result<CurrentWeather,Error>) -> ()){
    let urlStr = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)&units=metric&lang=kr"
    
    fetch(urlStr: urlStr, completion: completion)
}

private func fetchCurrentWeather(location: CLLocation, completion: @escaping(Result<CurrentWeather,Error>) -> ()){
    let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=a3d53c4b7a0f558bcce4af29031a28e4&units=metric&lang=kr"
    
    fetch(urlStr: urlStr, completion: completion)
}

private func fetchCurrentWeather(cityId: Int, completion: @escaping (Result<CurrentWeather,Error>) -> ()){
    let urlStr = "https://api.openweathermap.org/data/2.5/weather?q=\(cityId)&appid=\(apiKey)&units=metric&lang=kr"
    
    fetch(urlStr: urlStr, completion: completion)
}

let location = CLLocation(latitude: 37.498206, longitude: 127.02761)

fetchCurrentWeather(location: location) { (result) in
    switch result {
    case .success(let weather):
        dump(weather)
    case .failure(let error):
        error
    }
}
