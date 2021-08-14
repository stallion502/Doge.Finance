//
//  TitleView.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/4/21.
//

import UIKit

class TitleView: UIView {

    let titleLabel = UILabel(frame: .zero)

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupUI()
        addShadow()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        layer.cornerRadius = 4
        backgroundColor = .mainGreen
        titleLabel.text = "21:00"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        addSubview(titleLabel)
        let offset: CGFloat = 5
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: offset).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -offset).isActive = true

        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset).isActive = true
    }
}
