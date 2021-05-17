//
//  TestTableViewController.swift
//  TemperatureWitheOxygenSaturation
//
//  Created by Fomagran on 2020/11/30.
//

import UIKit
import FirebaseFirestore

class Spo2TableViewController: UITableViewController {
    @IBOutlet weak var plusBtn: UIBarButtonItem!
    
    @IBOutlet weak var refreshBtn: UIBarButtonItem!
    //온도 담는 배열
    var spo2Array = [String]()
    //날짜 담는 배열
    var datesArray = [String]()
    var documents = [String]()
    
    @IBAction func handleRefresh(_ sender: Any) {
        spo2Array.removeAll()
        datesArray.removeAll()
        documents.removeAll()
        fetchData()
    }
    
    @IBAction func handlePlus(_ sender: Any) {
        let alert = UIAlertController(title: "산소포화도", message: "추가할 산소 입력", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            guard let textField = alert.textFields else {return}
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let current = dateFormatter.string(from: date)
            let document = Firestore.firestore().collection("spo2").addDocument(data: ["spo2" : textField[0].text ?? "","date":current]).documentID
            self.spo2Array.insert(textField[0].text ?? "", at: 0)
            self.datesArray.insert(current, at: 0)
            self.documents.insert(document, at: 0)
            self.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in}
        alert.addAction(cancel)
        alert.addAction(ok)
        alert.addTextField{textField in textField.placeholder = "산소포화도를 입력해주세요"}
        self.present(alert, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    
    //데이터 받아오기
    func fetchData(){
        Firestore.firestore().collection("spo2").order(by: "date").addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else {return}
            self.spo2Array.removeAll()
            self.datesArray.removeAll()
            self.documents.removeAll()
            for document in snapshot.documents {
                self.spo2Array.insert(document.get("spo2") as! String, at: 0)
                self.datesArray.insert(document.get("date") as! String, at: 0)
                self.documents.insert(document.documentID, at: 0)
            }
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spo2Array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TemperatureCell", for: indexPath) as! TemperatureCell
        cell.tempartureLabel.text = spo2Array[indexPath.row]
        cell.dateLabel.text = datesArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        self.spo2Array.remove(at: indexPath.row)
        self.datesArray.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        Firestore.firestore().collection("spo2").document(documents[indexPath.row]).delete()
      }
    }
    


}
