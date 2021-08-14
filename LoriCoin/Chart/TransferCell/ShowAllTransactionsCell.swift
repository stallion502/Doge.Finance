//
//  ShowAllTransactionsCell.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 7/19/21.
//

import UIKit

class ShowAllTransactionsCell: UICollectionViewCell {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.text = "Show all transactions"
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

