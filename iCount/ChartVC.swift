//
//  ChartVC.swift
//  iCount
//
//  Created by Sadie Flick on 5/30/18.
//  Copyright © 2018 Sadie Flick. All rights reserved.
//

import UIKit
import Charts

protocol GetChartData: class {
//    func getChartData(with dates: [Date], values: [Int32])
    var dates: [Date] {get set}
    var counts: [Int32] {get set}
}

class ChartVC: UIViewController, GetChartData {
    
    var rawData: NSSet?
    
    var rawDates = [Date]()
    var rawCounts = [Int32]()
    
    var dates = [Date]()
    var counts = [Int32]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let rawDataArr: [CountData] = rawData?.allObjects as! [CountData]
        
        let rawSorted = rawDataArr.sorted(by: { $0.date! < $1.date! })
        print("raw sorted array: ", rawSorted)

//        print("raw data: ", rawData)
        
        for case let countData as CountData in rawSorted {
            dates.append(countData.date!)
//            rawDates.append(countData.date!)
        }
//        print("date array: ", dates)
        
        for case let countData as CountData in rawSorted {
            counts.append(countData.count)
//            rawCounts.append(countData.count)
        }
        
        
//        print("count array: ", counts)
        cubicChart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func cubicChart() {
        let cubicChart = CubicChart(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height))
            cubicChart.delegate = self
        self.view.addSubview(cubicChart)
    }

}

// Chart formatter to config xaxis

public class ChartFormatter: NSObject, IAxisValueFormatter {
    
    var dates = [Date]()
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        // Convert date
        let date = dates[Int(value)]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        let dateText = dateFormatter.string(from: (date))
        return dateText
    }
    
    public func setValues(values: [Date]) {
        self.dates = values
    }
    
}

public class YAxisFormatter: NSObject, IAxisValueFormatter {
    
    var counts = [Int32]()
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        let count = counts[Int(value)]
        return count.description
    }
    
    public func setValues(values: [Int32]) {
        self.counts = values
    }
    
}
