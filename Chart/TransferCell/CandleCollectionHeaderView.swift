//
//  CandleTableHeaderView.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/4/21.
//

import UIKit

class CandleCollectionHeaderView: UICollectionReusableView {

    private let view: CandleDetailTableHeaderView = .loadFromNib()!

    var onClose: () -> Void = {} {
        didSet {
            view.onClose = onClose
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(view)
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        setupUI()
    }


    private func setupUI() {
        superview?.backgroundColor = .clear
        backgroundColor = .clear
    }

    func setup(isLoading: Bool, trade: DexTrade?) {
        view.isLoading = isLoading
        view.trade = trade
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
