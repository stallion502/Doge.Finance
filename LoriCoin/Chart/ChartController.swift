//
//  ChartController.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 6/28/21.
//

import UIKit
import Charts
import MaterialActivityIndicator
import SDWebImage

enum PriceChange: Int {
    case grow
    case down
    case none
}

enum SearchType {
    case search
    case none
}

enum ChartRange: Int {
    case _1m = 1
    case _15m = 15
    case _1h = 60
    case _4h = 240
    case _1d = 1440

    var chartSize: Int {
        switch self {
        case ._1m:
            return 300
        default:
            return 100
        }
    }
}

enum ChartType: Int {
    case candle
    case lineFilled
    case line
}

class ChartController: UIViewController {

    @IBOutlet weak var watchOutLabel: UILabel!
    @IBOutlet weak var watchOutView: UIView!
    @IBOutlet weak var nameLabel: CircleView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var transactionsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var transactionsHeaderView: UIView!
    @IBOutlet weak var moreDataLoader: MaterialActivityIndicatorView!
    @IBOutlet weak var volumeChangeLabel: UILabel!
    @IBOutlet weak var dayPriceChangeLabel: UILabel!
    @IBOutlet weak var optionsView: ChartOptionsView!
    @IBOutlet weak var baseLineChartView: BaseLineChart!
    @IBOutlet weak var moreOptionsTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var rangeTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var rangeLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rangeView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var selectorCollectionView: SelectorCollectionView!
    @IBOutlet weak var liqudityLabel: UILabel!
    @IBOutlet weak var transactionsLoader: MaterialActivityIndicatorView!
    @IBOutlet weak var scrollDownButton: UIButton!

    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var transactionsCollectionView: TransactionsCollectionView!
    @IBOutlet weak var dollarPrice: UILabel!
    @IBOutlet weak var totalSupplyLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var dashedView: DashedView!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var chartContainerView: UIView!
    @IBOutlet weak var fullPrice: UILabel!
    @IBOutlet weak var sellCurrencyLabel: UILabel!
    @IBOutlet weak var baseCurrencyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var topTokenLogo: UIImageView!
    @IBOutlet weak var activityIndicator: MaterialActivityIndicatorView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet var optionButtons: [UIButton]!
    @IBOutlet weak var chartHeightConstraint: NSLayoutConstraint!
    @IBOutlet var verticalConstraints: [NSLayoutConstraint]!
    @IBOutlet var chartView: CandleStickChartView!
    @IBOutlet weak var barChartView: ValueBarChartView!
    private var devWalletAdress: String?
    private var chartType: ChartType = .candle
    private var chartRange: ChartRange = ._15m

    private var viewModel = ChartViewModel()

    private var chartOffset: Int = 0

    private let searchResultsController = SearchViewController()
    private lazy var search = UISearchController(searchResultsController: searchResultsController)

    private var lastPriceChange: PriceChange = .none

    private var currentDetailView: CandleDetailView?

    private var horizontalCurrentDetailView: CandleDetailHorizontalView?

    private let chartDetailTopView: ChartDetailTopView = .loadFromNib()!

    private let operationQueue = OperationQueue()

    private var priceType: PriceChartType = .bnbBUSD
    private var devTokens: [TokenSearch] = []

    private var isChartLoading: Bool = false
    private var isAllLoaded: Bool = false

    private let address: String
    private let bnbAddress = "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c"

    private var initialAxisMax: Double = 0
    private var initialAxisMin: Double = 0
    private var currentScaleX: CGFloat = 10
    private var transactionsLimit: Int = 20

    var allowRotation: Bool {
        return !dexTrades.isEmpty
    }
    private let manager = ApolloManager()
    private var rowDexTrades: [DexTrade] = []
    private var dexTrades: [DexTrade] = []
    private var dates: [Date] = []
    private var chartTopViewIsHidden: Bool = false
    private var tokenPrice: TokenInfo?
    private var isPriceAnimtating: Bool = false
    private var chartDateRange: (Date, Date) = (.init(), .init())

    private lazy var longGesture = UILongPressGestureRecognizer(target: self, action: #selector(dashPanned))

    private let type: SearchType

    private var onNewTransaction: ((TransactionAPI?, String) -> Void)?
    private var allTransactionsController: AllTransactionsController?

    init(address: String, type: SearchType = .none) {
        self.address = address
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true

        let fav = FavoritesService.shared.isFavorite(address: address)
        let image = fav
            ? UIImage(named: "fav")?.withRenderingMode(.alwaysOriginal)
            : UIImage(named: "fav")
        navigationItem.rightBarButtonItems = [
//            UIBarButtonItem(
//                image: UIImage(named: "ring")?.withRenderingMode(.alwaysTemplate),
//                style: .plain,
//                target: self,
//                action: nil
//            ),
             UIBarButtonItem(
                image: image,
                style: .plain,
                target: self,
                action: #selector(becomeFavorite)
             )
        ]
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Charts"
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        guard parent == nil else { return }
        BaseSocketManager.shared.removeSubscription(address)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dashedView.highlitedYView.isHidden = true
        showTopView(with: nil, isHidden: true)
        dashedView.centerPoint = .zero
        tabBarController?.tabBar.isHidden = false
        dismissInfoViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        transactionsCollectionView.quoteCurrency = bnbAddress
        transactionsCollectionView.baseAddress = address
        loadTransactions()

        loadDevWallet()
        barChartView.noDataText = ""
        chartView.noDataText = ""
        activityIndicator.color = UIColor.white
        activityIndicator.startAnimating()

        segmentControl.selectedSegmentIndex = 1
        segmentControl.addTarget(self, action: #selector(changeChartRange), for: .valueChanged)
        loadChart()
        moreDataLoader.color = .white
        manager.getLatestPrice(baseAddress: address, completion: { result in
            switch result {
            case .success(let eth):
                self.sellCurrencyLabel.text = "/ WBNB"
            case .failure(let error):
                print(error)
            }
        })

        onNewTransaction = { [weak self] transaction, address in
            guard let transaction = transaction, self?.address == address else { return }
            self?.transactionsCollectionView.insertTransaction(transaction)
            self?.allTransactionsController?.insertTransaction(transaction)
        }

        BaseSocketManager.shared.subscribeOnPriceChange(
            address: address,
            subscriber: { [weak self] tokenInfo, address in
                guard self?.address == address else { return }
                self?.updatePrice(newInfo: tokenInfo)
            }, transactionSubscriber: onNewTransaction)

        BaseNetworkManager.shared.tokenInfo(address: address) {
            [weak self] result in
            switch result {
            case .success(let info):
                self?.tokenPrice = info
                self?.setupWatchOut()
                self?.setupPrice(info: info)
            case .failure(let error):
                print(error)
            }
        }
        chartView.delegate = self

        chartHeightConstraint.constant = min(UIScreen.main.bounds.height - safeLength - 360, 354)
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        chartView.legend.enabled = false
        chartView.noDataTextColor = .black
        chartView.rightAxis.labelTextColor = UIColor.white.withAlphaComponent(0.75)
        chartView.rightAxis.labelFont = .systemFont(ofSize: 9, weight: .medium)
        chartView.rightAxis.spaceTop = 0.3
        chartView.xAxis.spaceMin = 25
        chartView.rightAxis.spaceBottom = 0.3
        chartView.rightAxis.axisMinimum = 0

        chartView.leftAxis.enabled = false

        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .systemFont(ofSize: 9, weight: .medium)
        chartView.xAxis.labelTextColor = UIColor.white.withAlphaComponent(0.75)
        if UIScreen.main.bounds.width > 375 {
            optionButtons.forEach {
                $0.titleLabel?.font = .systemFont(ofSize: 12)
            }
        }

        topTokenLogo.sd_setImage(with: URL(string: "http://81.23.151.224:5101/api/icon/\(address)"), completed: { [weak self] image, error, _, _ in
            if error != nil || image == nil {
                if let first = self?.baseCurrencyLabel?.text?.prefix(3) {
                    self?.nameLabel.isHidden = false
                }
            }
        })

        longGesture.minimumPressDuration = 0.4
        longGesture.allowableMovement = 50
        chartContainerView.addGestureRecognizer(longGesture)
        tabBarController?.view.addSubview(chartDetailTopView)
        chartDetailTopView.transform = CGAffineTransform(translationX: 0, y: -300)
        chartDetailTopView.onClose = { [weak self] in
            self?.dashedView.centerPoint = .zero
            self?.showTopView(with: nil, isHidden: true)
        }
        if !isPortrait { relayoutChart() }

        if let textField = search.searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.white.withAlphaComponent(0.05)
            let pasteButton = UIButton(type: .system)
            pasteButton.setImage(UIImage(named: "copy"), for: .normal)
            textField.rightView = pasteButton
            textField.rightViewMode = .always
        }
        search.searchBar.setValue("Cancel", forKey: "cancelButtonText")
        search.hidesNavigationBarDuringPresentation = true
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search by adress, symbol or name..."
        search.searchBar.barStyle = .black
        search.searchBar.delegate = self
        search.searchResultsUpdater = self
        switch type {
        case .none:
            break
        case .search:
            navigationItem.searchController = search
        }
        transactionsCollectionView.showAllTransactions = { [weak self] in
            self?.showAllTransactions()
        }
        transactionsCollectionView.scrollDownButton = scrollDownButton
        transactionsCollectionView.onState = { [weak self] state in
            switch state {
            case .loading:
                self?.transactionsLoader.color = .white
                self?.transactionsLoader.startAnimating()
            case .endLoading:
                self?.transactionsLoader.stopAnimating()
            }
        }
        scrollDownButton.layer.cornerRadius = 20
        scrollDownButton.transform = CGAffineTransform(rotationAngle: .pi)

        selectorCollectionView.onIndexPathSelect = { [weak self] ip in
            guard let adress = self?.devWalletAdress else { return }
            switch ip {
//            case 0:
//                let trustWallet = "https://link.trustwallet.com/open_url?coin_id=60&url=https://compound.finance"
//                let metamask = "https://metamask.app.link/dapp/exchange.pancakeswap.finance/#/swap"
//                UIApplication.shared.open(URL(string: metamask)!, options: [:], completionHandler: nil)
            case 0:
                let web = DevWalletBalanceController(walletAdress: adress)
                let vc = UINavigationController(rootViewController: web)
                self?.present(vc, animated: true, completion: nil)
            case 1:
                let web = DevWalletTransactionsController(walletAdress: adress)
                let vc = UINavigationController(rootViewController: web)
                self?.present(vc, animated: true, completion: nil)

            case 2:
                let web = WhaleTransactionsController(walletAdress: self?.address ?? "")
                let vc = UINavigationController(rootViewController: web)
                self?.present(vc, animated: true, completion: nil)
            default:
                break
            }
        }

        segmentControl.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 10, weight: .medium)], for: .normal)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        transactionsCollectionView.maxYPoint = chartView.frame.height + rangeView.frame.height
    }

    private func loadTransactions() {
        transactionsLoader.color = .white
        transactionsLoader.startAnimating()

        BaseNetworkManager.shared.transactions(
            address: address,
            limit: transactionsLimit,
            from: Date().string(.isoFull, timeZone: .utc))
        { [weak self] result in
            self?.transactionsLoader.stopAnimating()
            switch result {
            case .success(let transactions):
                guard let self = self else { return }
                guard !transactions.isEmpty else {
                    self.transactionsCollectionView.isHidden = true
                    return
                }
                self.transactionsHeightConstraint.constant = self.view.frame.height - self.safeLength - 80
                self.transactionsCollectionView.transactions = Array(transactions.prefix(9))
                self.transactionsCollectionView.onInsertNew = { count in
                    self.transactionsHeightConstraint.constant = self.transactionsCollectionView.totalHeight
                }
            case .failure:
                self?.transactionsCollectionView.isHidden = true
            }
        }
    }

    private func loadChart(animateNewResults: Bool = false) {
        if animateNewResults {
            chartContainerView.startAnimation()
        }
        isAllLoaded = false
        chartOffset = 0
        isChartLoading = true
        manager.getDexTrades(
            range: chartRange,
            till: Date().string(.iso8601, timeZone: .utc),
            limit: chartRange.chartSize,
            offset: chartOffset,
            baseCurrency: address
        ) { result in
            self.activityIndicator.stopAnimating()
            self.chartContainerView.stopAnimation()
            if animateNewResults {
                self.chartView.animate(xAxisDuration: 1.0)
            }
            switch result {
            case .success(let eth):
                self.rowDexTrades = eth?.ethereum?.dexTrades ?? []
                self.dexTrades = self.prepareDexTrades(address: self.address, type: self.priceType)
                self.viewModel.lastTransaction = self.dexTrades.last
                self.updateChartData()
                self.chartOffset += self.chartRange.chartSize
            case .failure(let error):
                print(error)
            }
            self.isChartLoading = false
        }
    }

    private func loadMoreChart() {
        guard !isChartLoading && !isAllLoaded else { return }
        isChartLoading = true
        moreDataLoader.startAnimating()
        manager.getDexTrades(
            range: chartRange,
            till: Date().string(.iso8601, timeZone: .utc),
            limit: chartRange.chartSize,
            offset: chartOffset,
            baseCurrency: address
        ) { result in
            self.moreDataLoader.stopAnimating()
            switch result {
            case .success(let eth):
                guard eth?.ethereum?.dexTrades != nil else {
                    return
                }
                let newTrades = eth?.ethereum?.dexTrades ?? []
                let filterTrades = newTrades.filter {
                    guard let closePrice = $0.closePrice, let openPrice = $0.openPrice else {
                        return false
                    }
                    return closePrice != openPrice
                        && $0.baseCurrency?.address?.uppercased() == self.address.uppercased()
                }
                if filterTrades.isEmpty {
                    self.isAllLoaded = true
                    return
                }
                let oldCount = self.dexTrades.count
                self.rowDexTrades.append(contentsOf: newTrades)
                self.dexTrades = self.prepareDexTrades(address: self.address, type: self.priceType)
                let newCount = self.dexTrades.count
                let chartXOffset = self.chartView.lowestVisibleX
                self.loadMoreData(trades: self.dexTrades, offset: newCount - oldCount + Int(chartXOffset))
                self.chartOffset += self.chartRange.chartSize
            case .failure(let error):
                print(error)
            }

            self.isChartLoading = false
        }
    }


    @objc private func dashPanned(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .changed:
            let point = sender.location(in: chartContainerView)
            dashedView.centerPoint = point
            let value = chartView.valueForTouchPoint(point: point, axis: .right)
            let highlited = chartView.getHighlightByTouchPoint(point)
            let index = Int(highlited?.x ?? 0)
            guard index < dates.count else { return }
            let date = dates[index].string(.dMMMMHHmm) // TODO SAFE
            let trade = dexTrades[index]
            showTopView(with: trade, isHidden: false)
            dashedView.hightliteValueLongPress(
                isGreen: true,
                date: date,
                price: max(0, Double(value.y)).prettyString
            )
        default:
            enableChartGestures(isEnabled: true)
        }
    }

    @objc private func becomeFavorite() {
        guard let tokenPrice = tokenPrice else { return }
        let fav = FavoritesService.shared.isFavorite(address: address)
        FavoritesService.shared.setFavorites(token: tokenPrice, isFavorite: !fav)
        let image = !fav
            ? UIImage(named: "fav")?.withRenderingMode(.alwaysOriginal)
            : UIImage(named: "fav")
        navigationItem.rightBarButtonItems?[0] = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(becomeFavorite)
         )
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        relayoutChart()
    }

    private func loadDevWallet() {
        ApolloManager.shared.devWalletAdress(address: address) { [weak self] result in
            switch result {
            case .success(let eth):
                guard let devWalletAdress = eth?.ethereum?.transfers?.first?.receiver?.address else {
                    return
                }
                self?.devWalletAdress = devWalletAdress
                self?.selectorCollectionView.isHidden = false
                self?.loadDevWalletBalance()
                UIView.animate(withDuration: 0.3) {
                    self?.view.layoutIfNeeded()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func loadDevWalletBalance() {
        guard let devWalletAdress = devWalletAdress else { return }
        ApolloManager.shared.walletBalance(address: devWalletAdress) { result in
            switch result {
            case .success(let eth):
                let tokens = eth?.ethereum?.address?.first?.balances?.map { $0.toSearchToken() } ?? []
                self.devTokens = tokens
                self.setupWatchOut()
            default:
                break
            }
        }
    }

    private func setupWatchOut() {
        if let token = devTokens.first(where: { $0.address == self.address }), let value = token.usdtPrice, value > 0, let totalSupply = tokenPrice?.supply {
            let percentage = value / totalSupply * 100
            guard percentage > 1 else { return }
            self.watchOutView.isHidden = false
            self.watchOutLabel.text = "Be carefull, Dev has unlocked coins!\nDev wallet has \(Int(percentage)) % of all \(token.symbol ?? "")"
            print(token.usdtPrice)
        }
    }

    private func updatePrice(newInfo: TokenSocketModel?) {
        viewModel.priceReceived(token: newInfo)
        if let currentPrice = tokenPrice?.usdtPrice, let newPrice = newInfo?.priceInUsdt {
            guard currentPrice != newPrice && newPrice != 0 else { return }
            self.tokenPrice?.usdtPrice = newPrice
            self.tokenPrice?.priceInBnb = newInfo?.priceInBnb
            if newPrice > 1 {
                self.priceLabel.text = newPrice.percentWithSeparator + " $"
            } else {
                if newPrice > 0.00001 {
                    self.priceLabel.text = newPrice.begin5PriceString + " $"
                } else {
                    self.priceLabel.text = newPrice.beginPriceString + " $"
                }
            }
            
            let usdtPrice = newInfo?.priceInBnb.value ?? 0
            self.dollarPrice.attributedText = usdtPrice.toBNBPriceLower
            let power = newInfo?.priceInUsdt.power
            if power != "" {
                self.fullPrice.text = newPrice.fullFormattedWithSeparator + " $"
            } else {
                fullPrice.text = ""
            }
            let prefix = currentPrice > newPrice ? "" : "+"
            let dif = currentPrice > newPrice ? currentPrice - newPrice : newPrice - currentPrice
            priceChangeLabel.text = "\(prefix) \(dif.fullFormattedWithSeparator)"
            priceChangeLabel.textColor = currentPrice > newPrice ? .mainRed : .mainGreen
            UIView.animate(withDuration: 0.3, animations: {
                if dif.fullFormattedWithSeparator != "0" {
                    self.priceChangeLabel.alpha = 1
                }
                self.fullPrice.textColor = currentPrice > newPrice ? .mainRed : .mainGreen
                self.dollarPrice.textColor = currentPrice > newPrice ? .mainRed : .mainGreen
                self.priceLabel.textColor = currentPrice > newPrice ? .mainRed : .mainGreen
                self.powerLabel.textColor = currentPrice > newPrice ? .mainRed : .mainGreen
            }, completion: { _ in
                self.perform(#selector(self.restoreTextColor), with: nil, afterDelay: 1.5)
            })
        }

//

        if let currentVChange = tokenPrice?.dayVolumeChange, let newVChange = newInfo?.dayVolumeChange {
            guard currentVChange != newVChange && newVChange != 0 else { return }
            self.tokenPrice?.dayVolumeChange = newVChange
            let isVolumeUp = newVChange >= 0
            UIView.animate(withDuration: 0.3, animations: {
                self.volumeChangeLabel.textColor = currentVChange > newVChange ? .mainRed : .mainGreen
                self.volumeChangeLabel.text = newVChange == 0 ? "-" : "\(isVolumeUp ? "+" : "")\(newVChange.percentWithSeparator) %"
            })

            self.perform(#selector(self.restoreVolume), with: nil, afterDelay: 1.5)
        }

        if let currentMC = tokenPrice?.marketCap, let newMP = newInfo?.marketCap {
            guard currentMC != newMP && newMP != 0 else { return }
            self.tokenPrice?.marketCap = newMP
            UIView.animate(withDuration: 0.3, animations: {
                self.marketCapLabel.text = "\(newMP.witoutDecimals) $"
                self.marketCapLabel.textColor = currentMC > newMP ? .mainRed : .mainGreen
            })

            self.perform(#selector(self.restoreMarketCapLabel), with: nil, afterDelay: 1.5)
        }

        if let currentChange = tokenPrice?.dayPriceChange, let newChange = newInfo?.dayPriceChange {
            guard currentChange != newChange && newChange != 0 else { return }
            self.tokenPrice?.dayPriceChange = newChange
            let dif = newChange > 0

            UIView.animate(withDuration: 0.3, animations: {
                self.dayPriceChangeLabel.text = newChange == 0 ? "" : "\(dif ? "+" : "")\(newChange.percentWithSeparator) %"

                self.dayPriceChangeLabel.textColor = currentChange > newChange ? .mainRed : .mainGreen
            })
            self.perform(#selector(self.restoreDayChangePrice), with: nil, afterDelay: 1.5)
        }

        if let currentLP = tokenPrice?.liquidityInUsdt, let newLP = newInfo?.liquidityInUsdt {
            guard currentLP != newLP && newLP != 0 else { return }
            self.tokenPrice?.liquidityInUsdt = newLP
            self.tokenPrice?.liquidityInUsdt = newLP
            UIView.animate(withDuration: 0.3, animations: {
                let attributed = NSMutableAttributedString(string: "\(newInfo?.liquidityInUsdt?.formattedWithSeparator ?? "") $", attributes: [:])
                attributed.append(NSAttributedString(string: "\n\(newInfo?.liquidityInBnb?.formattedWithSeparator ?? "") BNB", attributes: [.font: UIFont.systemFont(ofSize: 9, weight: .medium)]))
                self.liqudityLabel.attributedText = attributed
                self.liqudityLabel.textColor = currentLP > newLP ? .mainRed : .mainGreen
            })

            self.perform(#selector(self.restoreLiqidityLabel), with: nil, afterDelay: 1.5)
        }
    }

    @objc private func restoreVolume() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.beginFromCurrentState], animations: {
            self.volumeChangeLabel.textColor = .white
        }, completion: { _ in
            self.isPriceAnimtating = false
        })
    }


    @objc private func restoreDayChangePrice() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.beginFromCurrentState], animations: {
            self.dayPriceChangeLabel.textColor = .white
        }, completion: { _ in
            self.isPriceAnimtating = false
        })
    }

    @objc private func restoreLiqidityLabel() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.beginFromCurrentState], animations: {
            self.liqudityLabel.textColor = .white
        }, completion: { _ in
            self.isPriceAnimtating = false
        })
    }


    @objc private func restoreMarketCapLabel() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.beginFromCurrentState], animations: {
            self.marketCapLabel.textColor = .white
        }, completion: { _ in
            self.isPriceAnimtating = false
        })
    }

    @objc private func restoreTextColor() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.beginFromCurrentState], animations: {
            self.powerLabel.textColor = .white
            self.priceChangeLabel.alpha = 0
            self.priceLabel.textColor = .white
            self.dollarPrice.textColor = .white
            self.fullPrice.textColor = .white
        }, completion: { _ in
            self.isPriceAnimtating = false
        })
    }

    private func showTopView(with trade: DexTrade?, isHidden: Bool) {
        chartTopViewIsHidden = isHidden
        chartDetailTopView.setup(with: trade, isPortrait: isPortrait)
        UIView.animate(withDuration: 0.3) {
            self.chartDetailTopView.transform = isHidden
                ? CGAffineTransform(translationX: 0, y: -300)
                : .identity
        }
    }

    private func prepareDexTrades(address: String, type: PriceChartType) -> [DexTrade] {
        let dexTrades = rowDexTrades
        .filter {
            guard let closePrice = $0.closePrice, let openPrice = $0.openPrice else {
                return false
            }
            return closePrice != openPrice
                && $0.baseCurrency?.address?.uppercased() == address.uppercased()
        }
        .compactMap { trade -> DexTrade? in
            switch type {
            case .bnb:
                return trade
            case .bnbBUSD:
                if let date = trade.timeInterval?.minute, let bnbPrice = BNBPriceService.shared.prices[date] {
                    var trade = trade
                    let quotePrice = trade.quotePrice.value * bnbPrice
                    var openPrice = trade.openPrice?.toDouble() ?? 0
                    openPrice *= bnbPrice
                    var closePrice = trade.closePrice?.toDouble() ?? 0
                    closePrice *= bnbPrice
                    let minimumPrice = trade.minimumPrice.value * bnbPrice
                    let maximumPrice = trade.maximumPrice.value * bnbPrice

                    trade.quotePrice = quotePrice
                    trade.openPrice = "\(openPrice)"
                    trade.closePrice = "\(closePrice)"
                    trade.minimumPrice = minimumPrice
                    trade.maximumPrice = maximumPrice
                    return trade
                } else {
                    return trade
                }
            }
        }
        .reversed()
        return Array(dexTrades)
    }

    private func setupPrice(info: TokenInfo?) {
        let dayPriceChange = info?.dayPriceChange ?? 0
        let dif = dayPriceChange > 0
        dayPriceChangeLabel.text = dayPriceChange == 0 ? "" : "\(dif ? "+" : "")\(info?.dayPriceChange?.percentWithSeparator ?? "") %"
        let quotePrice = info?.usdtPrice ?? 0
        let power = quotePrice.power
        if power != "" {
            self.fullPrice.text = "\(quotePrice.fullFormattedWithSeparator) $"
        } else {
            fullPrice.text = ""
        }
        let endPrice = quotePrice.beginPriceString
        if quotePrice > 1 {
            self.priceLabel.text = quotePrice.percentWithSeparator + " $"
        } else {
            if quotePrice > 0.00001 {
                self.priceLabel.text = quotePrice.begin5PriceString + " $"
            } else {
                self.priceLabel.text = endPrice + " $"
            }
        }
        let usdtPrice = info?.priceInBnb.value ?? 0
        dollarPrice.attributedText = usdtPrice.toBNBPriceLower
        self.baseCurrencyLabel.text = info?.symbol
        self.transactionsCollectionView.symbol = info?.symbol ?? ""
        if let pref = info?.symbol?.prefix(3) {
            nameLabel.text = "\(pref)"
        }
        self.powerLabel.text = power
        var supply = info?.supply.value ?? 0
        if supply > 100000000 {
            supply /= 1000000
            totalSupplyLabel.text = supply == 0 ? "-" : "\(supply.witoutDecimals) mln."
        } else {
            totalSupplyLabel.text = supply == 0 ? "-" : "\(supply.witoutDecimals)"
        }
        marketCapLabel.text = "\(info?.marketCap?.witoutDecimals ?? "") $"
        navigationItem.title = self.baseCurrencyLabel.text
        if let liq = info?.liquidityInUsdt {
            let attributed = NSMutableAttributedString(string: "\(liq.formattedWithSeparator) $", attributes: [:])
            attributed.append(NSAttributedString(string: "\n\(info?.liquidityInBnb?.formattedWithSeparator ?? "") BNB", attributes: [.font: UIFont.systemFont(ofSize: 9, weight: .medium)]))
            liqudityLabel.attributedText = attributed
        }
        let dayVolumeChange = info?.dayVolumeChange.value ?? 0
        let isVolumeUp = dayVolumeChange >= 0
        volumeChangeLabel.text = dayVolumeChange == 0 ? "-" : "\(isVolumeUp ? "+" : "")\(dayVolumeChange.percentWithSeparator) %"
    }

    private func relayoutChart() {
        guard isViewLoaded else { return }
        let lowestVisibleX = chartView.lowestVisibleX
        dashedView.isPortrait = isPortrait
        infoView.isHidden = !isPortrait
        if isPortrait {
            moreOptionsTopConstraint.constant = 0
            rangeTopConstraint.constant = 8
            rangeLeadingConstraint.constant = 16
            selectorCollectionView.isHidden = devWalletAdress == nil
            transactionsCollectionView.isHidden = false
            navigationController?.setNavigationBarHidden(false, animated: true)
            chartContainerView.isHidden = false
            let safeArea = (tabBarController?.view.safeAreaInsets.left ?? 0) + (tabBarController?.view.safeAreaInsets.right ?? 0)
            chartHeightConstraint.constant = min(UIScreen.main.bounds.width - safeArea - 360, 354)
            self.transactionsHeightConstraint.constant = self.transactionsCollectionView.totalHeight
            scrollView.isScrollEnabled = true
        } else {
            moreOptionsTopConstraint.constant = 8
            rangeTopConstraint.constant = 16
            rangeLeadingConstraint.constant = 0
            selectorCollectionView.isHidden = true
            scrollDownButton.isHidden = true
            transactionsCollectionView.isHidden = true
            navigationController?.setNavigationBarHidden(true, animated: true)
            chartHeightConstraint.constant = view.frame.width - 16 - rangeView.frame.height
            self.transactionsHeightConstraint.constant = 0
            scrollView.isScrollEnabled = false
        }
        dashedView.highlitedYView.isHidden = true
        showTopView(with: nil, isHidden: true)
        dashedView.centerPoint = .zero

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }

        chartView.highlightValue(nil)
        dismissInfoViews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.chartView.moveViewToX(lowestVisibleX)
            self.adjustMaxMin()
            self.chartView.notifyDataSetChanged()
            self.transactionsCollectionView.collectionViewLayout.invalidateLayout()
            self.transactionsCollectionView.reloadData()
            self.transactionsCollectionView.setNeedsLayout()
            self.transactionsCollectionView.layoutIfNeeded()
        })
    }

    @objc private func showAllTransactions() {
        let controller = AllTransactionsController(address: address, symbol: tokenPrice?.symbol ?? "")
        allTransactionsController = controller
        navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func watchOutClosePressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.watchOutView.transform = CGAffineTransform(translationX: 0, y: 400)
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.watchOutView.isHidden = true
            }
        }
    }
    
    func updateChartData() {
        chartView.minOffset = 0
        chartView.autoScaleMinMaxEnabled = true
        chartView.rightAxis.drawZeroLineEnabled = false
        chartView.drawGridBackgroundEnabled = false
        self.chartView.legend.drawInside = false
        let trades = dexTrades
        guard !trades.isEmpty else {
            chartContainerView.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            return
        }
        let entries = trades.enumerated().compactMap { valueAndI -> DexCandleChartDataEntry in
            return .init(x: Double(valueAndI.offset), trade: valueAndI.element)

        }
        let dates: [Date] = trades.map {
            return DateFormatterBuilder.dateFormatter(.iso8601Z, timeZone: .utc).date(from: $0.timeInterval?.minute ?? "") ?? .init()
        }
        self.dates = dates
        barChartView.setChart(
            dataPoints: dates.map { $0.string(.HHmm) },
            values: trades.compactMap {
                let isUp = ($0.openPrice?.toDouble() ?? 0) < ($0.closePrice?.toDouble() ?? 0)
                return (isUp, $0.tradeAmount.value)
            }
        )
        baseLineChartView.setup(with: dexTrades, dates: dates)
        baseLineChartView.setup(filled: chartType == .lineFilled)
        chartView.minOffset = 8
        self.chartView.xAxis.valueFormatter = ChartDateFormatter(
            elements: dates,
            rangeType: chartRange
        )
        self.chartView.rightAxis.valueFormatter = ChartDoubleFormatter()
        let set1 = CandleChartDataSet(entries: entries, label: "")
        
        set1.axisDependency = .right
        set1.drawIconsEnabled = false
        set1.shadowColorSameAsCandle = true
        set1.shadowWidth = 1.5
        set1.formLineWidth = 2
        set1.highlightLineWidth = 1
        set1.decreasingColor = chartType == .candle ? .mainRed : .clear
        set1.decreasingFilled = true
        set1.increasingColor = chartType == .candle ? .mainGreen : .clear
        set1.increasingFilled = true
        set1.highlightLineWidth = 1
        set1.highlightColor = UIColor.white.withAlphaComponent(0.75)
        let data = CandleChartData(dataSet: set1)
        data.setDrawValues(false)
        chartView.data = data
        chartView.rightAxis.drawAxisLineEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = true
        chartView.rightAxis.drawZeroLineEnabled = false
        chartView.rightAxis.drawLimitLinesBehindDataEnabled = false
        if entries.count < 30 {
            chartView.setVisibleXRange(minXRange: 20, maxXRange: 30)
        } else {
            chartView.setVisibleXRange(minXRange: 30, maxXRange: Double(entries.count))
        }
        chartView.highlightPerDragEnabled = false
        initialAxisMax = self.chartView.rightAxis.axisMaximum
        chartView.xAxis.yOffset = 70
        chartView.xAxis.drawGridLinesEnabled = true
        chartView.xAxis.gridColor = UIColor.white.withAlphaComponent(0.15)
        chartView.rightAxis.drawGridLinesEnabled = true
        chartView.rightAxis.gridColor = UIColor.white.withAlphaComponent(0.15)
        self.chartView.xAxis.axisLineColor = UIColor.white.withAlphaComponent(0.15)
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.rightAxis.maxWidth = 100
        chartView.rightAxis.minWidth = 100
        chartView.scaleYEnabled = false
        // Вычислять
        chartView.zoom(scaleX: 10, scaleY: 1, xValue: 0, yValue: 0, axis: .right)
        if !entries.isEmpty {
            chartView.moveViewToX(Double(entries.count - 1))
            self.adjustMaxMin()
            self.chartView.notifyDataSetChanged()
        }
    }

    func loadMoreData(trades: [DexTrade], offset: Int) { // TODO
        chartView.clear()
        chartView.clearValues()
        chartView.clearAllViewportJobs()

        guard !trades.isEmpty else {
            // TODO Handle
            return
        }
        let entries = trades.enumerated().compactMap { valueAndI -> DexCandleChartDataEntry in
            return .init(x: Double(valueAndI.offset), trade: valueAndI.element)

        }
        let dates: [Date] = trades.map {
            return DateFormatterBuilder.dateFormatter(.iso8601Z, timeZone: .utc).date(from: $0.timeInterval?.minute ?? "") ?? .init()
        }
        self.dates = dates
        barChartView.setChart(
            dataPoints: dates.map { $0.string(.HHmm) },
            values: trades.compactMap {
                let isUp = ($0.openPrice ?? "") < ($0.closePrice ?? "")
                return (isUp, $0.tradeAmount.value)
            }
        )
        baseLineChartView.setup(with: dexTrades, dates: dates)
        baseLineChartView.setup(filled: chartType == .lineFilled)

        self.chartView.xAxis.valueFormatter = ChartDateFormatter(
            elements: dates,
            rangeType: chartRange
        )
        self.chartView.rightAxis.valueFormatter = ChartDoubleFormatter()
        let set1 = CandleChartDataSet(entries: entries, label: "")

        set1.axisDependency = .right
        set1.drawIconsEnabled = false
        set1.shadowColorSameAsCandle = true
        set1.shadowWidth = 1.5
        set1.formLineWidth = 2
        set1.highlightLineWidth = 1
        set1.decreasingColor = chartType == .candle ? .mainRed : .clear
        set1.decreasingFilled = true
        set1.increasingColor = chartType == .candle ? .mainGreen : .clear
        set1.increasingFilled = true
        set1.highlightLineWidth = 1
        set1.highlightColor = UIColor.white.withAlphaComponent(0.75)
        let data = CandleChartData(dataSet: set1)
        data.setDrawValues(false)
        chartView.data = data
        chartView.setVisibleXRange(minXRange: 30, maxXRange: Double(entries.count) / 3)
        chartView.zoom(scaleX: currentScaleX, scaleY: 1, xValue: 4, yValue: 0, axis: .right)

        if !entries.isEmpty {
            chartView.moveViewToX(Double(offset))
            self.adjustMaxMin()
            self.chartView.notifyDataSetChanged()
            self.chartView.setNeedsDisplay()
        }
    }

    private func enableChartGestures(isEnabled: Bool) {
        chartView.gestureRecognizers?.forEach {
            $0.isEnabled = isEnabled
        }
    }

    // MARK: - Actions

    @IBAction func expandPressed(_ sender: Any) {
        if !isPortrait {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        } else {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        }
    }

    @IBAction func chartPriceTypeChanged(_ sender: UIButton) {
        switch priceType {
        case .bnb:
            priceType = .bnbBUSD
        case .bnbBUSD:
            priceType = .bnb
        }
        switch priceType {
        case .bnb:
            sender.setTitle("BNB", for: .normal)
        case .bnbBUSD:
            sender.setTitle("BNB/BUSD", for: .normal)
        }
        self.dexTrades = prepareDexTrades(address: address, type: priceType)
        self.updateChartData()
    }
    
    @IBAction func moreOptionsPressed(_ sender: Any) {
        optionsView.setIsShown(!optionsView.isShown)
    }

    @IBAction func chartTypeSelected(_ sender: UIButton) {
        optionsView.setIsShown(!optionsView.isShown)
        chartType = ChartType(rawValue: sender.tag) ?? .candle
        switch chartType {
        case .line, .lineFilled:
            if let set = chartView.data?.dataSets.first as? CandleChartDataSet {
                set.increasingColor = .clear
                set.decreasingColor = .clear
                chartView.notifyDataSetChanged()
            }

            baseLineChartView.isHidden = false
            baseLineChartView.setup(filled: chartType == .lineFilled)
            baseLineChartView.animate(xAxisDuration: 1.0)
        case .candle:
            if let set = chartView.data?.dataSets.first as? CandleChartDataSet {
                set.increasingColor = .mainGreen
                set.decreasingColor = .mainRed
                chartView.notifyDataSetChanged()
            }
            chartView.animate(xAxisDuration: 1.0)
            baseLineChartView.isHidden = true
        }
    }


    @objc private func changeChartRange() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            chartRange = ._1m
        case 1:
            chartRange = ._15m
        case 2:
            chartRange = ._1h
        case 3:
            chartRange = ._4h
        case 4:
            chartRange = ._1d
        default:
            break
        }
        viewModel.rangeType = chartRange
        loadChart(animateNewResults: true)
    }

    @IBAction func holdersPressed(_ sender: Any) {
        let url = "https://bscscan.com/token/\(address)#balances"
        let web = WebController(url: URL(string: url)!, title: baseCurrencyLabel.text ?? "")
        let vc = UINavigationController(rootViewController: web)
        present(vc, animated: true, completion: nil)
    }

    @IBAction func transactionsPressed(_ sender: Any) {
        let url = "https://bscscan.com/txs?a=\(address)"
        let web = WebController(url: URL(string: url)!, title: baseCurrencyLabel.text ?? "")
        let vc = UINavigationController(rootViewController: web)
        present(vc, animated: true, completion: nil)
    }

    @IBAction func contractPressed(_ sender: Any) {
        let url = "https://bscscan.com/token/\(address)"
        let web = WebController(url: URL(string: url)!, title: baseCurrencyLabel.text ?? "")
        let vc = UINavigationController(rootViewController: web)
        present(vc, animated: true, completion: nil)
    }
    
}

extension ChartController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResultsController.clearResults()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        if !searchText.isEmpty && !SearchService.shared.searches.contains(searchText) {
            SearchService.shared.searches.append(searchText)
        }
    }
}

extension ChartController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchResultsController.onUpdateSearchBar = { [weak self] search in
            self?.search.searchBar.text = search
        }
        searchResultsController.isLoading = false
        search.searchResultsController?.view.isHidden = false
        NSObject.cancelPreviousPerformRequests(
                withTarget: self,
                selector: #selector(updateSearchFieldText),
                object: searchController
        )
        perform(
            #selector(updateSearchFieldText),
            with: searchController,
            afterDelay: 0.5
        )
    }

    @objc func updateSearchFieldText(for searchController: UISearchController) {
        guard let key = searchController.searchBar.text else {
            return
        }
        searchResultsController.searchQuery = key
    }
}

class ChartDateFormatter: IAxisValueFormatter {

    var elements: [Date]
    var rangeType: ChartRange

    init(elements: [Date], rangeType: ChartRange) {
        self.elements = elements
        self.rangeType = rangeType
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        guard index >= 0 && index < elements.count else { return "" }
        switch rangeType {
        case ._1m, ._15m, ._1h:
            let hhMM = elements[index].string(.HHmm, timeZone: .current) // TODO!
            let ddMM = elements[index].string(.dMMM, timeZone: .current) // TODO!
            return index % 6 == 0 ? hhMM + "\n" + ddMM : hhMM
        case ._4h:
            let hhMM = elements[index].string(.HHmm, timeZone: .current) // TODO!
            let ddMM = elements[index].string(.dMMM, timeZone: .current) // TODO!
            return hhMM + "\n" + ddMM
        case ._1d:
            return elements[index].string(.dMMM, timeZone: .current)
        }
    }
}

class ChartDoubleFormatter: IAxisValueFormatter {

    private let formatter = NumberFormatter()

    init() {
        formatter.maximumFractionDigits = 13
        formatter.minimumFractionDigits = 13
        formatter.numberStyle = .decimal
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let number = NSNumber(value: value)
        return formatter.string(from: number) ?? ""
    }
}

extension ChartController: ChartViewDelegate {

    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        currentScaleX = self.chartView.scaleX
        baseLineChartView.zoomToCenter(scaleX: scaleX, scaleY: scaleY)
        barChartView.zoomToCenter(scaleX: scaleX, scaleY: scaleY)
        adjustMaxMin()

        if !chartTopViewIsHidden && longGesture.state == .possible {
            showTopView(with: nil, isHidden: true)
            dashedView.centerPoint = .zero
        }
        dashedView.highlitedYView.isHidden = true
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        dashedView.highlitedYView.isHidden = true
        if !chartTopViewIsHidden && longGesture.state == .possible {
            showTopView(with: nil, isHidden: true)
            dashedView.centerPoint = .zero
        }
        adjustMaxMin()
        if self.chartView.lowestVisibleX <= -10 {
            loadMoreChart()
        }
    }

    func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        adjustMaxMin()
    }

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let tradeEntry = entry as? DexCandleChartDataEntry else { return }

        let date = dates[Int(highlight.x)].string(.dMMMMHHmm)
        dashedView.hightliteYValue(
            isGreen: true,
            date: date,
            price: "",
            point: CGPoint(x: highlight.xPx, y: highlight.yPx)
        )

        if isPortrait {
            if currentDetailView != nil {
                currentDetailView?.setup(address: address, trade: tradeEntry.trade, chartRange: chartRange, symbol: tokenPrice?.symbol ?? "")
            } else {
                currentDetailView = CandleDetailView.show(
                    in: tabBarController!.view,
                    address: address, trade: tradeEntry.trade, chartRange: chartRange, symbol: tokenPrice?.symbol ?? ""
                )
            }
        } else {
            if horizontalCurrentDetailView != nil {
                horizontalCurrentDetailView?.setup(address: address, trade: tradeEntry.trade, chartRange: chartRange, symbol: tokenPrice?.symbol ?? "")
            } else {
                horizontalCurrentDetailView = CandleDetailHorizontalView.show(
                    in: tabBarController!.view,
                    address: address, trade: tradeEntry.trade, chartRange: chartRange, symbol: tokenPrice?.symbol ?? ""
                )
            }
        }

        currentDetailView?.onClose = { [weak self] in
            chartView.highlightValue(nil)
            self?.currentDetailView = nil
            self?.horizontalCurrentDetailView = nil
            self?.dashedView.dehightliteYValue()
        }

        horizontalCurrentDetailView?.onClose = { [weak self] in
            chartView.highlightValue(nil)
            self?.currentDetailView = nil
            self?.horizontalCurrentDetailView = nil
            self?.dashedView.dehightliteYValue()
        }
    }

    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        dismissInfoViews()
    }

    private func dismissInfoViews() {
        currentDetailView?.close()
        currentDetailView = nil
        dashedView.dehightliteYValue()
        horizontalCurrentDetailView?.close()
        horizontalCurrentDetailView = nil
    }

    private func adjustMaxMin() {
        baseLineChartView.moveViewToX(chartView.lowestVisibleX)
        baseLineChartView.adjustMaxMin()
        barChartView.moveViewToX(chartView.lowestVisibleX)
        barChartView.adjustMaxMin()
        
        let x1 = Int(self.chartView.lowestVisibleX)
        let x2 = Int(self.chartView.highestVisibleX)
        let elements = dexTrades
        guard x1 >= 0 && x2 <= elements.count else {
            return
        }
        let max = elements[(x1..<x2)]
            .sorted(by: { $0.highestPrice > $1.highestPrice })
            .first?.highestPrice ?? 0

        let min = elements[(x1..<x2)]
            .sorted(by: { $0.lowestPrice < $1.lowestPrice })
            .first?.lowestPrice ?? 0

        if min != 0 && max != 0 && max != self.chartView.rightAxis.axisMaximum {
                self.chartView.rightAxis.axisMaximum = max
            }
            if min != 0 && max != 0 && min != self.chartView.rightAxis.axisMinimum {
                self.chartView.rightAxis.axisMinimum = min
        }
    }
}

//extension ChartController: UIGestureRecognizerDelegate {


//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if gestureRecognizer.view == scrollView {
//            print("here")
//        }
//        if gestureRecognizer is UILongPressGestureRecognizer {
//            if let pan = chartView.gestureRecognizers?.first(where: { $0 is UIPanGestureRecognizer }) as? UIPanGestureRecognizer, pan.view != self.scrollView {
//                if pan.state.rawValue == 0 {
//                    enableChartGestures(isEnabled: false)
//                    return true
//                } else {
//                    return false
//                }
//            }
//        }
//        return true
//    }
//}


extension String {
    func toDouble() -> Double {
        return Double(self) ?? 0
    }
}

extension UIViewController {
    var isPortrait: Bool {
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown:
            return true
        case .landscapeLeft, .landscapeRight:
            return false
        default: // unknown or faceUp or faceDown
            guard let window = self.view.window else { return true }
            return window.frame.size.width < window.frame.size.height
        }
    }
}

class DexCandleChartDataEntry: CandleChartDataEntry {
    let trade: DexTrade

    init(x: Double, trade: DexTrade) {
        let high = trade.maximumPrice.value
        let low = trade.minimumPrice.value
        let open = Double(trade.openPrice ?? "0").value
        let close = Double(trade.closePrice ?? "0").value
        self.trade = trade
        super.init(
            x: x,
            shadowH: high,
            shadowL: low,
            open: open,
            close: close
        )
    }

    required init() {
        fatalError("init() has not been implemented")
    }
}

extension Double {
    // REMOVE
    var prettyString: String {
        let number = NSNumber(value: self)
        let string = "\(number.decimalValue)"
        if let index = string.firstIndex(where: { $0 != "0" && $0 != "." }) {
            return "\(string.prefix(string.count - index.distance(in: string)))"
        } else {
            return string
        }
    }

    var beginPriceString: String {
        let string = "\(self)"
        if let index = string.firstIndex(where: { $0 == "." }) {
            return "\(string.prefix(index.distance(in: string) + 4))"
        } else {
            return string
        }
    }

    var begin3PriceString: String {
        let string = "\(self ?? 0)"
        if let index = string.firstIndex(where: { $0 == "." }) {
            return "\(string.prefix(index.distance(in: string) + 3))"
        } else {
            return string
        }
    }

    var begin5PriceString: String {
        let string = "\(self ?? 0)"
        if let index = string.firstIndex(where: { $0 == "." }) {
            return "\(string.prefix(index.distance(in: string) + 5))"
        } else {
            return string
        }
    }

    var power: String {
        let string = "\(self ?? 0)"
        if let index = string.firstIndex(where: { $0 == "e" || $0 == "E" }) {
            let string = "\(string.suffix(string.count - index.distance(in: string) - 1))"
            let power = Int(string.replacingOccurrences(of: "+-", with: ""))
            if let power1 = power {
                return "\(power1)"
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
}

extension Optional where Wrapped == Double {
    var value: Double {
        return self ?? 0
    }

    var prettyString: String {
        let number = NSNumber(value: value)
        let string = "\(number.decimalValue)"
        if let index = string.firstIndex(where: { $0 != "0" && $0 != "." }) {
            return "\(string.prefix(string.count - index.distance(in: string)))"
        } else {
            return string
        }
    }

    var power: String {
        let string = "\(self ?? 0)"
        if let index = string.firstIndex(where: { $0 == "e" || $0 == "E" }) {
            let string = "\(string.suffix(string.count - index.distance(in: string) - 1))"
            let power = Int(string.replacingOccurrences(of: "+-", with: ""))
            if let power1 = power {
                return "\(power1)"
            } else {
                return ""
            }
        } else {
            return ""
        }
    }

    var beginPriceString: String {
        let string = "\(self ?? 0)"
        if let index = string.firstIndex(where: { $0 == "." }) {
            return "\(string.prefix(index.distance(in: string) + 5))"
        } else {
            return string
        }
    }

    var begin3PriceString: String {
        let string = "\(self ?? 0)"
        if let index = string.firstIndex(where: { $0 == "." }) {
            return "\(string.prefix(index.distance(in: string) + 3))"
        } else {
            return string
        }
    }
}

extension StringProtocol {
    func distance(of element: Element) -> Int? { firstIndex(of: element)?.distance(in: self) }
    func distance<S: StringProtocol>(of string: S) -> Int? { range(of: string)?.lowerBound.distance(in: self) }
}

extension Collection {
    func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}

extension String.Index {
    func distance<S: StringProtocol>(in string: S) -> Int { string.distance(to: self) }
}

extension UIViewController {
    var safeLength: CGFloat {
        return (tabBarController?.view.safeAreaInsets.top ?? 0) + (tabBarController?.view.safeAreaInsets.bottom ?? 0)
    }
}
