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

    func fetchRaspiDataFirst(completion: @escaping(Result<RaspData,Error>) -> ()){
        let urlStr = "http://10.2.100.3/insert4.php"

        fetch(urlStr: urlStr, completion: completion)
    }

    func fetchRaspiDataSecond(completion: @escaping(Result<SecondRaspData,Error>)-> ()){
        let urlStr = "http://10.2.100.3/insert5.php"

        fetch(urlStr: urlStr, completion: completion)
    }
    
    func fetchMotorForce(completion: @escaping(Result<MotorForce,Error>) ->()){
        let urlStr = "http://10.2.100.3/motor.php"
        fetch(urlStr: urlStr, completion: completion)
    }

//    private init() {
//        DispatchQueue.global().async {
//            while true{
//                NotificationCenter.default.post(name: Self.fetchFirstData, object: nil)
//                print("noti send")
//                sleep(2)
//            }
//        }
//    }
//
//
//    func fetch(completion: @escaping () -> ()) {
//        group.enter()
//        apiQueue.async {
//            self.fetchRaspiDataFirst() {(result) in
//                switch result {
//                case .success(let data):
//                    self.raspiF = data
//                    print("====> 라즈베리파이에서 넘어온 값 \(data)")
//                default:
//                    self.raspiF = nil
//                    print("파싱 실패")
//                }
//                self.group.leave()
//            }
//        }
//        apiQueue.async {
//            self.fetchRaspiDataSecond() {(result) in
//                switch result{
//                case .success(let value):
//                    self.raspiS = value
//                default:
//                    self.raspiS = nil
//                }
//                self.group.leave()
//            }
//        }
//        group.notify(queue: .main){
//            completion()
//        }
//    }
}

extension RaspiDataPasing{

}
