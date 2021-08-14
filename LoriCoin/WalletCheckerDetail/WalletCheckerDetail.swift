//
//  WalletCheckerDetail.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 7/30/21.
//

import UIKit
import SnapKit

class WalletCheckerDetail: UIViewController {

    private let segmentControl = UISegmentedControl()

    private lazy var containerView = UIView()

    private var pages: PageViewController?
    private var itemsVC: [UIViewController] = []
    private let address: String

    init(address: String) {
        self.address = address
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @objc private func segmentSelected() {
        pages?.setCurrentIndex(segmentControl.selectedSegmentIndex)
    }

    private func setupUI() {
        view.backgroundColor = .black
        containerView.backgroundColor = .black
        segmentControl.insertSegment(withTitle: "Transactions", at: 0, animated: false)
        segmentControl.addTarget(self, action: #selector(segmentSelected), for: .valueChanged)
        segmentControl.insertSegment(withTitle: "Balance", at: 0, animated: false)
        view.addSubview(containerView)
        view.addSubview(segmentControl)

        segmentControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.left.right.equalToSuperview().inset(16)
        }
        segmentControl.tintColor = .mainYellow
        segmentControl.selectedSegmentIndex = 0
        containerView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(16)
            $0.left.right.bottom.equalToSuperview()
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "\(address.prefix(8))..."
        navigationItem.largeTitleDisplayMode = .always

        itemsVC.append(DevWalletBalanceController(walletAdress: address))
        itemsVC.append(DevWalletTransactionsController(walletAdress: address))
        pages = PageViewController.insert(
            rootController: self,
            pages: itemsVC,
            delegate: self,
            containerView: containerView
        )
    }
}

extension WalletCheckerDetail: PageViewControllerDelegate {

    func indexDidChanged(index: Int) {
        segmentControl.selectedSegmentIndex = Int(index)
    }
}
