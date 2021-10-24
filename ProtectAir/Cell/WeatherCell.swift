//
//  WeatherViewController.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/04.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    static let identifier = "SummaryTableViewCell"
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempMiniMaxiLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        statusLabel.textColor = .white
        tempMiniMaxiLabel.textColor = statusLabel.textColor
        tempLabel.textColor = statusLabel.textColor
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
