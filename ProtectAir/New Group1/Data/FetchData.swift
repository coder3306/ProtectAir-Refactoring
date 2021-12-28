//
//  CurrentWeatherData.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/04.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

class FetchData{
    static let shared = FetchData()
    static let weatherUpdate = Notification.Name(rawValue: "weatherUpdate")

    var summary: CWeather?
    var dust: DustData?
    
    private let bag = DisposeBag()

    private init () {
        NotificationCenter.default.rx.notification(.location)
            .subscribe{ noti in
                if let location = noti.element?.userInfo?["location"] as? CLLocation{
                    self.fetchWeather(location: location)
                    self.fetchDust(location: location)
                }
            }.disposed(by: bag)
    }

//    func fetchPasingData(location: CLLocation, completion: @escaping () -> ()) {
//        group.enter()
//        api.async {
//            self.fetchWeather(location: location) {(result) in
//                switch result {
//                case .success(let data):
//                    print(data)
//                    self.summary = data
//                default:
//                    self.summary = nil
//                }
//            self.group.leave()
//            }
//        }
//        group.enter()
//        api.async {
//            self.fetchDust(location: location){(result) in
//                switch result{
//                case .success(let data):
//                    self.dust = data
//                default:
//                    self.dust = nil
//                }
//                self.group.leave()
//            }
//        }
//
//        group.notify(queue: .main){
//            completion()
//        }
//    }

}

extension FetchData{
    private func downloadJSON(_ url: String) -> Observable<CWeather?>{
        return Observable.create(){ observer in
            let url = URL(string: url)!
            let task = URLSession.shared.dataTask(with: url){ (data, response, error) in
                if (response as? HTTPURLResponse) != nil{
                    guard error == nil else { return }
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
                    let successRange = 200..<300
                    guard (response as? HTTPURLResponse) != nil else {
                        observer.onError(error!)
                        return
                    }
                    guard successRange.contains(statusCode) else {
                        observer.onError(error!)
                        return
                    }
                    guard data != nil else {
                        observer.onError(error!)
                        return
                    }
                    
                    do{
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(CWeather.self, from: data!)
                        observer.onNext(response)
                    }catch{
                        observer.onError(error)
                    }
                    observer.onCompleted()
                }
            }
            task.resume()
            
            return Disposables.create(){
                task.cancel()
            }
        }
    }
    
    private func downloadDustJSON(_ url: String) -> Observable<DustData?>{
        return Observable.create(){ observer in
            let url = URL(string: url)!
            let task = URLSession.shared.dataTask(with: url){ (data, response, error) in
                if (response as? HTTPURLResponse) != nil{
                    guard error == nil else { return }
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
                    let successRange = 200..<300
                    guard (response as? HTTPURLResponse) != nil else {
                        observer.onError(error!)
                        return
                    }
                    guard successRange.contains(statusCode) else {
                        observer.onError(error!)
                        return
                    }
                    guard data != nil else {
                        observer.onError(error!)
                        return
                    }
                    
                    do{
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(DustData.self, from: data!)
                        observer.onNext(response)
                    }catch{
                        observer.onError(error)
                    }
                    observer.onCompleted()
                }
            }
            task.resume()
            
            return Disposables.create(){
                task.cancel()
            }
        }
    }
    
    private func fetchWeather(location: CLLocation){
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=a3d53c4b7a0f558bcce4af29031a28e4&units=metric&lang=en"
        downloadJSON(urlStr)
            //.debug()
            .subscribe{ [weak self] event in
                switch event{
                case let .next(json):
                    if let data = json{
                        self.summary = data
                    }
                case .completed:
                    break
                case .error:
                    break
            }
        }.disposed(by: bag)
    }
    private func fetchDust(location: CLLocation){
        let urlStr = "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=ebb2a9c22933e32d59f761c0c9fc6096"
        downloadDustJSON(urlStr)
            //.debug()
            .subscribe{ [weak self] event in
                switch event{
                case let .next(json):
                    if let data = json{
                        print(data)
                        self.dust = data
                        NotificationCenter.default.post(name: .fetchWeather, object: nil)
                    }
                case .completed:
                    break
                case .error:
                    break
            }
        }.disposed(by: bag)
        
    }
}
