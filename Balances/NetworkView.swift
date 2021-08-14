//
//  NetworkView.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 7/22/21.
//

import UIKit
import SnapKit

class NetworkView: UIView {

    private let imageView = UIImageView(image: UIImage(named: "binanceSmall"))
    private let titleLabel = UILabel()

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(imageView)
        addSubview(titleLabel)
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        titleLabel.text = "Smart Chain"
            
        imageView.snp.makeConstraints {
            $0.bottom.left.top.equalToSuperview()
            $0.height.width.equalTo(29)
        }

        titleLabel.snp.makeConstraints {
            $0.bottom.top.right.equalToSuperview()
            $0.left.equalTo(imageView.snp.right).offset(12)
        }
    }
}
