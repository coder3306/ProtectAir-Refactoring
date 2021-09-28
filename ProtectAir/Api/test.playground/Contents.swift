import UIKit
import CoreLocation

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

enum ApiError: Error{
    case unknown
    case invalidURL(String)
    case invalidResponse
    case failed(Int)
    case emptyData
}

func fetch<PasingType: Codable>(urlStr: String, completion: @escaping(Result<PasingType,Error>) -> ()) {
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


func fetchWeather(location: CLLocation, completion: @escaping (Result<CWeather,Error>) -> ()){
    let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=a3d53c4b7a0f558bcce4af29031a28e4&units=metric&lang=kr"
    
    fetch(urlStr: urlStr, completion: completion)
}
func fetchDust(location: CLLocation, completion: @escaping(Result<DustData,Error>) ->()){
    let urlStr = "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=ebb2a9c22933e32d59f761c0c9fc6096"
    fetch(urlStr: urlStr, completion: completion)
}

let location = CLLocation(latitude: 37.498206, longitude: 127.02761)

fetchWeather(location: location) {(result) in
    switch result {
    case .success(let weather):
        dump(weather)
    case .failure(let error):
        error
    }
}
fetchDust(location: location) {(result) in
    switch result {
    case .success(let weather):
        dump(weather)
    case .failure(let error):
        error
    }
}
