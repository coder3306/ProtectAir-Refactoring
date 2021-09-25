import UIKit


struct raspData: Codable{
    struct Result: Codable {
        let sensor: String
        let collect_time: String
        let value1: String
        let value2: String
    }
    
    let result: [Result]
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

private func fetchCurrentDust(completion: @escaping(Result<raspData,Error>) -> ()){
    let urlStr = "http://192.168.0.15/insert4.php"
    
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
