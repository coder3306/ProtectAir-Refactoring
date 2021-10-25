//
//  DustMainViewController.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/05.
//

import UIKit

class DustMainViewController: UIViewController {
    var raspiF: RaspData?
    var raspiS: SecondRaspData?
    
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
        
        DispatchQueue.global().async {
            while true{
                print("viewdidload")
                RaspiDataPasing.shared.fetchRaspiDataFirst(){ [weak self] (result) in
                    switch result {
                    case .success(let data):
                        self?.raspiF = data
                    default:
                        self?.raspiF = nil
                        print("pasing failed")
                    }
                }
                RaspiDataPasing.shared.fetchRaspiDataSecond(){ [weak self] (result) in
                    switch result {
                    case .success(let data):
                        self?.raspiS = data
                    default:
                        self?.raspiS = nil
                        print("second raspi data pasing failed")
                    }
                }
                DispatchQueue.main.async {
                    self.dustTableView.reloadData()
                }
                sleep(2)
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
    }
}

extension DustMainViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstCell", for: indexPath) as! RaspiDustCell
            
            if let raspiData = raspiF?.result.first{
                cell.pm25Label.text = "pm25 : \(raspiData.value1)"
                cell.pm100Label.text = "pm100 : \(raspiData.value2)"
                cell.timeLabel.text = raspiData.collect_time
                
                let pm25Int = Int(raspiData.value1) ?? -20
                let pm100Int = Int(raspiData.value2) ?? -20
                
                if pm25Int < 31 {
                    cell.pm25Image.image = UIImage(named: "good.png")
                } else if pm25Int < 81 {
                    cell.pm25Image.image = UIImage(named: "normally.png")
                } else if pm25Int < 151{
                    cell.pm25Image.image = UIImage(named: "bad.png")
                } else {
                    cell.pm25Image.image = UIImage(named: "verybad.png")
                }
                
                if pm100Int < 16 {
                    cell.pm100Image.image = UIImage(named: "good.png")
                } else if pm100Int < 36 {
                    cell.pm100Image.image = UIImage(named: "normally.png")
                } else if pm100Int < 76 {
                    cell.pm100Image.image = UIImage(named: "bad.png")
                } else {
                    cell.pm100Image.image = UIImage(named: "verybad.png")
                }
            }
            cell.nameLabel.text = "1호실"
            return cell
        }
        let secondCell = tableView.dequeueReusableCell(withIdentifier: "SecondCell", for:indexPath) as! SecondRaspiCell
        
        secondCell.sNameLabel.text = "2호실"
        secondCell.sTimeLabel.text = "123"
        secondCell.sPm25Label.text = "업데이트"
        secondCell.sPm100Label.text = "업데이트"
        return secondCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

extension DustMainViewController: UITableViewDelegate{
}
