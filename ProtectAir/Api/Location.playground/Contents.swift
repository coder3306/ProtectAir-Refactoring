import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import Foundation

final class Location: NSObject{
    static let shared: Location = Location()
    private let manager = CLLocationManager()
    
    private override init(){
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            manager.startUpdatingLocation()
        }
    }
}

extension Location: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.last{
            print(location)
        }
    }
    
}
