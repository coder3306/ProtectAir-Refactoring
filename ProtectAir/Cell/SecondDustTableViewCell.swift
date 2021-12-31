//
//  SecondRaspiCell.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/10/24.
//

import UIKit

class SecondDustTableViewCell: UITableViewCell {

    @IBOutlet weak var sTimeLabel: UILabel!
    @IBOutlet weak var sNameLabel: UILabel!
    @IBOutlet weak var sPm25Image: UIImageView!
    @IBOutlet weak var sPm25Label: UILabel!
    @IBOutlet weak var sPm100Image: UIImageView!
    @IBOutlet weak var sPm100Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        sTimeLabel.textColor = .white
        sPm25Label.textColor = .white
        sPm100Label.textColor = .white
        sNameLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
