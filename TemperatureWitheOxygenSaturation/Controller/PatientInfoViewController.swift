//
//  PatientInfoViewController.swift
//  TemperatureWitheOxygenSaturation
//
//  Created by Fomagran on 2021/05/17.
//

import UIKit
import FirebaseDatabase
import HealthKit
import FirebaseFirestore

class PatientInfoViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var dataButton: UIButton!
    @IBOutlet weak var graphButton: UIButton!
    @IBOutlet weak var footerView: UIView!
    
    let collectionRef = Firestore.firestore().collection("Users")
    private var temperatureSamples: Array<HKSample> = []
    var name:String!
    var temperatures:[Int] = []
    private var kit: HKHealthStore! {
        return HKHealthStore()
    }
    
    private let queryType = HKQuantityType.quantityType(forIdentifier: .bodyTemperature)!
    private let querySample = HKSampleType.quantityType(forIdentifier: .bodyTemperature)!
    

    let types = ["SpO2","BPM","Temperature"]
    var numbers = [0,0,0]
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        ref.child("HeartRate").observe(DataEventType.value, with: { (snapshot) in
            self.numbers[1] = snapshot.value! as! Int
            self.collectionRef.document(self.name).collection("HeartRate").addDocument(data: ["HeartRate":snapshot.value!])
            self.table.reloadData()
              })
        
        ref.child("SpO2").observe(DataEventType.value, with: { (snapshot) in
            self.numbers[0] = snapshot.value! as! Int
            self.collectionRef.document(self.name).collection("SpO2").addDocument(data: ["SpO2":snapshot.value!])
            self.table.reloadData()
              })
        
        requestAuthorization()
    }
    
    @IBAction func tapRefreshButton(_ sender: Any) {
        getTemperatureData()
        table.reloadData()
    }
    
    
    func requestAuthorization() {
        if HKHealthStore.isHealthDataAvailable(){
            //  Write Authorize
            let queryTypeArray: Set<HKSampleType> = [queryType]
            //  Read Authorize
            let querySampleArray: Set<HKObjectType> = [querySample]
            
            kit.requestAuthorization(toShare: queryTypeArray, read: querySampleArray) { (success, error) in
                if success{
                    self.getTemperatureData()
                }
            }
        }
    }

    
    func getTemperatureData(){

        //Create query object
        let temperaturesamplequery = HKSampleQuery (sampleType : querySample, // type object to get
                                                    predicate: nil, // time parameter. If it is empty, time is not limited
                                                    limit: 100, // get quantity
                                                    sortDescriptors: [NSSortDescriptor (key: HKSampleSortIdentifierStartDate, ascending: false)]) // the sort method of the acquired data
        { (query, results, error) in
            ///After getting the result, the results are returned [hksample]?
            if let samples = results {
                //Insert into tableview one by one
                for sample in samples {
                    DispatchQueue.main.async {
                        self.temperatureSamples.append(sample)
                        let temperature = (sample as! HKQuantitySample).quantity.doubleValue(for: .degreeCelsius())
                        self.temperatures.append(Int(temperature))
                        if self.temperatureSamples.count == samples.count {
                            self.numbers[2] = Int(self.temperatures.last ?? 0)
                            self.table.reloadData()
                        }
                    }
                }
            }
        }

        //Perform query operation
        kit.execute(temperaturesamplequery)
    }
    
    func getTemperatureAndDate(sample: HKSample) -> (Date, Double) {
        
        let quantitySample = sample as! HKQuantitySample
        let date = sample.startDate
        let temperature = quantitySample.quantity.doubleValue(for: .degreeCelsius())
        return (date, temperature)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAverageTableViewController" {
            let vc = segue.destination as! AverageTableViewController
            vc.name = name
        }else {
            let vc = segue.destination as! ChartViewController
//            vc.temperatures = temperatures
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
        cell.setUp(type: types[indexPath.row], number: numbers[indexPath.row])
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

