//
//  UIView+.swift
//  AkBarsRieltor
//
//  Created by Pozdnyshev Maksim on 17.06.2020.
//  Copyright © 2020 Pozdnyshev Maksim. All rights reserved.
//

import UIKit

struct Shadow {
    public let size: CGSize
    public let opacity: CGFloat
    public let radius: CGFloat
    public let color: UIColor

    public init(size: CGSize, opacity: CGFloat, radius: CGFloat, color: UIColor = .darkGray) {
        self.size = size
        self.opacity = opacity
        self.radius = radius
        self.color = color
    }
}

extension UIView {

    func pinToSuperView() {

        guard let superView = self.superview else { return }

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([

            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            topAnchor.constraint(equalTo: superView.topAnchor),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor)

            ])
    }

    class func loadFromNib<T: UIView>() -> T? {

        return Bundle.main.loadNibNamed(String(describing: T.self), owner: self, options: nil)?.first as? T
    }

    func addShadow(opacity: CGFloat = 0.33, whiteBackground: Bool = false) {
        if whiteBackground {
            setShadow(size: CGSize(width: 0, height: 4), opacity: 0.1, radius: 5)
        } else {
            setShadow(size: CGSize(width: 0, height: 6), opacity: opacity, radius: 6, color: .black)
        }
    }

    func changeShadowBy(highlighted isHighlighted: Bool, opacity: Float = 0.33, whiteBackground: Bool = false) {
        if whiteBackground {
            layer.shadowOpacity = isHighlighted ? 0 : 0.1
        } else {
            layer.shadowOpacity = isHighlighted ? 0 : opacity
        }
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    /**
     Метод скругляет углы у текущей view

     - parameter corners: сет углов из CACornerMask
     - parameter radius: радиус скругления
     */
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        if #available(iOS 11, *) {
            layer.cornerRadius = radius
            layer.maskedCorners = corners
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners.rectCorner(), cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
            layer.masksToBounds = true
        }
    }


    func setShadow(size: CGSize, opacity: CGFloat, radius: CGFloat, color: UIColor = .black) {
        layer.shadowColor   = color.cgColor
        layer.shadowOffset  = size
        layer.shadowOpacity = Float(opacity)
        layer.shadowRadius  = radius
        layer.masksToBounds = false
    }

    func set(shadow: Shadow) {
        layer.shadowColor   = shadow.color.cgColor
        layer.shadowOffset  = shadow.size
        layer.shadowOpacity = Float(shadow.opacity)
        layer.shadowRadius  = shadow.radius
        layer.masksToBounds = false
    }

    convenience init(shadow: Shadow? = nil, cornerRadius : CGFloat = 0, background: UIColor? = nil ) {
        self.init()
        backgroundColor = background
        layer.cornerRadius = cornerRadius
        if let shadow = shadow {
            layer.shadowColor   = shadow.color.cgColor
            layer.shadowOffset  = shadow.size
            layer.shadowOpacity = Float(shadow.opacity)
            layer.shadowRadius  = shadow.radius
        }
        layer.masksToBounds = false
    }
}

extension CACornerMask {
    public func rectCorner() -> UIRectCorner {
        var cornerMask = UIRectCorner()
        if contains(.layerMinXMinYCorner) {
            cornerMask.insert(.topLeft)
        }
        if contains(.layerMaxXMinYCorner) {
            cornerMask.insert(.topRight)
        }
        if contains(.layerMinXMaxYCorner) {
            cornerMask.insert(.bottomLeft)
        }
        if contains(.layerMaxXMaxYCorner) {
            cornerMask.insert(.bottomRight)
        }
        return cornerMask
    }
}

extension CACornerMask {

    public static let all: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    public static let top: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    public static let left: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    public static let right: CACornerMask = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    public static let bottom: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
}


extension UIView {
    func startAnimation() {
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.withAlphaComponent(0.6).cgColor, UIColor.clear.cgColor]
            //TODOgradientLayer.backgroundColor = UIColor.lightGray
        gradientLayer.startPoint = CGPoint(x: 0.7, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.8)
        gradientLayer.frame = bounds
        layer.mask = gradientLayer

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = 1
        animation.fromValue = 0 //-frame.size.width
        animation.toValue = 1 //frame.size.width/2
        animation.repeatCount = .infinity
        animation.autoreverses = true
        gradientLayer.add(animation, forKey: "")
    }

    func stopAnimation() {
        layer.removeAllAnimations()
        layer.mask = nil
    }
}


extension UIView {
    /// Get nib by this class's name
    /// - Returns: Nib named the same as the cell's class
    class func nib() -> UINib {
        UINib(nibName: String(describing: self), bundle: Bundle(for: Self.self))
    }

    /// Reuse identifier by convention - name of the class itslef
    class var reuseID: String {
        String(describing: self)
    }
}
