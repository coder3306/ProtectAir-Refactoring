//
//  RaspDustData.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/05.
//

//import Foundation
//
//class raspDustData{
//    static let shared = raspDustData()
//
//
//}
//
//extension raspData{
//    private func fetch<PasingType: Codable>(urlStr: String, completion: @escaping(Result<PasingType,Error>) -> ()) {
//        guard let url = URL(string: urlStr) else {
//        //fatalError("URL 생성 실패")
//        completion(.failure(ApiError.invalidURL(urlStr)))
//        return
//    }
//        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//            if let error = error{
//                //fatalError(error.localizedDescription)
//                completion(.failure(error))
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                completion(.failure(ApiError.invalidResponse))
//                //fatalError("invalid response")
//                return
//            }
//
//            guard httpResponse.statusCode == 200 else {
//                completion(.failure(ApiError.failed(httpResponse.statusCode)))
//                return
//                //fatalError("failed code \(httpResponse.statusCode)")
//            }
//
//            guard let data = data else {
//                completion(.failure(ApiError.emptyData))
//                //fatalError("empty data")
//                return
//            }
//
//            do{
//                let decoder = JSONDecoder()
//                let data = try decoder.decode(PasingType.self, from: data)
//
//                completion(.success(data))
//
//            }catch{
//                completion(.failure(error))
//                //print(error)
//                //fatalError(error.localizedDescription)
//            }
//        }
//        task.resume()
//    }
//}
//
