//
//  PatientInfoViewController.swift
//  TemperatureWitheOxygenSaturation
//
//  Created by Fomagran on 2021/05/17.
//

import UIKit
import FirebaseDatabase

class PatientInfoViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var dataButton: UIButton!
    @IBOutlet weak var graphButton: UIButton!
    @IBOutlet weak var footerView: UIView!
    
    var name:String!
    let types = ["SpO2","BPM","Temperature"]
    var numbers = [0,0,0]
    let times = ["15:31:01","15:31:01","15:29:15"]
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        ref.observe(DataEventType.value, with: { (snapshot) in
            let data = snapshot.value as! [String:Int]
            self.numbers[1] = data["HeartRate"]!
            self.numbers[0] = data["SpO2"]!
            self.table.reloadData()
              })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAverageTableViewController" {
            let vc = segue.destination as! AverageTableViewController
            vc.name = name
        }
    }
    
    //MARK:- IBActions
    
    @IBAction func tapGraphButton(_ sender: Any) {
        
        performSegue(withIdentifier: "showChartViewController", sender: nil)
        
    }
    @IBAction func tapDataButton(_ sender: Any) {
        performSegue(withIdentifier: "showAverageTableViewController", sender: nil)
    }
}



extension PatientInfoViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "PatientInfoTableViewCell", for: indexPath) as! PatientInfoTableViewCell
        cell.setUp(type: types[indexPath.row], number: numbers[indexPath.row], time: times[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
}


extension PatientInfoViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        120
    }
}

