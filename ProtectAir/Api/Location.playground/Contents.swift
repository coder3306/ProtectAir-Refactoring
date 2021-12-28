import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import Foundation

class Location: NSObject{
    static let shared: Location = Location()
    private let manager = CLLocationManager()
    private let currentLocationRelay: BehaviorRelay<(lat: Double, lon:Double)?> = BehaviorRelay(value: nil)
    lazy var currentLocationn: Observable<(lat:Double, lon: Double)?> = self.currentLocationRelay.asObservable().share(replay: 1, scope: .forever)
    
    private override init(){
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            manager.startUpdatingLocation()
        }
    }
    
    deinit{
        manager.stopUpdatingLocation()
    }
}

extension Location: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.last{
            let currentLocation = (
                lat: location.coordinate.latitude,
                lon: location.coordinate.longitude
            )
            currentLocationRelay.accept(currentLocation)
        }
        manager.stopUpdatingLocation()
    }
}
