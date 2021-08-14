//
//  SuccessView.swift
//  LFX
//
//

import Foundation

import UIKit
import Lottie
import SnapKit

enum LottieAnimation: String {
    case favorites = "favorites"
    case search
}

struct SuccessModel {
    let animation: LottieAnimation
    let title: String
    let subtitle: String?
    let durationTime: Double
    let loopMode: LottieLoopMode = .autoReverse
}

extension SuccessModel {
    static let favorites = SuccessModel(animation: .favorites, title: "No content yet", subtitle: "Find tokens and add them to favorites", durationTime: 5)
}

class SuccessView: UIView {

    lazy var animationView: AnimationView = {
        let av = AnimationView()
        av.loopMode = LottieLoopMode.playOnce
        av.contentMode = .scaleAspectFill
        av.clipsToBounds = false
        return av
    }()

    override var isHidden: Bool {
        didSet {
            if isHidden {
                animationView.stop()
            }
            else {
                animationView.play()
            }
        }
    }

    private let titleLabel = UILabel()

    private let descLabel = UILabel()

    private let emptyView = UIView()

    var finishSubject: () -> Void = {}
    
    private var model: SuccessModel = .favorites

    func setup(model: SuccessModel) {

        backgroundColor = .background
        emptyView.backgroundColor = .clear
        titleLabel.textColor = UIColor.white
        titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        descLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        descLabel.font = .systemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        descLabel.textAlignment = .center
        titleLabel.text = model.title
        descLabel.text = model.subtitle
        let animation = Lottie.Animation.named(model.animation.rawValue)
        animationView.animation = animation
        titleLabel.numberOfLines = 0
        descLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        descLabel.textAlignment = .center
        [animationView, emptyView, titleLabel, descLabel].forEach(addSubview)
        animationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-48)
            $0.width.height.equalTo(350)
        }
        clipsToBounds = false
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.top.equalTo(animationView.snp.bottom).offset(-24)
            $0.centerX.equalToSuperview()
        }

        emptyView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.top.equalTo(animationView.snp.bottom).inset(10)
        }

        descLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        animationView.play()
    }

    func play() {
        animationView.play()
    }
}
