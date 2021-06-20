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
    
    var temperatures:[Int]!
    var name:String!
    
    @IBOutlet weak var chartView: LineChartView!
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = name
        setChartView()
    }
    
    func setChartView() {
        chartView.delegate = self
        chartView.backgroundColor = .black
        chartView.chartDescription.enabled = false
        chartView.rightAxis.enabled = false
        chartView.animate(xAxisDuration: 5)
        setDataCount()
    }
    
    func setDataCount() {
        
        let c1 = ChartDataEntry(x: Double(1), y: 1, icon: .none)
        let c2 = ChartDataEntry(x: Double(2), y: 2, icon: .none)
        let c3 = ChartDataEntry(x: Double(3), y: 3, icon: .none)
        let c4 = ChartDataEntry(x: Double(4), y: 1, icon: .none)
        let c5 = ChartDataEntry(x: Double(5), y: 2, icon: .none)
        let c6 = ChartDataEntry(x: Double(6), y: 3, icon: .none)
        let c7 = ChartDataEntry(x: Double(7), y: 1, icon: .none)
        let c8 = ChartDataEntry(x: Double(8), y: 2, icon: .none)
        let c9 = ChartDataEntry(x: Double(9), y: 3, icon: .none)
        let c10 = ChartDataEntry(x: Double(10), y: 1, icon: .none)
        let c11 = ChartDataEntry(x: Double(11), y: 2, icon: .none)
        let c12 = ChartDataEntry(x: Double(12), y: 3, icon: .none)
        
        let set1 = LineChartDataSet(entries: [c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12], label: "SpO2")
        
        var temperatureEntries = [ChartDataEntry]()
        temperatures.enumerated().forEach {
            temperatureEntries.append(ChartDataEntry(x: Double($0.offset), y: Double($0.element)))
        }
        
        let set2 = LineChartDataSet(entries: temperatureEntries, label: "Temperature")
        
        let q1 = ChartDataEntry(x: Double(1), y: 50, icon: .none)
        let q2 = ChartDataEntry(x: Double(2), y: 40, icon: .none)
        let q3 = ChartDataEntry(x: Double(3), y: 60, icon: .none)
        let q4 = ChartDataEntry(x: Double(4), y: 50, icon: .none)
        let q5 = ChartDataEntry(x: Double(5), y: 40, icon: .none)
        let q6 = ChartDataEntry(x: Double(6), y: 60, icon: .none)
        let q7 = ChartDataEntry(x: Double(7), y: 50, icon: .none)
        let q8 = ChartDataEntry(x: Double(8), y: 40, icon: .none)
        let q9 = ChartDataEntry(x: Double(9), y: 60, icon: .none)
        let q10 = ChartDataEntry(x: Double(10), y: 50, icon: .none)
        let q11 = ChartDataEntry(x: Double(11), y: 40, icon: .none)
        let q12 = ChartDataEntry(x: Double(12), y: 60, icon: .none)
        
        let set3 = LineChartDataSet(entries: [q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12], label: "BPM")
        
        
        setup(set1)
        
        setup(set2)
        
        setup(set3)
        
        let data =  LineChartData(dataSets: [set1,set2,set3])
        
        chartView.data = data
        
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
