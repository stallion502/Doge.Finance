//
//  LineChartView.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/8/21.
//

import UIKit
import Charts

class BaseLineChart: LineChartView {

    private var dates: [Date] = []
    private var trades: [DexTrade] = []
    private var initialAxisMax: Double = 0
    private var initialAxisMin: Double = 0

    override func awakeFromNib() {
        noDataText = ""
        dragEnabled = true
        setScaleEnabled(true)
        pinchZoomEnabled = true
        legend.enabled = false
        noDataTextColor = .black
        rightAxis.labelTextColor = UIColor.white.withAlphaComponent(0.75)
        rightAxis.labelFont = .systemFont(ofSize: 9, weight: .medium)
        rightAxis.spaceTop = 0.3
        rightAxis.spaceBottom = 0.3
        rightAxis.axisMinimum = 0

        leftAxis.enabled = false

        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 9, weight: .medium)
        xAxis.labelTextColor = UIColor.white.withAlphaComponent(0.75)

        minOffset = 0
        autoScaleMinMaxEnabled = true
        rightAxis.drawZeroLineEnabled = false
        drawGridBackgroundEnabled = false
        legend.drawInside = false

    }

    func setup(with trades: [DexTrade], dates: [Date]) {
        self.trades = trades

        let entries = trades.enumerated().compactMap { valueAndI -> ChartDataEntry in
            return .init(x: Double(valueAndI.offset), y: valueAndI.element.closePrice?.toDouble() ?? 0)
        }
        let dates: [Date] = trades.map {
            return DateFormatterBuilder.dateFormatter(.iso8601Z).date(from: $0.timeInterval?.minute ?? "") ?? .init()
        }
        self.dates = dates
        let set1 = LineChartDataSet(entries: entries, label: "")
        set1.drawIconsEnabled = false
        set1.setColor(UIColor.hex("E7B227"))

        setup(set1)
        minOffset = 12
        xAxis.valueFormatter = EmptyFormatter()
        rightAxis.valueFormatter = EmptyFormatter()
        xAxis.spaceMin = 25

        set1.axisDependency = .right
        set1.drawIconsEnabled = false
        set1.formLineWidth = 2.5
        set1.highlightLineWidth = 2
        set1.highlightColor = UIColor.white.withAlphaComponent(0.75)
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        self.data = data
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawGridLinesEnabled = false // TODO
        rightAxis.drawZeroLineEnabled = false
            rightAxis.drawLimitLinesBehindDataEnabled = false
        if trades.count < 30 {
            setVisibleXRange(minXRange: 20, maxXRange: 30)
        } else {
            setVisibleXRange(minXRange: 30, maxXRange: Double(entries.count))
        }
        xAxis.yOffset = 70
        xAxis.drawGridLinesEnabled = false // TODO
        xAxis.gridColor = UIColor.white.withAlphaComponent(0.15)
        rightAxis.drawGridLinesEnabled = false // TODO
        rightAxis.gridColor = UIColor.white.withAlphaComponent(0.15)
        xAxis.axisLineColor = UIColor.white.withAlphaComponent(0.15)
        pinchZoomEnabled = false
        doubleTapToZoomEnabled = false
        rightAxis.maxWidth = 100
        rightAxis.minWidth = 100
        scaleYEnabled = false
        initialAxisMax = rightAxis.axisMaximum
        // Вычислять
        zoom(scaleX: 10, scaleY: 1, xValue: 0, yValue: 0, axis: .right)
        if !entries.isEmpty {
            moveViewToX(Double(entries.count - 1))
            notifyDataSetChanged()
        }
    }


    private func setup(_ dataSet: LineChartDataSet) {
        dataSet.lineDashLengths = nil
        dataSet.mode = .cubicBezier
        dataSet.highlightLineDashLengths = nil
        dataSet.circleRadius = 0
        dataSet.drawValuesEnabled = false
        dataSet.drawCircleHoleEnabled = false
        dataSet.formLineDashLengths = nil
        dataSet.formLineWidth = 0
        dataSet.drawCircleHoleEnabled = false
        dataSet.formSize = 15
    }

    func setup(filled: Bool) {
        if let set1 = data?.dataSets.first as? LineChartDataSet {
            let gradientColors = [UIColor.background.withAlphaComponent(0.5).cgColor, UIColor.hex("E7B227").cgColor]
            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
            set1.fillAlpha = filled ? 1 : 0
            set1.fill = Fill.fillWithLinearGradient(gradient, angle: 90)
            set1.drawFilledEnabled = filled
        }
    }

    func adjustMaxMin() {
        let x1 = Int(lowestVisibleX)
        let x2 = Int(highestVisibleX)
        let elements = trades 
        guard x1 >= 0 && x2 <= elements.count else {
            return
        }
        let max = elements[(x1..<x2)]
            .sorted(by: { $0.highestPrice > $1.highestPrice })
            .first?.highestPrice ?? 0

        let min = elements[(x1..<x2)]
            .sorted(by: { $0.lowestPrice < $1.lowestPrice })
            .first?.lowestPrice ?? 0

        if min != 0 && max != 0 && max != rightAxis.axisMaximum {
            rightAxis.axisMaximum = max
        }
        if min != 0 && max != 0 && min != rightAxis.axisMinimum {
            rightAxis.axisMinimum = min
        }
    }
}


class EmptyFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return ""
    }
}



