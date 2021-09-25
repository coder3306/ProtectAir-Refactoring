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
}

extension DustMainViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DustTableViewController
        
        if let raspiData = RaspiDataPasing.shared.raspi?.result.first{
            cell.nameLabel.text = "1호실"
            cell.pm25Label.text = "pm25 : \(raspiData.value1)"
            cell.pm100Label.text = "pm100 : \(raspiData.value2)"
        }

        return cell
    }

}

extension DustMainViewController: UITableViewDelegate{
    
}
