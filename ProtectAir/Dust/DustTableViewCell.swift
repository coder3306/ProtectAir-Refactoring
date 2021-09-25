//
//  DustTableViewCell.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/12.
//

import Foundation
import UIKit

class DustTableViewCell : UITableViewCell{
    static let identifier = "DustTableViewCell"
    
    @IBOutlet weak var pm25: UILabel!
    @IBOutlet weak var pm100: UILabel!
    @IBOutlet weak var no2: UILabel!
    @IBOutlet weak var so2: UILabel!
    @IBOutlet weak var o3: UILabel!
    
    @IBOutlet weak var pm25ImageView: UIImageView!
    @IBOutlet weak var pm100ImageView: UIImageView!
    @IBOutlet weak var no2ImageView: UIImageView!
    @IBOutlet weak var so2ImageView: UIImageView!
    @IBOutlet weak var o3ImageView: UIImageView!
    
    @IBOutlet weak var pm25DataLabel: UILabel!
    @IBOutlet weak var pm100DataLabel: UILabel!
    @IBOutlet weak var no2DataLabel: UILabel!
    @IBOutlet weak var so2DataLabel: UILabel!
    @IBOutlet weak var o3DataLabel: UILabel!
    
    @IBOutlet weak var pm25StateLabel: UILabel!
    @IBOutlet weak var pm100StateLabel: UILabel!
    @IBOutlet weak var no2StateLabel: UILabel!
    @IBOutlet weak var so2StateLabel: UILabel!
    @IBOutlet weak var o3StateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        pm25.textColor = .white
        pm100.textColor = pm25.textColor
        no2.textColor = pm25.textColor
        so2.textColor = pm25.textColor
        o3.textColor = pm25.textColor
        
        pm25DataLabel.textColor = .white
        pm100DataLabel.textColor = pm25DataLabel.textColor
        no2DataLabel.textColor = pm25DataLabel.textColor
        so2DataLabel.textColor = pm25DataLabel.textColor
        o3DataLabel.textColor = pm25DataLabel.textColor
        
        pm25StateLabel.textColor = .white
        pm100StateLabel.textColor = pm25StateLabel.textColor
        no2StateLabel.textColor = pm25StateLabel.textColor
        so2StateLabel.textColor = pm25StateLabel.textColor
        o3StateLabel.textColor = pm25StateLabel.textColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
