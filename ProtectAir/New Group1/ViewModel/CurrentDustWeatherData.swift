//
//  CurrentDustWeatherData.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/07.
//

import Foundation
import CoreLocation
//
//class CurrentDustWeatherData{
//    static let shared = CurrentDustWeatherData()
//
//    private init () {
//        NotificationCenter.default.addObserver(forName: LocationManager.currentLocationDidUpdate, object: nil, queue: .main){ (noti) in
//            if let location = noti.userInfo?["location"] as? CLLocation{
//                self.fetch(location: location){
//                    NotificationCenter.default.post(name: Self.dustInfoDidUpdate, object: nil)
//                }
//            }
//        }
//    }
//
//    static let dustInfoDidUpdate = Notification.Name(rawValue: "DustInfoDidUpdate")
//    var dust: DustData?
//    let apiQueue = DispatchQueue(label: "ApiQueue", attributes: .concurrent)
//    let group = DispatchGroup()
//
//    func fetch(location: CLLocation, completion: @escaping () -> ()){
//        group.enter()
//        apiQueue.async {
//            self.fetchDustData(location: location){ (result) in
//                switch result {
//                case .success(let data):
//                    self.dust = data
//                    print("---> 파싱된 데이터 \(data)")
//                default:
//                    self.dust = nil
//
//                }
//                self.group.leave()
//            }
//        }
//        group.notify(queue: .main){
//            completion()
//        }
//    }
//}
//
//extension CurrentDustWeatherData{
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
//
//    private func fetchDustData(location: CLLocation, completion: @escaping(Result<DustData,Error>) ->()){
//        let urlStr = "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=ebb2a9c22933e32d59f761c0c9fc6096"
//        fetch(urlStr: urlStr, completion: completion)
//    }
//}
