//
//  LocationManager.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/03.
//

import Foundation
import UIKit
import CoreLocation

class LocationManager: NSObject{
    //싱클톤 패턴
    static let shared = LocationManager()
    
    private override init(){
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        super.init()
        manager.delegate = self
    }
    
    let manager: CLLocationManager
    
    var currentLocationTitle: String?{
        didSet{
            var userInfo = [AnyHashable: Any]()
            if let location = currentLocation {
                userInfo["location"] = location
            }
            
            NotificationCenter.default.post(name: Self.currentLocationDidUpdate, object: nil, userInfo: userInfo)
        }
    }
    var currentLocation: CLLocation?
    static let currentLocationDidUpdate = Notification.Name(rawValue: "currentLocationDidUpdate")
    
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

extension LocationManager: CLLocationManagerDelegate{
    private func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    private func requestCurrentLocation(){
        manager.requestLocation()
    }
    //지오코딩은 고유명칭을 가지고 위도와 경도의 좌표값를 얻는 것을 말한다. 이처럼 고유명칭이나 개별이름등을 가지고 검색하는것과는 달리 반대로 위도와 경도값으로부터 고유명칭을 얻는것은 리버스 지오코딩이된다.
    private func updateAddress(from location: CLLocation){
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location){[weak self] (placemarks, error) in
            if let error = error {
                print(error)
                self?.currentLocationTitle = "unknown"
                return
            }
            
            if let placemark = placemarks?.first{
                if let gu = placemark.locality, let dong = placemark.subLocality{
                    self?.currentLocationTitle = "\(gu) \(dong)"
                } else {
                    self?.currentLocationTitle = placemark.name ?? "unknown"
                }
            }
            print(self?.currentLocationTitle)
        }
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            currentLocation = location
            updateAddress(from: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error : Error) {
        print(error)
    }
}
