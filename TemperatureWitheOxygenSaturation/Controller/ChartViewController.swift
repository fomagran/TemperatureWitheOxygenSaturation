//
//  ChartViewController.swift
//  TemperatureWitheOxygenSaturation
//
//  Created by Fomagran on 2021/05/25.
//

import UIKit
import Charts
import FirebaseFirestore

class ChartViewController: UIViewController {
    
    //MARK:- IBOutlets
    
    var collectionRef = Firestore.firestore().collection("Users")
    var temperatures:[Int] = [100,120,110,90,80,100,200,80,90,100]
    var bpms:[Int] = []
    var spo2s:[Int] = []
    var name:String!
    
    @IBOutlet weak var chartView: LineChartView!
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = name
        getHeartRate()
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
                    self.setChartView()
                }
            }
        }
    }
    
    func setChartView() {
        chartView.delegate = self
        chartView.backgroundColor = .black
        chartView.chartDescription.enabled = false
        chartView.rightAxis.enabled = false
        chartView.animate(xAxisDuration: 5)
        chartView.animate(yAxisDuration: 5)
        setDataCount()
    }
    
    func setDataCount() {
        
        let spO2Entries = spo2s.enumerated().filter{$0.offset < 10}.map{ChartDataEntry(x: Double($0.offset), y: Double($0.element),icon: .none)}
        let tempEntries = temperatures.enumerated().filter{$0.offset < 10}.map{ChartDataEntry(x: Double($0.offset), y: Double($0.element),icon: .none)}
        let bpmEntries = bpms.enumerated().filter{$0.offset < 10}.map{ChartDataEntry(x: Double($0.offset), y: Double($0.element),icon: .none)}
       
        let set1 = LineChartDataSet(entries: spO2Entries, label: "SpO2")
        let set2 = LineChartDataSet(entries: tempEntries, label: "Temperature")
        let set3 = LineChartDataSet(entries: bpmEntries, label: "BPM")
        
        setup(set1)
        setup(set2)
        setup(set3)
        
        let data =  LineChartData(dataSets: [set1,set2,set3])
        self.chartView.data = data
    }
    
    private func setup(_ dataSet: LineChartDataSet) {
        
        if dataSet.label == "SpO2" {
            dataSet.setColor(.red)
        }else if dataSet.label == "Temperature" {
            dataSet.setColor(.blue)
        }else if dataSet.label == "BPM" {
            dataSet.setColor(.green)
        }
        
        dataSet.valueTextColor = .white
        dataSet.setCircleColor(.black)
        dataSet.lineWidth = 1
        dataSet.circleRadius = 3
    }
    
}

extension ChartViewController:ChartViewDelegate {
    
}
