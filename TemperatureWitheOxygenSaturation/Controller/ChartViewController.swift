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
    
    var name:String!
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var chartView: LineChartView!
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //          self.title = name

        setChartView()
        
        
    }
    
    func setChartView() {
        chartView.delegate = self
        chartView.backgroundColor = .black
        chartView.chartDescription.enabled = false
        chartView.rightAxis.enabled = false
        chartView.animate(xAxisDuration: 2.5)
        setDataCount()
    }
    
    func setDataCount() {
        
        let c1 = ChartDataEntry(x: Double(3), y: 1, icon: .none)
        let c2 = ChartDataEntry(x: Double(5), y: 2, icon: .none)
        let c3 = ChartDataEntry(x: Double(7), y: 3, icon: .none)
        
        let set1 = LineChartDataSet(entries: [c1,c2,c3], label: "SpO2")
        
        let d1 = ChartDataEntry(x: Double(3), y: 10, icon: .none)
        let d2 = ChartDataEntry(x: Double(5), y: 20, icon: .none)
        let d3 = ChartDataEntry(x: Double(7), y: 30, icon: .none)
        
        let set2 = LineChartDataSet(entries: [d1,d2,d3], label: "Temperature")
        
        let q1 = ChartDataEntry(x: Double(3), y: 50, icon: .none)
        let q2 = ChartDataEntry(x: Double(5), y: 30, icon: .none)
        let q3 = ChartDataEntry(x: Double(7), y: 70, icon: .none)
        
        let set3 = LineChartDataSet(entries: [q1,q2,q3], label: "BPM")
        
        
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
