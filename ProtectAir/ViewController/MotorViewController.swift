//
//  MotorViewController.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/10/30.
//

import UIKit

class MotorViewController: UIViewController {
    
    @IBOutlet weak var motorTableView: UITableView!
    var raspiMotorData: MotorForce?
    var isMotorTrigger: Bool = true
    
    override func viewDidLoad() {
        motorTableView.rowHeight = 700
        super.viewDidLoad()
//        DispatchQueue.global().async {
//            while self.isMotorTrigger == true{
//                RaspiDataPasing.shared.fetchMotorForce(){ [weak self] (result) in
//                    switch result {
        
//                    case .success(let motorData):
//                        self?.raspiMotorData = motorData
//                    default:
//                        print("motor pasing failed")
//                    }
//                }
//                DispatchQueue.main.async {
//                    self.motorTableView.reloadData()
//                }
//                sleep(2)
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isMotorTrigger = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.isMotorTrigger = false
    }
}

extension MotorViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let motorCell = tableView.dequeueReusableCell(withIdentifier: "motorCell", for: indexPath) as? MotorTableViewCell else { return UITableViewCell() }
        if let motorForceData = raspiMotorData?.result.first{
            if motorForceData.no1motor == "0"{
                motorCell.motorTextLabel.text = "모터가 꺼져 있습니다."
                motorCell.motorImageView.image = UIImage(named: "img1.png")
            } else{
                motorCell.motorTextLabel.text = "모터의 힘이 \(motorForceData.no1motor)%로 작동하고 있습니다."
                motorCell.motorImageView.image = UIImage(named: "img2.png")
            }
        }
        return motorCell
    }
}
