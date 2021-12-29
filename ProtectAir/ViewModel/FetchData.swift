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
}

extension FetchData{
    private func downloadJSON(_ url: String) -> Observable<CWeather?>{
        //1. 비동기로 생기는 데이터를 Observable로 감싸서 리턴하는 방법
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
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiWeatherKey)&units=metric&lang=en"
        //2. Observable로 오는 데이터를 받아서 처리하는 방법
        downloadJSON(urlStr)
            //.debug()
            .subscribe{ [weak self] event in
                switch event{
                case let .next(json):
                    if let data = json{
                        self?.summary = data
                    }
                case .completed:
                    break
                case .error:
                    break
            }
        }.disposed(by: bag)
    }
    private func fetchDust(location: CLLocation){
        let urlStr = "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiDustKey)"
        downloadDustJSON(urlStr)
            .debug()
            .subscribe{ [weak self] event in
                switch event{
                case let .next(json):
                    if let data = json{
                        print(data)
                        self?.dust = data
                        NotificationCenter.default.post(name: .fetchWeather, object: nil)
                    }
                case .completed:
                    break
                case .error:
                    break
            }
        }.disposed(by: bag)
        
    }
    
    private var apiWeatherKey: String{
        get {
            guard let filePath = Bundle.main.path(forResource: "KeyList", ofType: "plist") else {
                fatalError()
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "OPENWEATHERMAP_KEY") as? String else {
                fatalError()
            }
            return value
        }
    }
    
    private var apiDustKey: String{
        get {
            guard let filePath = Bundle.main.path(forResource: "KeyList", ofType: "plist") else {
                fatalError()
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "OPENWEATHERDUSTMAP_KEY") as? String else {
                fatalError()
            }
            return value
        }
    }
}
