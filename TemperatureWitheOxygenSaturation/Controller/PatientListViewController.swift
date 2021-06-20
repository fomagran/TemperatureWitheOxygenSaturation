//
//  PatientListViewController.swift
//  TemperatureWitheOxygenSaturation
//
//  Created by Fomagran on 2021/05/17.
//

import UIKit
import FirebaseFirestore

class PatientListViewController: UIViewController {
    
    var name:String!
    
    let patients:[String] = ["안영훈","황석빈","윤재권","곽동하","김진웅","빈지노","나플라","오케이션"]
    
    let ref = Firestore.firestore().collection("Users")

    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        let alert = UIAlertController(title: "환자 이름", message: "환자 이름을 입력해주세요!", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            self.ref.document(alert.textFields?[0].text ?? "").setData(["bpm":0,"temperature":0,"SpO2":0])
        }
        
        alert.addAction(ok)
            
        alert.addTextField { tf in
            tf.placeholder = "이름"
        }
        
        self.present(alert, animated: true, completion: nil)
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
