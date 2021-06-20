//
//  AverageTableViewController.swift
//  TemperatureWitheOxygenSaturation
//
//  Created by Fomagran on 2021/05/25.
//

import UIKit
import FirebaseFirestore

class AverageTableViewController: UITableViewController {

    var name:String!
    var temperatures:[Int]!
    var collectionRef = Firestore.firestore().collection("Users")
    
    var info:[String] = ["SpO2","BPM","Temperature"]
    var infoValue:[Int] = [0,0,0]
    var spo2s:[Int] = []
    var bpms:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getHeartRate()
    }
    
    private func configure() {
        self.navigationItem.title = name
    }
    
    func getHeartRate() {
        collectionRef.document(name).collection("HeartRate").getDocuments { snapshot, error in
            guard let snapshot = snapshot else {return}
            for document in snapshot.documents {
                self.bpms.append(document.get("HeartRate") as! Int)
                if self.bpms.count == snapshot.documents.count {
                    self.getSpO2()
                }
            }
        }
    }
    
    func getSpO2() {
        collectionRef.document(name).collection("SpO2").getDocuments { snapshot, error in
            guard let snapshot = snapshot else {return}
            for document in snapshot.documents {
                self.spo2s.append(document.get("SpO2") as! Int)
                if self.spo2s.count == snapshot.documents.count {
                    self.setAverage()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func setAverage() {
        if spo2s.count > 0 {
        infoValue[0] = spo2s.reduce(0,+)/spo2s.count
        }
        if spo2s.count > 0 {
        infoValue[1] = spo2s.reduce(0,+)/bpms.count
        }
        if temperatures.count > 0 {
        infoValue[2] = temperatures.reduce(0,+)/temperatures.count
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return info.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        cell.textLabel?.text = info[indexPath.row]
        cell.detailTextLabel?.text = "\(infoValue[indexPath.row])"
        return cell
    }
}
