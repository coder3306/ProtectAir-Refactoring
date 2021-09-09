//
//  WeatherViewController.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/04.
//

import UIKit

class WeatherViewController: UITableViewCell {
    
    static let identifier = "SummaryTableViewCell"
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var minMaxLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var pm25Label: UILabel!
    @IBOutlet weak var pm100Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        statusLabel.textColor = .white
        minMaxLabel.textColor = statusLabel.textColor
        currentTemperatureLabel.textColor = statusLabel.textColor
        pm25Label.textColor = statusLabel.textColor
        pm100Label.textColor = statusLabel.textColor
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
