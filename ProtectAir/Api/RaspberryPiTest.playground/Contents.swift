import UIKit
import CoreLocation


struct raspData: Codable{
    let id: String
    let time: String
    let pm25: Int
    let pm100: Int
     
     let microDust: [raspData]
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


private func fetchCurrentDust(completion: @escaping(Result<DustData,Error>) -> ()){
    let urlStr = "http://192.168.0.1/insert4.php"
    
    fetch(urlStr: urlStr, completion: completion)
}

fetchCurrentDust() {(result) in
    switch result{
    case .success(let dust):
        dump(dust)
    case .failure(let error):
        print(error)
    }
}
//fetchCurrentWeather(location: location) { (result) in
//    switch result {
//    case .success(let dust):
//        dump(dust)
//    case .failure(let error):
//        error
//    }
//}
