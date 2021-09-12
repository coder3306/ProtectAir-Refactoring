import UIKit
import CoreLocation


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


private func fetchDustData(location: CLLocation, completion: @escaping(Result<DustData,Error>) ->()){
    let urlStr = "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=ebb2a9c22933e32d59f761c0c9fc6096"
    fetch(urlStr: urlStr, completion: completion)
}

let location = CLLocation(latitude: 37.498206, longitude: 127.02761)

fetchDustData(location: location) {(result) in
    switch result{
    case .success(let dust):
        dump(dust)
    case .failure(let error):
        print(error)
    }
}
