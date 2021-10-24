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
    static let fetchData = Notification.Name(rawValue: "fetchData")
    
    var raspiF: RaspData?
    var raspiS: SecondRaspData?
    let apiQueue = DispatchQueue(label: "ApiQueue", attributes: .concurrent)
    let group = DispatchGroup()
    
    private init() {
        NotificationCenter.default.post(name: Self.fetchData, object: nil)
    }
    
    
    func fetch(completion: @escaping () -> ()) {
        group.enter()
        apiQueue.async {
            self.fetchRaspiDataFirst() {(result) in
                switch result {
                case .success(let data):
                    self.raspiF = data
                    print("====> 라즈베리파이에서 넘어온 값 \(data)")
                default:
                    self.raspiF = nil
                    print("파싱 실패")
                }
                self.group.leave()
            }
        }
        apiQueue.async {
            self.fetchRaspiDataSecond() {(result) in
                switch result{
                case .success(let value):
                    self.raspiS = value
                default:
                    self.raspiS = nil
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
    
    private func fetchRaspiDataFirst(completion: @escaping(Result<RaspData,Error>) -> ()){
        let urlStr = "http://192.168.0.15/insert4.php"
    
        fetch(urlStr: urlStr, completion: completion)
    }
    
    private func fetchRaspiDataSecond(completion: @escaping(Result<RaspData,Error>)-> ()){
        let urlStr = "http://192.168.0.15/insert5.php"
        
        fetch(urlStr: urlStr, completion: completion)
    }
}
