//
//  DashedView.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/3/21.
//

import UIKit

class DashedView: UIView {

    var sideXOffset: CGFloat = 84
    var bottomOffset: CGFloat = 88

    var isPortrait: Bool = false

    var centerPoint: CGPoint = .zero {
        didSet {
            shapeXLayer.removeFromSuperlayer()
            shapeYLayer.removeFromSuperlayer()
            guard centerPoint != .zero else {
                rightAxisView.isHidden = true
                highlitedLongGestureYView.isHidden = true
                return
            }
            rightAxisView.isHidden = false
            highlitedLongGestureYView.isHidden = false
            drawVerticalLine()
            drawHorizontalLine()
            rightAxisViewYConstraint?.constant = correctedPoint.y - highlitedLongGestureYView.frame.height / 2
            highlitedLongCenterXConstraint?.constant = xAxisLongCenterPoint
            highlitedCenterXConstraint?.constant = xAxisDefaultCenterPoint
        }
    }

    var currentHighlitedPoint: CGPoint = .zero

    var correctedPoint: CGPoint {
        if isPortrait {
            return centerPoint
        } else {
            return CGPoint(
                x: min(centerPoint.x, frame.maxX - sideXOffset),
                y: min(centerPoint.y, frame.maxY - bottomOffset)
            )
        }
    }

    var xAxisLongCenterPoint: CGFloat {
        let originalPoint = correctedPoint.x - highlitedLongGestureYView.frame.width / 2
        let crossPoint = currentHighlitedPoint.x - highlitedYView.frame.width / 2

        guard !highlitedYView.isHidden else {
            return originalPoint
        }
        if originalPoint <= crossPoint {
            if originalPoint + highlitedLongGestureYView.frame.width > crossPoint {
                return correctedPoint.x - highlitedLongGestureYView.frame.width
            } else {
                return originalPoint
            }
        }
        else if originalPoint > crossPoint && correctedPoint != .zero {
            if originalPoint - highlitedLongGestureYView.frame.width < crossPoint {
                return correctedPoint.x
            } else {
                return originalPoint
            }
        }
        else {
            return originalPoint
        }
    }

    var xAxisDefaultCenterPoint: CGFloat {
        let originalPoint = currentHighlitedPoint.x - highlitedYView.frame.width / 2
        let crossPoint = correctedPoint.x - highlitedLongGestureYView.frame.width / 2

        guard !highlitedLongGestureYView.isHidden else {
            return originalPoint
        }
        if originalPoint >= crossPoint {
            if originalPoint - highlitedYView.frame.width < crossPoint {
                return currentHighlitedPoint.x
            } else {
                return originalPoint
            }
        } else if originalPoint < crossPoint && correctedPoint != .zero {
            if originalPoint + highlitedLongGestureYView.frame.width > crossPoint {
                return currentHighlitedPoint.x - highlitedYView.frame.width
            } else {
                return originalPoint
            }
        } else {
            return originalPoint
        }
    }

    func hightliteValueLongPress(isGreen: Bool, date: String, price: String) {
        highlitedLongGestureYView.titleLabel.text = date
        rightAxisView.titleLabel.text = price
    }

    func hightliteYValue(isGreen: Bool, date: String, price: String, point: CGPoint) {
        guard point != .zero else {
            highlitedYView.isHidden = true
            return
        }
        highlitedYView.titleLabel.text = date
        highlitedYView.setNeedsDisplay()
        highlitedYView.layoutIfNeeded()
        currentHighlitedPoint = point
        highlitedCenterXConstraint?.constant = xAxisDefaultCenterPoint
        highlitedYView.isHidden = false
    }

    func dehightliteYValue() {
        highlitedYView.isHidden = true
    }

    private let shapeXLayer = CAShapeLayer()
    private let shapeYLayer = CAShapeLayer()

    private var highlitedLongGestureYView = TitleView()

    var highlitedYView = TitleView()

    private var rightAxisView = TitleView()

    private var highlitedLongCenterXConstraint: NSLayoutConstraint?
    private var highlitedCenterXConstraint: NSLayoutConstraint?
    private var rightAxisViewYConstraint: NSLayoutConstraint?

    override func awakeFromNib() {
        clipsToBounds = true
        setupUI()
    }

    private func setupUI() {
        //
        highlitedYView.isHidden = true
        addSubview(highlitedYView)
        highlitedYView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -56).isActive = true

        highlitedCenterXConstraint = highlitedYView.leadingAnchor.constraint(equalTo: leadingAnchor)
        highlitedCenterXConstraint?.isActive = true

        //
        highlitedLongGestureYView.isHidden = true
        addSubview(highlitedLongGestureYView)
        highlitedLongGestureYView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -56).isActive = true
        highlitedLongCenterXConstraint = highlitedLongGestureYView.leadingAnchor.constraint(equalTo: leadingAnchor)
        highlitedLongCenterXConstraint?.isActive = true
        //

        rightAxisView.titleLabel.font = .systemFont(ofSize: 9, weight: .medium)
        rightAxisView.isHidden = true
        addSubview(rightAxisView)
        rightAxisView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true

        rightAxisViewYConstraint = rightAxisView.topAnchor.constraint(equalTo: topAnchor)
        rightAxisViewYConstraint?.isActive = true

    }

    func drawHorizontalLine() {
        shapeYLayer.strokeColor = UIColor.lightGray.cgColor
        shapeYLayer.lineWidth = 1
        shapeYLayer.lineDashPattern = [7, 3]
        let path = CGMutablePath()
        path.addLines(
            between: [CGPoint(x: correctedPoint.x, y: 0), CGPoint(x: correctedPoint.x, y: frame.maxY - bottomOffset)]
        )
        shapeYLayer.path = path
        layer.insertSublayer(shapeYLayer, at: 0)
    }

    func drawVerticalLine() {
        shapeXLayer.strokeColor = UIColor.lightGray.cgColor
        shapeXLayer.lineWidth = 1
        shapeXLayer.lineDashPattern = [7, 3]
        let path = CGMutablePath()
        path.addLines(
            between: [CGPoint(x: 0, y: correctedPoint.y), CGPoint(x: frame.maxX - sideXOffset, y: correctedPoint.y)]
        )
        shapeXLayer.path = path
        layer.insertSublayer(shapeXLayer, at: 0)
    }
}
