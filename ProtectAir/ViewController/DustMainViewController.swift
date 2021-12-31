//
//  DustMainViewController.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/05.
//

import UIKit
import RxSwift
import RxCocoa

class DustMainViewController: UIViewController {
    private let setTabBarColor = TabBarController.shared
    private let bag = DisposeBag()
    private let urlStr = "http://192.168.0.15/insert4.php"
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dustTableView.backgroundColor = .clear
        dustTableView.separatorStyle = .none
        dustTableView.rowHeight = 200
        setTabBarColor.setTabbarBackgroundColor()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        SensorViewModel.shared.roomValue
            .bind(to: tableView.rx.items(cellIdentifier: "FirstCell", cellType: FirstDustTableViewCell.self)) { index, item, cell in
                cell.nameLabel.text = item.roomName
                cell.pm25Label.text = item.value1
                cell.pm100Label.text = item.value2
                cell.timeLabel.text = item.collect_time
                let pm25Int = Int(item.value1) ?? -20
                let pm100Int = Int(item.value2) ?? -20
                if pm25Int < 31 {
                    cell.pm25Image.image = UIImage(named: "good.png")
                } else if pm25Int < 81{
                    cell.pm25Image.image = UIImage(named: "normal.png")
                } else if pm25Int < 151 {
                    cell.pm25Image.image = UIImage(named: "bad.png")
                } else {
                    cell.pm25Image.image = UIImage(named: "verybad.png")
                }
                
                if pm100Int < 16 {
                    cell.pm100Image.image = UIImage(named: "good.png")
                } else if pm100Int < 36{
                    cell.pm100Image.image = UIImage(named: "normal.png")
                } else if pm100Int < 76 {
                    cell.pm100Image.image = UIImage(named: "bad.png")
                } else {
                    cell.pm100Image.image = UIImage(named: "verybad.png")
                }
            }.disposed(by: bag)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dustTableView: UITableView!
}
