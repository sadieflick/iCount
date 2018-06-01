//
//  CubicChart.swift
//  iCount
//
//  Created by Sadie Flick on 5/30/18.
//  Copyright © 2018 Sadie Flick. All rights reserved.
//

import UIKit
import Charts

class CubicChart: UIView {

    // Cubic line graph properties
    let lineChartView = LineChartView()
    var lineDataEntry: [ChartDataEntry] = []
    
    // Chart Data
    var dates = [Date]()
    var counts = [Int32]()
    
    var delegate: GetChartData! {
        didSet {
            populateData()
            cubicLineChartSetup()
        }
    }
    
    func populateData() {
        dates = delegate.dates
        counts = delegate.counts
    }
    
    func lineChartSetup() {
        // Line chart config
        self.backgroundColor = UIColor.white
        self.addSubview(lineChartView)
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        lineChartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        lineChartView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        lineChartView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        // Line Chart Animation
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInSine)
        
        //Line chart population
        setCubicLineChart(dataPoints: dates, values: counts)
    }
    
    func cubicLineChartSetup() {
        
        // Line chart config
        self.backgroundColor = UIColor.white
        self.addSubview(lineChartView)
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        lineChartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        lineChartView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        lineChartView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        // Line Chart Animation
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInSine)
        
        //Line chart population
        setCubicLineChart(dataPoints: dates, values: counts)
    }
    
    func setCubicLineChart(dataPoints: [Date], values: [Int32]) {
        
        // No data Setup
        lineChartView.noDataTextColor = UIColor.white
        lineChartView.noDataText = "No data for the chart."
        lineChartView.backgroundColor = UIColor(red: 0.15, green: 0.33, blue: 0.62, alpha: 1.0)
        
        //Data point setup & color config
        for i in 0..<dataPoints.count {
            let dataPoint = ChartDataEntry(x: Double(i), y: Double(values[i]))
            lineDataEntry.append(dataPoint)
        }
        
        let chartDataSet = LineChartDataSet(values: lineDataEntry, label: "Count")
        let chartData = LineChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(true) // false if don't want values above bar
        chartDataSet.colors = [UIColor.cyan]
        chartDataSet.setCircleColor(UIColor.cyan)
        chartDataSet.circleHoleColor = UIColor.cyan
        chartDataSet.circleRadius = 4.0
        chartDataSet.mode = .cubicBezier
        chartDataSet.cubicIntensity = 0.2
        chartDataSet.drawCirclesEnabled = false
        
        chartDataSet.valueFont = UIFont(name: "Helvetica", size: 12.0)!
        
        //Gradient fill
        let gradientColors = [UIColor.cyan.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations: [CGFloat] = [1.0, 0.0] // positioning of gradient
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) else { print("gradient error"); return }
        chartDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        chartDataSet.drawFilledEnabled = true
        
        // Axes setup
        // X Axis format prep
        let formatter: ChartFormatter = ChartFormatter()
        formatter.setValues(values: dataPoints)
        let xaxis: XAxis = XAxis()
        xaxis.valueFormatter = formatter
        
        // Y axis format prep
//        let yFormatter: YAxisFormatter = YAxisFormatter()
//        yFormatter.setValues(values: values)
//        let yaxis: YAxis = YAxis()
//        yaxis.valueFormatter = yFormatter
        
        // X Axis data format
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawGridLinesEnabled = false // true if want X-Axis grid lines
        lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
        
        // plot points data format

        
        lineChartView.chartDescription?.enabled = false
        lineChartView.legend.enabled = true
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false // true if want y-axis grid lines
        lineChartView.leftAxis.drawLabelsEnabled = true
        lineChartView.data = chartData
        
        
    }

}
