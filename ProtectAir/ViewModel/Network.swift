//
//  RaspiDataPasing.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/13.
//

import Foundation
import RxSwift

class Network{
    static let shared = Network()


    
//    private func fetch<PasingType: Codable>(urlStr: String, completion: @escaping(Result<PasingType,Error>) -> ()){
//        guard let url = URL(string: urlStr) else {
//            completion(.failure(ApiError.invalidURL(urlStr)))
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url){(data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                completion(.failure(ApiError.invalidResponse))
//                return
//            }
//
//            guard httpResponse.statusCode == 200 else {
//                completion(.failure(ApiError.failed(httpResponse.statusCode)))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(ApiError.emptyData))
//                return
//            }
//
//            do{
//                let decoder = JSONDecoder()
//                let data = try decoder.decode(PasingType.self, from: data)
//                completion(.success(data))
//            }catch{
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }

    func fetchRaspiDataFirst(completion: @escaping(Result<Room,Error>) -> ()){
        let urlStr = "http://10.2.100.3/insert4.php"
    }

    func fetchRaspiDataSecond(completion: @escaping(Result<SRoom,Error>)-> ()){
        let urlStr = "http://10.2.100.3/insert5.php"
    }
    
    func fetchMotorForce(completion: @escaping(Result<MotorForce,Error>) ->()){
        let urlStr = "http://10.2.100.3/motor.php"
    }
}
