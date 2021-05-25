//
//  AverageTableViewController.swift
//  TemperatureWitheOxygenSaturation
//
//  Created by Fomagran on 2021/05/25.
//

import UIKit

class AverageTableViewController: UITableViewController {

    var name:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        self.navigationItem.title = name
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
}
