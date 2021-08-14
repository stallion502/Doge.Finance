////
////  CandleStickViewController.swift
////  PoocoinV2
////
////  Created by Pozdnyshev Maksim on 6/29/21.
////
//
//import Foundation
//
//import UIKit
//import SwiftCharts
//
//class CandleStickViewController: UIViewController {
//
//    fileprivate var chart: Chart? // arc
//
//    private let manager = ApolloManager()
//    private var ethereum: Ethereum?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        loadData()
//    }
//
//    private func loadData() {
//        manager.getTransactions { result in
//            switch result {
//            case .success(let eth):
//                self.ethereum = eth
//                self.updateChartData()
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//
//    private func updateChartData() {
//        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
//
//        var readFormatter = DateFormatter()
//        readFormatter.dateFormat = "dd.MM.yyyy"
//
//        var displayFormatter = DateFormatter()
//        displayFormatter.dateFormat = "MMM dd"
//        let date = {(str: String) -> Date in
//            return readFormatter.date(from: str)!
//        }
//
//        let calendar = Calendar.current
//
//        let dateWithComponents = {(day: Int, month: Int, year: Int) -> Date in
//            var components = DateComponents()
//            components.day = day
//            components.month = month
//            components.year = year
//            return calendar.date(from: components)!
//        }
//
//        func filler(_ date: Date) -> ChartAxisValueDate {
//            let filler = ChartAxisValueDate(date: date, formatter: displayFormatter)
//            filler.hidden = true
//            return filler
//        }
//
//        let chartPoints = ethereum?.ethereum?.dexTrades?.compactMap { value -> ChartPointCandleStick in
//            let date = DateFormatterBuilder.dateFormatter(.iso8601Z).date(from: value.timeInterval?.minute ?? "") ?? .init()
//            let val = increaseRecursivly(value: value.quotePrice)
//            let high = increaseRecursivly(value: value.maximumPrice)
//            let low = increaseRecursivly(value: value.minimumPrice)
//            let open = increaseRecursivly(value: Double(value.openPrice ?? "0"))
//            let close = increaseRecursivly(value: Double(value.closePrice ?? "0"))
//            
//            return ChartPointCandleStick(
//                date: date,
//                formatter: displayFormatter,
//                high: high,
//                low: low,
//                open: open,
//                close: close
//            )
//        } ?? []
//
//        func generateDateAxisValues(_ month: Int, year: Int) -> [ChartAxisValueDate] {
//            let date = dateWithComponents(1, month, year)
//            let calendar = Calendar.current
//            let monthDays = calendar.range(of: .day, in: .month, for: date)!
//
//            return monthDays.map {day in
//                let date = dateWithComponents(day, month, year)
//                let axisValue = ChartAxisValueDate(date: date, formatter: displayFormatter, labelSettings: labelSettings)
//                axisValue.hidden = !(day % 5 == 0)
//                return axisValue
//            }
//        }
//
//        let xValues = generateDateAxisValues(10, year: 2015)
//        let yValues = stride(from: 13, through: 14, by: 2).map {ChartAxisValueDouble(Double($0), labelSettings: labelSettings)}
//
//        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings))
//        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings.defaultVertical()))
//
//        let defaultChartFrame = ExamplesDefaults.chartFrame(view.bounds)
//        let infoViewHeight: CGFloat = 50
//        let chartFrame = CGRect(x: defaultChartFrame.origin.x, y: defaultChartFrame.origin.y + infoViewHeight, width: defaultChartFrame.width, height: defaultChartFrame.height - infoViewHeight)
//
//        let chartSettings = ExamplesDefaults.chartSettings
//
//        let coordsSpace = ChartCoordsSpaceRightBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
//        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
//
//        let viewGenerator = {(chartPointModel: ChartPointLayerModel<ChartPointCandleStick>, layer: ChartPointsViewsLayer<ChartPointCandleStick, ChartCandleStickView>, chart: Chart) -> ChartCandleStickView? in
//            let (chartPoint, screenLoc) = (chartPointModel.chartPoint, chartPointModel.screenLoc)
//
//            let x = screenLoc.x
//
//            let highScreenY = screenLoc.y
//            let lowScreenY = layer.modelLocToScreenLoc(x: Double(x), y: Double(chartPoint.low)).y
//            let openScreenY = layer.modelLocToScreenLoc(x: Double(x), y: Double(chartPoint.open)).y
//            let closeScreenY = layer.modelLocToScreenLoc(x: Double(x), y: Double(chartPoint.close)).y
//
//            let (rectTop, rectBottom, fillColor) = closeScreenY < openScreenY ? (closeScreenY, openScreenY, UIColor.white) : (openScreenY, closeScreenY, UIColor.black)
//            let v = ChartCandleStickView(lineX: screenLoc.x, width: 5, top: highScreenY, bottom: lowScreenY, innerRectTop: rectTop, innerRectBottom: rectBottom, fillColor: fillColor, strokeWidth: 0.5)
//            v.isUserInteractionEnabled = false
//            return v
//        }
//        let candleStickLayer = ChartPointsCandleStickViewsLayer<ChartPointCandleStick, ChartCandleStickView>(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, innerFrame: innerFrame, chartPoints: chartPoints, viewGenerator: viewGenerator)
//
//
//        let infoView = InfoWithIntroView(frame: CGRect(x: 10, y: 70, width: view.frame.size.width, height: infoViewHeight))
//        view.addSubview(infoView)
//
//        let trackerLayer = ChartPointsTrackerLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, chartPoints: chartPoints, locChangedFunc: {[weak candleStickLayer, weak infoView] screenLoc in
//            candleStickLayer?.highlightChartpointView(screenLoc: screenLoc)
//            if let chartPoint = candleStickLayer?.chartPointsForScreenLocX(screenLoc.x).first {
//                infoView?.showChartPoint(chartPoint)
//            } else {
//                infoView?.clear()
//            }
//        }, lineColor: UIColor.red, lineWidth: 0.6)
//
//
//        let settings = ChartGuideLinesLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
//        let guidelinesLayer = ChartGuideLinesLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
//
//        let dividersSettings =  ChartDividersLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth, start: 3, end: 0)
//        let dividersLayer = ChartDividersLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: dividersSettings)
//
//        let chart = Chart(
//            frame: chartFrame,
//            innerFrame: innerFrame,
//            settings: chartSettings,
//            layers: [
//                xAxisLayer,
//                yAxisLayer,
//                guidelinesLayer,
//                dividersLayer,
//                candleStickLayer,
////                trackerLayer
//            ]
//        )
//        chart.zoomPanSettings.gestureMode = .both
//        chart.zoomPanSettings.zoomEnabled = true
//        chart.zoomPanSettings.panEnabled = true
//
//        view.addSubview(chart.view)
//        chart.view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            chart.view.topAnchor.constraint(equalTo: view.topAnchor),
//            chart.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            chart.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            chart.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
//        self.chart = chart
//    }
//
//    func increaseRecursivly(value: Double?) -> Double {
////        return value ?? 0
//
//        if let value = value, value < 10 {
//            return increaseRecursivly(value: value * 10)
//        } else {
//            return value ?? 0
//        }
//    }
//}
//
//
//private class InfoView: UIView {
//
//    let statusView: UIView
//
//    let dateLabel: UILabel
//    let lowTextLabel: UILabel
//    let highTextLabel: UILabel
//    let openTextLabel: UILabel
//    let closeTextLabel: UILabel
//
//    let lowLabel: UILabel
//    let highLabel: UILabel
//    let openLabel: UILabel
//    let closeLabel: UILabel
//
//    override init(frame: CGRect) {
//
//        let itemHeight: CGFloat = 40
//        let y = (frame.height - itemHeight) / CGFloat(2)
//
//        statusView = UIView(frame: CGRect(x: 0, y: y, width: itemHeight, height: itemHeight))
//        statusView.layer.borderColor = UIColor.black.cgColor
//        statusView.layer.borderWidth = 1
//        statusView.layer.cornerRadius = 8
//
//        let font = ExamplesDefaults.labelFont
//
//        dateLabel = UILabel()
//        dateLabel.font = font
//
//        lowTextLabel = UILabel()
//        lowTextLabel.text = "Low:"
//        lowTextLabel.font = font
//        lowLabel = UILabel()
//        lowLabel.font = font
//
//        highTextLabel = UILabel()
//        highTextLabel.text = "High:"
//        highTextLabel.font = font
//        highLabel = UILabel()
//        highLabel.font = font
//
//        openTextLabel = UILabel()
//        openTextLabel.text = "Open:"
//        openTextLabel.font = font
//        openLabel = UILabel()
//        openLabel.font = font
//
//        closeTextLabel = UILabel()
//        closeTextLabel.text = "Close:"
//        closeTextLabel.font = font
//        closeLabel = UILabel()
//        closeLabel.font = font
//
//        super.init(frame: frame)
//
//        addSubview(statusView)
//        addSubview(dateLabel)
//        addSubview(lowTextLabel)
//        addSubview(lowLabel)
//        addSubview(highTextLabel)
//        addSubview(highLabel)
//        addSubview(openTextLabel)
//        addSubview(openLabel)
//        addSubview(closeTextLabel)
//        addSubview(closeLabel)
//    }
//
//    fileprivate override func didMoveToSuperview() {
//
//        let views = [statusView, dateLabel, highTextLabel, highLabel, lowTextLabel, lowLabel, openTextLabel, openLabel, closeTextLabel, closeLabel]
//        for v in views {
//            v.translatesAutoresizingMaskIntoConstraints = false
//        }
//
//        let namedViews = views.enumerated().map{index, view in
//            ("v\(index)", view)
//        }
//
//        var viewsDict = Dictionary<String, UIView>()
//        for namedView in namedViews {
//            viewsDict[namedView.0] = namedView.1
//        }
//
//        let circleDiameter: CGFloat = 15
//        let labelsSpace: CGFloat = 5
//
//        let hConstraintStr = namedViews[1..<namedViews.count].reduce("H:|[v0(\(circleDiameter))]") {str, tuple in
//            "\(str)-(\(labelsSpace))-[\(tuple.0)]"
//        }
//
//        let vConstraits = namedViews.flatMap {NSLayoutConstraint.constraints(withVisualFormat: "V:|-(18)-[\($0.0)(\(circleDiameter))]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDict)}
//
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: hConstraintStr, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDict)
//            + vConstraits)
//
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func showChartPoint(_ chartPoint: ChartPointCandleStick) {
//        let color = chartPoint.open > chartPoint.close ? UIColor.black : UIColor.white
//        statusView.backgroundColor = color
//        dateLabel.text = chartPoint.x.labels.first?.text ?? ""
//        lowLabel.text = "\(chartPoint.low)"
//        highLabel.text = "\(chartPoint.high)"
//        openLabel.text = "\(chartPoint.open)"
//        closeLabel.text = "\(chartPoint.close)"
//    }
//
//    func clear() {
//        statusView.backgroundColor = UIColor.clear
//    }
//}
//
//
//private class InfoWithIntroView: UIView {
//
//    var introView: UIView!
//    var infoView: InfoView!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    fileprivate override func didMoveToSuperview() {
//        let label = UILabel(frame: CGRect(x: 0, y: bounds.origin.y, width: bounds.width, height: bounds.height))
//        label.text = "Drag the line to see chartpoint data"
//        label.font = ExamplesDefaults.labelFont
//        label.backgroundColor = UIColor.white
//        introView = label
//
//        infoView = InfoView(frame: bounds)
//
//        addSubview(infoView)
//        addSubview(introView)
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    fileprivate func animateIntroAlpha(_ alpha: CGFloat) {
//        UIView.animate(withDuration: 0.1, animations: {
//            self.introView.alpha = alpha
//        })
//    }
//
//    func showChartPoint(_ chartPoint: ChartPointCandleStick) {
//        animateIntroAlpha(0)
//        infoView.showChartPoint(chartPoint)
//    }
//
//    func clear() {
//        animateIntroAlpha(1)
//        infoView.clear()
//    }
//}
//
