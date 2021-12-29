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
    var isSensorTrigger: Bool = true
    @IBOutlet weak var dustTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        dustTableView.backgroundColor = .clear
        dustTableView.separatorStyle = .none
        dustTableView.rowHeight = 200
        
        DispatchQueue.global().async {
            while self.isSensorTrigger == true{
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.isSensorTrigger = true
        print("trigger on")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.isSensorTrigger = false
        print("Trigger off")
    }
}

extension DustMainViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstCell", for: indexPath) as! FirstDustTableViewCell
            
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
        let secondCell = tableView.dequeueReusableCell(withIdentifier: "SecondCell", for:indexPath) as! SecondDustTableViewCell
        
        if let secondRaspiData = raspiS?.result.first{
            secondCell.sTimeLabel.text = secondRaspiData.collect_time
            secondCell.sPm25Label.text = "pm25 : \(secondRaspiData.value1)"
            secondCell.sPm100Label.text = "pm100 : \(secondRaspiData.value2)"
            
            let secondPm25Int = Int(secondRaspiData.value1) ?? -20
            let secondPm100Int = Int(secondRaspiData.value2) ?? -20
            
            if secondPm25Int < 31 {
                secondCell.sPm25Image.image = UIImage(named: "good.png")
            } else if secondPm25Int < 81 {
                secondCell.sPm25Image.image = UIImage(named: "normally.png")
            } else if secondPm25Int < 151{
                secondCell.sPm25Image.image = UIImage(named: "bad.png")
            } else {
                secondCell.sPm25Image.image = UIImage(named: "verybad.png")
            }
            
            if secondPm100Int < 16 {
                secondCell.sPm100Image.image = UIImage(named: "good.png")
            } else if secondPm100Int < 36 {
                secondCell.sPm100Image.image = UIImage(named: "normally.png")
            } else if secondPm100Int < 76 {
                secondCell.sPm100Image.image = UIImage(named: "bad.png")
            } else {
                secondCell.sPm100Image.image = UIImage(named: "verybad.png")
            }
        }
        secondCell.sNameLabel.text = "2호실"
        return secondCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}
