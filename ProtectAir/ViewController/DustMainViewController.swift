//
//  DustMainViewController.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/05.
//

import UIKit

class DustMainViewController: UIViewController {
    
    @IBOutlet weak var dustTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dustTableView.alpha = 1.0
        dustTableView.backgroundColor = .clear
        dustTableView.separatorStyle = .none
        dustTableView.rowHeight = 200
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        NotificationCenter.default.addObserver(forName: RaspiDataPasing.fetchData, object: nil, queue: .main) {(noti) in
            self.dustTableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    
        NotificationCenter.default.removeObserver(self)
    }
}

extension DustMainViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RaspiDustCell
        
        if indexPath.section == 0 {
            if let raspiData = RaspiDataPasing.shared.raspiF?.result.first{
                cell.nameLabel.text = "1호실"
                cell.pm25Label.text = "pm25 : \(raspiData.value1)"
                cell.pm100Label.text = "pm100 : \(raspiData.value2)"
            }
            cell.pm25Label.text = "pm25 : 500"
            cell.pm100Label.text = "pm100 : 5000"
            return cell
        }
    }
}

extension DustMainViewController: UITableViewDelegate{
}
