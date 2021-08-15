//
//  CandleDetailView.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 6/30/21.
//

import UIKit
import MaterialActivityIndicator

class CandleDetailView: UIView {

    private var trade: DexTrade?

    private var chartRange: ChartRange = ._15m
    private var address: String = ""
    private var symbol: String = ""

    enum Section {
        case transfer(TransactionAPI)
        case header
    }

    private var transactions: [TransactionAPI] = []
    private var sections: [Section] = []
    @IBOutlet weak var bgHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    private var isLoading: Bool = false
    private var isAllLoaded: Bool = false
    private let transactionsSize: Int = 20

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
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func setup(address: String, trade: DexTrade?, chartRange: ChartRange, symbol: String) {
        self.address = address
        self.chartRange = chartRange
        self.symbol = symbol
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
//        close()
        onClose()
    }
    
    static func show(in root: UIView, address: String, trade: DexTrade?, chartRange: ChartRange, symbol: String) -> CandleDetailView {
        let view: CandleDetailView! = .loadFromNib()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.setup(address: address, trade: trade, chartRange: chartRange, symbol: symbol)
        root.addSubview(view)
        view.leadingAnchor.constraint(equalTo: root.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: root.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: root.bottomAnchor).isActive = true
        view.topAnchor.constraint(equalTo: root.safeAreaLayoutGuide.topAnchor, constant: 94).isActive = true
        view.collectionView.contentInset.top = UIScreen.main.bounds.height - 350
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

extension CandleDetailView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.row] {
        case .header:
            return collectionView.dequeueReusableCell(withReuseIdentifier: "TransferCollectionHeaderCell", for: indexPath)
        case .transfer(let transfer):
            let cell: TransferCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransferCollectionCell", for: indexPath) as! TransferCollectionCell
            cell.symbol = symbol
            cell.separatorView.backgroundColor = UIColor.white.withAlphaComponent(0.55)
            cell.setup(with: transfer)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CandleCollectionHeaderView", for: indexPath) as! CandleCollectionHeaderView
        view.setup(isLoading: isLoading, trade: trade)
        view.onClose = { [weak self] in
            self?.close()
            self?.onClose()
        }
        return view
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CandleTableHeaderView")
        return view
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if transactions.isEmpty {
            return CGSize(width: collectionView.frame.width, height: 300)
        } else {
            return CGSize(width: collectionView.frame.width, height: 192)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
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

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row > sections.count - 5 && !sections.isEmpty {
            loadMoreTransactions()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        bgHeaderHeightConstraint.constant = min(
            scrollView.contentOffset.y + scrollView.contentInset.top,
            frame.height
        )
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView.contentOffset.y <= -scrollView.contentInset.top {
            close()
            onClose()
        }
    }

    func close() {
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: 670)
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.removeFromSuperview()
            }
        })
    }
}

extension Date {
    var zeroSeconds: Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return calendar.date(from: dateComponents) ?? .init()
    }
}
