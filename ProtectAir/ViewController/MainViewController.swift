//
//  MainViewController.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/02.
//  ViewController

import UIKit
import CoreLocation
import RxCoreLocation
import RxSwift

private let bag = DisposeBag()

class MainViewController: UIViewController{
    //MARK: - InterfaceBuilder Links
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherTableView: UITableView!
    
    //MARK: - UI Logic
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var topInset = CGFloat(0.0)
        topInset = 50.0
        
        var inset = weatherTableView.contentInset
        inset.top = topInset
        
        weatherTableView.contentInset = inset
        weatherTableView.alpha = 0.0
        weatherTableView.backgroundColor = .clear
        weatherTableView.separatorStyle = .none
        weatherTableView.showsVerticalScrollIndicator = false
        weatherTableView.rowHeight = 350
        
        locationLabel.textColor = .white
    }
    
    //MARK: - ViewController Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initRefresh()

        Location.shared.updateLocation()
        updateLocationLabel()
        downloadJSONWeather()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        removeNotification()
    }
    
    //MARK: - Bisness Logic
    private func initRefresh() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
        refresh.attributedTitle = NSAttributedString(string: "새로고침")
        
        if #available(iOS 10.0, *){
            weatherTableView.refreshControl = refresh
        } else {
            weatherTableView.addSubview(refresh)
        }
    }
    
    private func updateLocationLabel(){
        Location.shared.manager.rx
            .placemark
            .subscribe(onNext: { [weak self] placemark in
                guard let name = placemark.name else { return }
                self?.locationLabel.text = name
            }).disposed(by: bag)
    }
    
    private func downloadJSONWeather(){
        NotificationCenter.default.rx.notification(.fetchWeather)
            .asDriver(onErrorRecover: {_ in .never()})
            .drive(onNext:{ [weak self] _ in
                self?.weatherTableView.reloadData()
                self?.weatherTableView.alpha = 1.0
            }).disposed(by: bag)
    }
    
    @objc private func updateUI(refresh: UIRefreshControl){
        refresh.endRefreshing()
        weatherTableView.reloadData()
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: .fetchWeather, object: nil)
    }
}

extension MainViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //옵셔널 바인딩 안하면 옵셔널값으로 튀어나오므로, if let 으로 옵셔널 바인딩 후 reloadData를 쓴다.
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
            if let weather = FetchData.shared.summary?.weather.first, let main = FetchData.shared.summary?.main {
                cell.weatherImageView.image = UIImage(named: weather.icon)
                cell.statusLabel.text = weather.description
                cell.tempMiniMaxiLabel.text = "최고기온 : \(main.temp_max.temperatureString)     최저기온 :  \(main.temp_min.temperatureString)"
                cell.tempLabel.text = "\(main.temp.temperatureString)"
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApiDustTableViewCell", for: indexPath) as! ApiDustTableViewCell
        if let dust = FetchData.shared.dust?.list.first{

            let no2Data: Double = dust.components.no2 / 10000
            let so2Data: Double = dust.components.so2 / 10000
            let o3Data:Double = dust.components.o3 / 1000

            cell.pm25DataLabel.text = "\(dust.components.pm2_5)"
            cell.pm100DataLabel.text = "\(dust.components.pm10)"
            cell.no2DataLabel.text = "\(String(format: "%.4f", no2Data))"
            cell.so2DataLabel.text = "\(String(format: "%.4f", so2Data))"
            cell.o3DataLabel.text = "\(String(format: "%.4f", o3Data))"

            if dust.components.pm2_5 < 30.0 {
                cell.pm25ImageView.image = UIImage(named: "good.png")
                cell.pm25StateLabel.text = "좋음"
            } else if dust.components.pm2_5 < 81.0 {
                cell.pm25ImageView.image = UIImage(named: "normally.png")
                cell.pm25StateLabel.text = "보통"
            } else if dust.components.pm2_5 < 151.0 {
                cell.pm25ImageView.image = UIImage(named: "bad.png")
                cell.pm25StateLabel.text = "나쁨"
            } else {
                cell.pm25ImageView.image = UIImage(named: "verybad.png")
                cell.pm25StateLabel.text = "최악"
            }

            if dust.components.pm10 < 15.0 {
                cell.pm100ImageView.image = UIImage(named: "good.png")
                cell.pm100StateLabel.text = "좋음"
            } else if dust.components.pm10 < 36.0 {
                cell.pm100ImageView.image = UIImage(named: "normally.png")
                cell.pm100StateLabel.text = "보통"
            } else if dust.components.pm10 < 76.0 {
                cell.pm100ImageView.image = UIImage(named: "bad.png")
                cell.pm100StateLabel.text = "나쁨"
            } else {
                cell.pm100ImageView.image = UIImage(named: "verybad.png")
                cell.pm100StateLabel.text = "최악"
            }

            //값 수정작업 후 작업해야함.
            if no2Data < 0.02 {
                cell.no2ImageView.image = UIImage(named: "good.png")
                cell.no2StateLabel.text = "좋음"
            } else if no2Data < 0.051 {
                cell.no2ImageView.image = UIImage(named: "normally.png")
                cell.no2StateLabel.text = "보통"
            } else if no2Data < 0.151 {
                cell.no2ImageView.image = UIImage(named: "bad.png")
                cell.no2StateLabel.text = "나쁨"
            } else {
                cell.no2ImageView.image = UIImage(named: "verybad.png")
                cell.no2StateLabel.text = "최악"
            }

            if so2Data < 0.03 {
                cell.so2ImageView.image = UIImage(named: "good.png")
                cell.so2StateLabel.text = "좋음"
            } else if so2Data < 0.061 {
                cell.so2ImageView.image = UIImage(named: "normally.png")
                cell.so2StateLabel.text = "보통"
            } else if so2Data < 0.21 {
                cell.so2ImageView.image = UIImage(named: "bad.png")
                cell.so2StateLabel.text = "나쁨"
            } else {
                cell.so2ImageView.image = UIImage(named: "verybad.png")
                cell.so2StateLabel.text = "최악"
            }

            if o3Data < 0.03 {
                cell.o3ImageView.image = UIImage(named: "good.png")
                cell.o3StateLabel.text = "좋음"
            } else if o3Data < 0.091 {
                cell.o3ImageView.image = UIImage(named: "normally.png")
                cell.o3StateLabel.text = "보통"
            } else if o3Data < 0.151 {
                cell.o3ImageView.image = UIImage(named: "bad.png")
                cell.o3StateLabel.text = "나쁨"
            } else {
                cell.o3ImageView.image = UIImage(named: "verybad.png")
                cell.o3StateLabel.text = "최악"
            }

        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}
