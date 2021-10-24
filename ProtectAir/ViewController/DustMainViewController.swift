//
//  DustMainViewController.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/05.
//

import UIKit

class DustMainViewController: UIViewController {
    var raspiF: RaspData?
    
    @IBOutlet weak var dustTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dustTableView.alpha = 1.0
        dustTableView.backgroundColor = .clear
        dustTableView.separatorStyle = .none
        dustTableView.rowHeight = 200
        
        DispatchQueue.global().async {
            while true{
                print("viewdidload")
                RaspiDataPasing.shared.fetchRaspiDataFirst(){ (result) in
                    switch result {
                    case .success(let data):
                        self.raspiF = data
                    default:
                        self.raspiF = nil
                        print("pasing failed")
                    }
                }
                DispatchQueue.main.async {
                    self.dustTableView.reloadData()
                }
                sleep(2)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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

        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstCell", for: indexPath) as! RaspiDustCell
            
            if let raspiData = raspiF?.result.first{
                cell.pm25Label.text = "pm25 : \(raspiData.value1)"
                cell.pm100Label.text = "pm100 : \(raspiData.value2)"
            }
            cell.nameLabel.text = "1호실"
            return cell
        }
        let secondCell = tableView.dequeueReusableCell(withIdentifier: "SecondCell", for:indexPath) as! SecondRaspiCell
        
        secondCell.sNameLabel.text = "2호실"
        return secondCell
        
    }
}

extension DustMainViewController: UITableViewDelegate{
}
