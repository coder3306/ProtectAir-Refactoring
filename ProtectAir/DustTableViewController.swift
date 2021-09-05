//
//  DustTableViewController.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/05.
//

import UIKit

class DustTableViewController: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pm25Image: UIImageView!
    @IBOutlet weak var pm25Label: UILabel!
    @IBOutlet weak var pm100Image: UIImageView!
    @IBOutlet weak var pm100Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        timeLabel.textColor = .white
        nameLabel.textColor = timeLabel.textColor
        pm25Label.textColor = timeLabel.textColor
        pm100Label.textColor = timeLabel.textColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
