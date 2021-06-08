//
//  PatientListViewController.swift
//  TemperatureWitheOxygenSaturation
//
//  Created by Fomagran on 2021/05/17.
//

import UIKit

class PatientListViewController: UIViewController {
    
    var name:String!
    
    let patients:[String] = ["안영훈","황석빈","윤재권","곽동하","김진웅","빈지노","나플라","오케이션"]

    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPatientInfoViewController" {
            let vc = segue.destination as! PatientInfoViewController
            vc.name = name
        }
    }
}

extension PatientListViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return patients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = patients[indexPath.row]
        cell.detailTextLabel?.text = "➡️"
        return cell
    }
    
    
}


extension PatientListViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        name = patients[indexPath.row]
        self.performSegue(withIdentifier: "showPatientInfoViewController", sender: nil)
    }
}
