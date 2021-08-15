//
//  TransactionsCollectionView.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/6/21.
//

import UIKit

enum TransactionsState {
    case loading
    case endLoading
}

class TransactionsCollectionView: UICollectionView {
    enum Section {
        case transfer(TransactionAPI)
        case header
        case newTransactions
        case showAll

        var index: Int {
            switch self {
            case .header:
                return 0
            case .transfer:
                return 1
            case .newTransactions:
                return 2
            case .showAll:
                return 3
            }
        }
    }

    var symbol: String = "" {
        didSet {
            reloadData()
        }
    }
    var isAll: Bool = false
    var onCellWillAppear: (IndexPath) -> Void = { _ in }
    var onInsertNew: (Int) -> Void = { _ in }

    var scrollDownButton: UIButton?
    weak var topHeaderView: UIView?
    var onState: (TransactionsState) -> Void = { _ in }
    var showAllTransactions: (() -> Void)?

    var maxYPoint: CGFloat = 0
    var totalHeight: CGFloat {
        (0..<numberOfItems(inSection: 0)).map { height(for: $0) }.reduce(0, +)
    }

    private var offset: Int = 0
    private var txSize: Int = 40
    private let txHeight: CGFloat = 165
    private var newTransactions: [TransactionAPI] = []

    var transactions: [TransactionAPI] = [] {
        didSet {
            if !isAll {
                self.sections = [.header]
                self.sections.append(contentsOf: transactions.map { .transfer($0) })
            } else {
                if !newTransactions.isEmpty {
                    self.sections = [.newTransactions]
                }
                self.sections.append(contentsOf: transactions.map { .transfer($0) })
            }
            reloadData()
        }
    }
    private var sections: [Section] = []
    var baseAddress: String = ""
    var quoteCurrency: String = ""

    override func awakeFromNib() {
        clipsToBounds = true
        layer.cornerRadius = 8
        register(UINib(nibName: "TransferCollectionCell", bundle: .main), forCellWithReuseIdentifier: "TransferCollectionCell")
        register(UINib(nibName: "TransferCollectionHeaderCell", bundle: .main), forCellWithReuseIdentifier: "TransferCollectionHeaderCell")
        register(UINib(nibName: "NewTransactionsCell", bundle: .main), forCellWithReuseIdentifier: "NewTransactionsCell")
        register(ShowAllTransactionsCell.self, forCellWithReuseIdentifier: "ShowAllTransactionsCell")
        delegate = self
        dataSource = self
    }

    func insertTransaction(_ transaction: TransactionAPI) {
        newTransactions.append(transaction)
        if !sections.contains(where: { $0.index == 2 }), !sections.isEmpty {
            sections.insert(.newTransactions, at: isAll ? 0 : 1)
        }
        reloadData()
//        if let cell = cellForItem(at: IndexPath(row: 1, section: 0)) as? TransferCollectionHeaderCell {
//            cell.animateBG()
//        }
    }
}

extension TransactionsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.row] {
        case .header:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransferCollectionHeaderCell", for: indexPath) as! TransferCollectionHeaderCell
            cell.separators.forEach {
                $0.backgroundColor = UIColor.white.withAlphaComponent(0.7)
            }
            cell.dropDownButton.isHidden = false
            cell.dropDownButton.addTarget(self, action: #selector(showAllTransaction), for: .touchUpInside)
            cell.backgroundColor = .clear
            return cell
        case .newTransactions:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewTransactionsCell", for: indexPath) as! NewTransactionsCell
            cell.setup(with: newTransactions.count)
            return cell
        case .transfer(let transfer):
            let cell: TransferCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransferCollectionCell", for: indexPath) as! TransferCollectionCell
            cell.separatorView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
            cell.symbol = symbol
            cell.setup(with: transfer)
            cell.backgroundColor = .clear
            return cell
        case .showAll:
            let cell: ShowAllTransactionsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowAllTransactionsCell", for: indexPath) as! ShowAllTransactionsCell
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }

    func height(for index: Int) -> CGFloat {
        var height: CGFloat
        switch sections[index] {
        case .header:
            height = 82
        case .transfer:
            height = 66
        case .showAll:
            height = 40
        case .newTransactions:
            height = 45
        }
        return height
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = height(for: indexPath.row)
        return CGSize(width: collectionView.frame.width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        onCellWillAppear(indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sections[indexPath.row] {
        case .showAll:
            showAllTransactions?()
        case .newTransactions:
            transactions.insert(contentsOf: newTransactions.reversed(), at: 0)
            sections.removeAll(where: { $0.index == 2 })
            newTransactions.removeAll()
            collectionView.reloadData()
            onInsertNew(transactions.count)
        default:
            break
        }
    }

    @objc private func showAllTransaction() {
        showAllTransactions?()
    }
}
