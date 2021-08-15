//
//  AllTransactionsController.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 7/19/21.
//

import UIKit
import MaterialActivityIndicator

class AllTransactionsController: UIViewController {

    @IBOutlet weak var filterContainerView: UIView!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var timeContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeContainerView: UIStackView!
    @IBOutlet weak var transactionsCollectionView: TransactionsCollectionView!
    @IBOutlet weak var transactionsLoader: MaterialActivityIndicatorView!

    private var isTimeShown: Bool = false
    private let address: String
    private let symbol: String
    private var isLoading: Bool = false
    private var initiallyLoaded: Bool = false
    private var isAllLoaded: Bool = false
    private let transactionsSize: Int = 20
    private var startDate: Date?
    private var endDate: Date?

    init(address: String, symbol: String) {
        self.address = address
        self.symbol = symbol
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Transactions"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(filterPressed)),
            UIBarButtonItem(image: UIImage(named: "time"), style: .plain, target: self, action: #selector(timePressed))
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        applyButton.layer.cornerRadius = 8
        applyButton.addTarget(self, action: #selector(applyPressed), for: .touchUpInside)
        transactionsCollectionView.symbol = symbol
        transactionsCollectionView.isAll = true
        transactionsCollectionView.onCellWillAppear = { [weak self] ip in
            guard ip.row > self!.transactionsCollectionView.transactions.count - 5 && !self!.transactionsCollectionView.transactions.isEmpty else { return }
            self?.loadMoreTransactions()
        }
        loadTransactions()
    }

    @IBAction func clearPresed(_ sender: Any) {
        filterLabel.text = ""
        filterContainerView.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }

        startDate = nil
        endDate = nil

        isAllLoaded = false
        isLoading = false
        loadTransactions()
    }
    
    func insertTransaction(_ transaction: TransactionAPI?) {
        guard let transaction = transaction, initiallyLoaded else { return }
        transactionsCollectionView.insertTransaction(transaction)
    }

    @objc private func timePressed() {
        isTimeShown = !isTimeShown
        timeContainerBottomConstraint.constant = isTimeShown ? 0 : -350
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func filterPressed() {
        let controller = BottomModalViewController()
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }

    @objc private func applyPressed() {
        timePressed()
        startDate = fromDatePicker.date
        endDate = toDatePicker.date

        let dates = [startDate?.string(.HHmm), endDate?.string(.HHmm)].compactMap { $0 }.joined(separator: " - ")
        filterLabel.text = dates
        filterContainerView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }

        isAllLoaded = false
        isLoading = false
        loadTransactions()
    }

    private func loadTransactions() {
        transactionsLoader.color = .white
        transactionsLoader.startAnimating()
        let date = endDate ?? Date()

        BaseNetworkManager.shared.transactions(
            address: address,
            limit: transactionsSize,
            from: date.string(.isoFull, timeZone: .utc))
        { [weak self] result in
            self?.transactionsLoader.stopAnimating()
            switch result {
            case .success(let transactions):
                guard let self = self else { return }
                guard !transactions.isEmpty else {
                    self.transactionsCollectionView.isHidden = true
                    return
                }
                let trs = transactions.filter {
                    guard let date = self.startDate, let dateTo = DateFormatterBuilder.dateFormatter(.iso8601ZZZ, timeZone: .utc).date(from: $0.transactionDate ?? "") else {
                        return true
                    }
                    return date.timeIntervalSince(dateTo) < 0
                }
                self.initiallyLoaded = true
                self.transactionsCollectionView.transactions = trs
                self.isAllLoaded = trs.isEmpty
            case .failure:
                self?.transactionsCollectionView.isHidden = true
            }
        }
    }

    private func loadMoreTransactions() {
        guard !isLoading && !isAllLoaded else { return }
        isLoading = true
        transactionsLoader.color = .white

        BaseNetworkManager.shared.transactions(
            address: address,
            limit: transactionsSize,
            from: transactionsCollectionView.transactions.last?.transactionDate ?? "")
        { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let transactions):
                guard let self = self else { return }
                guard !transactions.isEmpty else {
                    self.transactionsCollectionView.isHidden = true
                    return
                }
                let trs = transactions.filter {
                    guard let date = self.startDate, let dateTo = DateFormatterBuilder.dateFormatter(.iso8601ZZZ, timeZone: .utc).date(from: $0.transactionDate ?? "") else {
                        return true
                    }
                    return date.timeIntervalSince(dateTo) < 0
                }
                self.transactionsCollectionView.transactions.append(contentsOf: trs)
                self.isAllLoaded = trs.isEmpty
            case .failure:
                self?.transactionsCollectionView.isHidden = true
            }
        }
    }
}

extension AllTransactionsController: BottomModalViewControllerDelegate {
    func didSelectDateRange(_ range: (Day?, Day?)) {
        startDate = range.0?.date
        endDate = range.1?.date

        isAllLoaded = false
        isLoading = false
        loadTransactions()
        let dates = [startDate?.string(.ddMM), endDate?.string(.ddMM)].compactMap { $0 }.joined(separator: " - ")
        filterLabel.text = dates
        filterContainerView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
