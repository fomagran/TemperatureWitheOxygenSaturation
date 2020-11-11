//
//  TemperatureCell.swift
//  TemperatureWitheOxygenSaturation
//
//  Created by Fomagran on 2020/11/11.
//

import UIKit

class TemperatureCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempartureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
