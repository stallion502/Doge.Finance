//
//  BarChartView.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 6/29/21.
//

import UIKit
import Charts

final class ValueBarChartView: BarChartView {

    private var values: [Double] = []

    override func awakeFromNib() {
        leftAxis.drawLabelsEnabled = false
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawGridLinesEnabled = false
        drawGridBackgroundEnabled = false
        rightAxis.drawGridLinesBehindDataEnabled = false
        rightAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.drawGridLinesBehindDataEnabled = false
        extraRightOffset = 100
        minOffset = 8
        xAxis.spaceMin = 25
        xAxis.granularity = 1.0
        xAxis.granularityEnabled = true
        xAxis.enabled = false
        isUserInteractionEnabled = false
        scaleYEnabled = false
        pinchZoomEnabled = false
        doubleTapToZoomEnabled = false
    }

    func setChart(dataPoints: [String], values: [(isUp: Bool, Double)]) {
        let formatter = BarChartFormatter()
        formatter.setValues(values: dataPoints)
        let xaxis:XAxis = XAxis()


        noDataText = ""
        var dataEntries: [BarChartDataEntry] = []
        self.values = values.map { $0.1 }
        for i in 0..<dataPoints.count
        {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i].1)
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        chartDataSet.colors = values.map { $0.isUp ? UIColor.mainGreen.withAlphaComponent(0.25) : UIColor.mainRed.withAlphaComponent(0.25) }
        
        let chartData = BarChartData(dataSet: chartDataSet)
        xaxis.valueFormatter = formatter
        xAxis.valueFormatter = xaxis.valueFormatter
        legend.enabled = false
        rightAxis.enabled = false
        scaleYEnabled = true
        scaleXEnabled = true
        chartData.setDrawValues(false)

        data = chartData
        if values.count < 30 {
            setVisibleXRange(minXRange: 20, maxXRange: 30)
        } else {
            setVisibleXRange(minXRange: 30, maxXRange: Double(values.count))
        }
        zoom(scaleX: 10, scaleY: 1, xValue: 0, yValue: 0, axis: .right)
    }

    func adjustMaxMin() {
        let x1 = Int(lowestVisibleX)
        let x2 = Int(highestVisibleX)

        guard x1 >= 0 && x2 <= values.count && x1 < x2 else {
            return
        }
        let max = values[(x1..<x2)]
            .sorted(by: { $0 > $1 })
            .first.value
        
        let min = values[(x1..<x2)]
            .sorted(by: { $0 < $1 })
            .first.value
        if min != 0 && max != 0 && max != rightAxis.axisMaximum {
            leftAxis.axisMaximum = max
        }
        if min != 0 && max != 0 && min != rightAxis.axisMinimum {
            leftAxis.axisMinimum = min
        }
    }
}

public class BarChartFormatter: NSObject, IAxisValueFormatter
{
    var names = [String]()

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        return ""
    }

    public func setValues(values: [String])
    {
        self.names = values
    }
}
