//
//  LoaderCell.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/12/21.
//

import UIKit
import MaterialActivityIndicator

enum FooterState {
    case loading
    case showMore
    case allLoaded
}

class LoaderCell: UITableViewCell {

    private let loader = MaterialActivityIndicatorView()

    private lazy var showMoreButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Show more results", for: .normal)
        button.addTarget(self, action: #selector(showMore), for: .touchUpInside)
        return button
    }()

    var state: FooterState = .loading {
        didSet {
            updateUI()
        }
    }

    var onShowMore: () -> Void = {}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        separatorInset = UIEdgeInsets(top: 0, left: 500, bottom: 0, right: 0)
        contentView.addSubview(loader)
        loader.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 20, height: 20))
        }
        contentView.addSubview(showMoreButton)
        showMoreButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(50)
        }
        loader.color = .white
        loader.stopAnimating()
        showMoreButton.isHidden = true
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        loader.stopAnimating()
        showMoreButton.isHidden = true
    }

    private func updateUI() {
        loader.stopAnimating()
        showMoreButton.isHidden = true
        showMoreButton.isUserInteractionEnabled = false
        switch state {
        case .loading:
            loader.startAnimating()
        case .allLoaded:
            showMoreButton.isHidden = false
            showMoreButton.setTitle("All results are loaded", for: .normal)
        case .showMore:
            showMoreButton.isHidden = false
            showMoreButton.isUserInteractionEnabled = true
            showMoreButton.setTitle("Show more results", for: .normal)
        }
    }

    private func setupUI() {
        contentView.backgroundColor = .background
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func showMore() {
        onShowMore()
    }
}
