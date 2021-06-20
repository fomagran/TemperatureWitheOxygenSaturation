//
//  PatientInfoTableViewCell.swift
//  TemperatureWitheOxygenSaturation
//
//  Created by Fomagran on 2021/05/17.
//

import UIKit

class PatientInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var circleView: CircularProgressBar!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var type: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setUp(type:String,number:Int,time:String) {
        circleView.labelSize = 40
        circleView.safePercent = number
        circleView.setProgress(to: Double(number)/Double(180), withAnimation: true)
        circleView.lineWidth = 30
        self.type.text = type
        self.time.text = dateToStringOnlyTime(date: Date())
    }
    
    func dateToStringOnlyTime(date:Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
           return dateFormatter.string(from: date)
        }
}
