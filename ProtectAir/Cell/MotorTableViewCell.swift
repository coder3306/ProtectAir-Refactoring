//
//  MotorTableViewCell.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/10/31.
//

import UIKit

class MotorTableViewCell: UITableViewCell {

    @IBOutlet weak var motorImageView: UIImageView!
    @IBOutlet weak var motorTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        motorTextLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
