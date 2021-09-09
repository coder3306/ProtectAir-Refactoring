//
//  MainViewController.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/02.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherTableView: UITableView!
    
    var topInset = CGFloat(0.0)
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        if topInset == 0.0 {
//            let firstIndexPath = IndexPath(row: 0, section: 0)
//            if let cell = weatherTableView.cellForRow(at: firstIndexPath){
//                topInset = weatherTableView.frame.height - cell.frame.height
//
//                var inset = weatherTableView.contentInset
//                inset.top = topInset
//
//                weatherTableView.contentInset = inset
//            }
//        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherTableView.alpha = 0.0
        weatherTableView.backgroundColor = .clear
        weatherTableView.separatorStyle = .none
        weatherTableView.showsVerticalScrollIndicator = false
        locationLabel.textColor = .white
        weatherTableView.rowHeight = 800
        
        
        LocationManager.shared.updateLocation()
        
        NotificationCenter.default.addObserver(forName: CurrentWeatherData.weatherInfoDidUpdate, object: nil, queue: .main){ noti in
            self.weatherTableView.reloadData()
            self.locationLabel.text = LocationManager.shared.currentLocationTitle
            
            UIView.animate(withDuration: 0.3){
                self.weatherTableView.alpha = 1.0
            }
        }
    }
}

extension MainViewController: UITableViewDelegate{
    
}

extension MainViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryTableViewCell", for: indexPath) as! WeatherViewController
        //let dust = CurrentWeatherData.shared.dust?.list.first
        if let weather = CurrentWeatherData.shared.summary?.weather.first, let main = CurrentWeatherData.shared.summary?.main {
            cell.weatherImageView.image = UIImage(named: weather.icon)
            cell.statusLabel.text = weather.description
            cell.minMaxLabel.text = "최고 \(main.temp_max.temperatureString), 최소 \(main.temp_min.temperatureString)"
            cell.currentTemperatureLabel.text = "\(main.temp.temperatureString)"
            //cell.dustLabel.text = "PM2.5: \(dust!.components.pm2_5) , PM10: \(dust!.components.pm10)"
        }
        return cell
    }
}
