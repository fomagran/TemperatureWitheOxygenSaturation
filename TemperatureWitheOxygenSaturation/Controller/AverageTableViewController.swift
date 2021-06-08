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
    var info:[String] = ["SpO2","BPM","Temperature"]
    lazy var infoValue:[String] = ["12","30","36.5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        self.navigationItem.title = name
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return info.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        cell.textLabel?.text = info[indexPath.row]
        cell.detailTextLabel?.text = infoValue[indexPath.row]
        return cell
    }
}
