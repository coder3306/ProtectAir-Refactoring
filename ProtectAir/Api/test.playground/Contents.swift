import UIKit
import CoreLocation
import RxSwift
import RxCocoa



struct CWeather: Codable {
    let dt: Int
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    let weather: [Weather]
    
    struct Main: Codable {
        let temp: Double
        let temp_min: Double
        let temp_max: Double
    }
    
    let main: Main
}

//enum ApiError: Error{
//    case badURL
//    case unknown
//    case invalidURL(String)
//    case invalidResponse
//    case invalidData
//    case failed(Int)
//    case emptyData
//}

let bag = DisposeBag()

//private var jsonDecoder = JSONDecoder()
//private let dustRelay = BehaviorRelay<DustDataType?>(value: nil)
//private let urlSession = URLSession.shared

//private func callAPI(request: URLRequest) -> Observable<DustDataType?>{
//    return Observable.create{ observer in
//        let task = urlSession.dataTask(with: request) { (data, response, error) in
//            if let httpResponse = response as? HTTPURLResponse{
//                let statusCode = httpResponse.statusCode
//                do{
//                    let data = data ?? Data()
//                    if (200...399).contains(statusCode) {
//                        let objs = try jsonDecoder.decode(RaspiData.self, from: data)
//                        observer.onNext(objs as? DustDataType)
//                    } else {
//                        observer.onError(ApiError.invalidResponse)
//                    }
//                }catch{
//                    observer.onError(ApiError.invalidData)
//                }
//            }
//            observer.onCompleted()
//        }
//        task.resume()
//
//        return Disposables.create {
//            task.cancel()
//        }
//    }
//}
//
//private func fetchDust() -> Observable<DustDataType?>{
//    let request = urlRequest()
//
//    return urlSession.rx.data(request: request)
//        .map{ data -> RaspiData in
//            let decoder = JSONDecoder()
//            return try decoder.decode(RaspiData.self, from: data)
//        }
//        .map{ DustData3(now: $0) }
//        .catchAndReturn(nil)
//}
//
//private func urlRequest() -> URLRequest {
//    let urlStr = "http://192.168.0.15/insert4.php"
//    let url = URL(string: urlStr)!
//    return URLRequest(url: url)
//}
//
//protocol DustDataType{
//    var sensor: String? { get }
//    var collect_time: String? { get }
//    var value1: String? { get }
//    var value2: String? { get }
//}
//
//struct DustData3: DustDataType, Equatable{
//    var sensor: String?
//    let collect_time: String?
//    let value1: String?
//    let value2: String?
//}
//
//extension DustData3{
//    init(now: RaspiData){
//        sensor = now.result.first?.sensor ?? "unknown123"
//        value1 = now.result.first?.value1
//        value2 = now.result.first?.value2
//        collect_time = now.result.first?.collect_time
//    }
//}
//let summary = fetchDust()
//Observable.just(summary)
//    .subscribe(onNext: { result in
//        print(result)
//    }).disposed(by: bag)
let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=37.26100&lon=127.04435&appid=a3d53c4b7a0f558bcce4af29031a28e4&units=metric&lang=en"

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
private func downloadDustJSON(_ url: String) -> Observable<CWeather?>{
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
let firstObservable = downloadJSON(urlStr)
let secondObservable = downloadDustJSON(urlStr)

Observable.zip(firstObservable,secondObservable)

var summary = CWeather?.self

downloadJSON(urlStr)
    .debug()
    .retry()
    .subscribe{ event in
        switch event{
        case let .next(json):
            if let data = json{
                //summary = data.weather
                print(data.main.temp)
            }
        case .completed:
            break
        case .error:
            break
    }
}
