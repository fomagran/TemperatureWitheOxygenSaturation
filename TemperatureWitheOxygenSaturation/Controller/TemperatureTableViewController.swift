//
//  ViewController.swift
//  TemperatureWitheOxygenSaturation
//
//  Created by Fomagran on 2020/11/11.
//

import UIKit
import HealthKit

///Get body temperature data in health
class TemperatureTableViewController: UITableViewController {
        
    //Store the queried data
    private var temperatureSamples: Array<HKSample> = []
    
    
    private var kit: HKHealthStore! {
        return HKHealthStore()
    }
    
    private let queryType = HKQuantityType.quantityType(forIdentifier: .bodyTemperature)!
    private let querySample = HKSampleType.quantityType(forIdentifier: .bodyTemperature)!
    
    
    @IBAction func refreshData(_ sender: Any) {
        temperatureSamples = []
        requestAuthorization()
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAuthorization()
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
        
        /*
        //Time query criteria object
        let calendar = Calendar.current
        let todayStart =  calendar.date(from: calendar.dateComponents([.year,.month,.day], from: Date()))
        let dayPredicate = HKQuery.predicateForSamples(withStart: todayStart,
                                                       end: Date(timeInterval: 24*60*60,since: todayStart!),
                                                       options: HKQueryOptions.strictStartDate) */

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
                        self.tableView.insertRows(at: [IndexPath(row: self.temperatureSamples.firstIndex(of: sample)!, section:0)],
                                                  with: .right   )
                    }
                }
            }
        }

        //Perform query operation
        kit.execute(temperaturesamplequery)
    }
    
    
    ///Custom method: input hksample output date and temperature
    func getTemperatureAndDate(sample: HKSample) -> (Date, Double) {
        
        let quantitySample = sample as! HKQuantitySample
        let date = sample.startDate
        let temperature = quantitySample.quantity.doubleValue(for: .degreeCelsius())
        return (date, temperature)
        
    }
        
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temperatureSamples.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TemperatureCell", for: indexPath) as! TemperatureCell
        
        let reverseData = Array(temperatureSamples.reversed())
        let (date, temperature) = getTemperatureAndDate(sample: reverseData[indexPath.row])
        cell.tempartureLabel.text = String("온도 : \(temperature)".prefix(9)) + String("℃")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "ko_KR")
        cell.dateLabel.text = "날짜 :\(dateFormatter.string(from: date))"
        return cell
    }
    
}


