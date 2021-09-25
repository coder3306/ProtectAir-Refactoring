//
//  RaspiDataPasing.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/13.
//

import Foundation
import UIKit

class RaspiDataPasing{
    static let shared = RaspiDataPasing()
    
    var raspi: RaspData?
    
    let apiQueue = DispatchQueue(label: "ApiQueue", attributes: .concurrent)
    let group = DispatchGroup()
    
    func fetch(completion: @escaping () -> ()) {
        group.enter()
        apiQueue.async {
            self.fetchRaspiData() {(result) in
                switch result {
                case .success(let data):
                    self.raspi = data
                    print("====> 라즈베리파이에서 넘어온 값 \(data)")
                default:
                    self.raspi = nil
                    print("파싱 실패")
                }
                self.group.leave()
            }
        }
        group.notify(queue: .main){
            completion()
        }
    }
}

extension RaspiDataPasing{
    
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
    
    private func fetchRaspiData(completion: @escaping(Result<RaspData,Error>) -> ()){
        let urlStr = "http://192.168.0.15/insert4.php"
    
        fetch(urlStr: urlStr, completion: completion)
    }
}
