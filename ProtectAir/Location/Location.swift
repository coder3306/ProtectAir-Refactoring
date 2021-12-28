//
//  LocationManager.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/03.
//

import Foundation
import CoreLocation
import RxCoreLocation
import RxSwift

class Location: NSObject{
    let manager: CLLocationManager
    //싱클톤 패턴
    static let shared = Location()
    private let bag = DisposeBag()
    
    private override init(){
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        super.init()
        manager.delegate = self
        
        var userInfo = [AnyHashable: Any]()
        manager.rx
            .location
            .subscribe(onNext: { location in
                guard let location = location else { return }
                userInfo["location"] = location
                NotificationCenter.default.post(name: .location, object: nil, userInfo: userInfo)
                print(userInfo)
            }).disposed(by: bag)
    }
    
    func updateLocation()  {
        let status: CLAuthorizationStatus
        
        if #available(iOS 14.0, *){
            status = manager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        
        switch status {
        case .notDetermined:
            requestAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            requestCurrentLocation()
        case .denied, .restricted:
            print("not available")
        default:
            print("unknown")
        }
    }
}

extension Location: CLLocationManagerDelegate{
    private func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    private func requestCurrentLocation(){
        manager.requestLocation()
    }
    
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
        case .authorizedAlways, .authorizedWhenInUse:
            requestCurrentLocation()
        case .notDetermined, .denied, .restricted:
            print("not available")
        default:
            print("unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            requestCurrentLocation()
        case .notDetermined, .denied, .restricted:
            print("not available")
        default:
            print("unknown")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error : Error) {
        print(error)
    }
}
