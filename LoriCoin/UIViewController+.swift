//
//  UIViewController+.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 7/29/21.
//

import Foundation
import UIKit

extension UIViewController {

    public static func setRootController(_ vcToPresent: UIViewController) {
        let snapshot: UIView = (UIApplication.shared.keyWindow!.snapshotView(afterScreenUpdates: true))!
        snapshot.layer.cornerRadius = 8
        vcToPresent.view.addSubview(snapshot)

        UIApplication.shared.keyWindow?.rootViewController = vcToPresent
        vcToPresent.view.layer.cornerRadius = 8
        vcToPresent.view.layer.masksToBounds = true
        UIView.animate(withDuration: 0.35,
                       delay: 0.0,
                       options: .curveEaseIn,
                       animations: {
                        UIView.animate(withDuration: 0.3, animations: {
                            vcToPresent.view.layer.transform = CATransform3DMakeScale(0.9, 0.9, 0.9)
                        }) { (success) in
                            UIView.animate(withDuration: 0.5) {
                                snapshot.transform = CGAffineTransform(
                                    translationX: UIScreen.main.bounds.width,
                                    y: 0)
                            }
                            UIView.animate(withDuration: 0.3, delay: 0.5, animations: {
                                vcToPresent.view.transform = .identity
                            }, completion: { success in
                                        vcToPresent.view.layer.cornerRadius = 0
                                        vcToPresent.view.layer.masksToBounds = false
                                        snapshot.removeFromSuperview()
                            })
                        }
        }, completion: { _ in
        })
    }
}
