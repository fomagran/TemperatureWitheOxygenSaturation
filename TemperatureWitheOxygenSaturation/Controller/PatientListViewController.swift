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
    
    var patients:[String] = []
    
    let ref = Firestore.firestore().collection("Users")

    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getPatientList()
    }
    
    func getPatientList() {
        ref.getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            self.patients = snapshot.documents.map{$0.documentID}
            self.table.reloadData()
        }
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        let alert = UIAlertController(title: "환자 이름", message: "환자 이름을 입력해주세요!", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            self.ref.document(alert.textFields?[0].text ?? "").setData(["bpm":0,"temperature":0,"SpO2":0])
            self.getPatientList()
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
