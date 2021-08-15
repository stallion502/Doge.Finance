//
//  CandleDetailHorizontalView.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/4/21.
//

import UIKit

class CandleDetailHorizontalView: UIView {
    private var trade: DexTrade?

    private var chartRange: ChartRange = ._15m
    private var address: String = ""
    private var symbol: String = ""
    private let transactionsSize: Int = 20
    private var isLoading: Bool = false
    private var isAllLoaded: Bool = false

    enum Section {
        case transfer(TransactionAPI)
        case header
    }

    private var transactions: [TransactionAPI] = []
    private var sections: [Section] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var totalTradesPrice: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var closePrice: UILabel!
    @IBOutlet weak var openPrice: UILabel!
    @IBOutlet weak var minimumPrice: UILabel!
    @IBOutlet weak var maximumPrice: UILabel!

    var onClose: () -> Void = {}

    var isDisplayed: Bool = false

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if -collectionView.contentOffset.y < point.y {
            return super.hitTest(point, with: event)
        }
        return nil
    }

    override func awakeFromNib() {
        translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: "TransferCollectionCell", bundle: .main), forCellWithReuseIdentifier: "TransferCollectionCell")
        collectionView.register(UINib(nibName: "TransferCollectionHeaderCell", bundle: .main), forCellWithReuseIdentifier: "TransferCollectionHeaderCell")
        collectionView.register(CandleCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CandleCollectionHeaderView")
        collectionView.clipsToBounds = true
        collectionView.layer.cornerRadius = 8
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func setup(address: String, trade: DexTrade?, chartRange: ChartRange, symbol: String) {
        self.chartRange = chartRange
        self.symbol = symbol
        self.address = address
        self.trade = trade
        loadTransactions()
    }

    private func loadTransactions() {
        let timeFrom = DateFormatterBuilder
            .dateFormatter(.iso8601Z, timeZone: .utc)
            .date(from: trade?.timeInterval?.minute ?? "")?
            .string(.isoFull, timeZone: .utc) ?? ""

        let date = DateFormatterBuilder
            .dateFormatter(.iso8601Z, timeZone: .utc)
            .date(from: trade?.timeInterval?.minute ?? "")
        let dif = chartRange.rawValue * 60

        BaseNetworkManager.shared.transactions(
            address: address,
            limit: transactionsSize,
            from: timeFrom
        ) { result in
            switch result {
            case .success(let transactions):
                self.sections = [.header]
                let trs = transactions.filter {
                    guard let date = date, let dateTo = DateFormatterBuilder.dateFormatter(.iso8601ZZZ, timeZone: .utc).date(from: $0.transactionDate ?? "") else {
                        return false
                    }
                    return date.timeIntervalSince(dateTo) < Double(dif)
                }
                self.transactions = trs
                self.sections.append(contentsOf: trs.map { .transfer($0) })
                self.isLoading = false
                self.collectionView.reloadData()
                self.isAllLoaded = transactions.isEmpty
                if let date = date, let dateTo = DateFormatterBuilder.dateFormatter(.iso8601ZZZ, timeZone: .utc).date(from: transactions.last?.transactionDate ?? "") {
                    self.isAllLoaded = date.timeIntervalSince(dateTo) > Double(dif)
                }
            case .failure(let error):
                // TODO! Handle error
                self.isLoading = false
                self.collectionView.reloadData()
            }
        }
    }

    private func loadMoreTransactions() {
        guard !isLoading && !isAllLoaded else { return }
        let timeFrom = transactions.last?.transactionDate ?? ""

        let date = DateFormatterBuilder
            .dateFormatter(.iso8601Z, timeZone: .utc)
            .date(from: trade?.timeInterval?.minute ?? "")
//
        isLoading = true
        print("date \(timeFrom)")
        let dif = chartRange.rawValue * 60
        BaseNetworkManager.shared.transactions(
            address: address,
            limit: transactionsSize,
            from: timeFrom
        ) { result in
            switch result {
            case .success(let transactions):
                guard !self.isAllLoaded else { return }
                let trs = transactions.filter {
                    guard let date = date, let dateTo = DateFormatterBuilder.dateFormatter(.iso8601ZZZ, timeZone: .utc).date(from: $0.transactionDate ?? "") else {
                        return false
                    }
                    return date.timeIntervalSince(dateTo) < Double(dif)
                }
                self.transactions.append(contentsOf: trs)
                self.sections.append(contentsOf: trs.map { .transfer($0) })
                self.isLoading = false
                self.collectionView.reloadData()
                if let date = date, let dateTo = DateFormatterBuilder.dateFormatter(.iso8601ZZZ, timeZone: .utc).date(from: transactions.last?.transactionDate ?? "") {
                    self.isAllLoaded = date.timeIntervalSince(dateTo) > Double(dif)
                }
            case .failure(let error):
                // TODO! Handle error
                self.isLoading = false
                self.collectionView.reloadData()
            }
        }
    }

    @IBAction func closePressed(_ sender: Any) {
        close()
        onClose()
    }

    static func show(in root: UIView, address: String, trade: DexTrade?, chartRange: ChartRange, symbol: String) -> CandleDetailHorizontalView {
        let view: CandleDetailHorizontalView! = .loadFromNib()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.setup(address: address, trade: trade, chartRange: chartRange, symbol: symbol)
        root.addSubview(view)
        view.leadingAnchor.constraint(equalTo: root.safeAreaLayoutGuide.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: root.safeAreaLayoutGuide.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: root.bottomAnchor).isActive = true
        view.transform = CGAffineTransform(translationX: 0, y: 600)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            UIView.animate(withDuration: 0.3, animations: {
                view.transform = .identity
            }, completion: { _ in
                view.isDisplayed = true
            })
        }

        return view
    }
}

extension CandleDetailHorizontalView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.row] {
        case .header:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransferCollectionHeaderCell", for: indexPath)
            cell.backgroundColor = .clear
            return cell
        case .transfer(let transfer):
            let cell: TransferCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransferCollectionCell", for: indexPath) as! TransferCollectionCell
            cell.symbol = symbol
            cell.setup(with: transfer)
            cell.backgroundColor = .clear
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row > sections.count - 5 && !sections.isEmpty {
            loadMoreTransactions()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat
        switch sections[indexPath.row] {
        case .header:
            height = 44
        case .transfer:
            height = 66
        }

        return CGSize(width: collectionView.frame.width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView.contentOffset.y <= -scrollView.contentInset.top {
            close()
            onClose()
        }
    }

    func close() {
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: 500)
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.removeFromSuperview()
            }
        })
    }
}

