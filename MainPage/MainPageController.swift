//
//  MainPageController.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/15/21.
//

import UIKit

struct Banner: Codable {
    let image: String
    let url: String
}

enum RatingType: String {
    case new = "New and hot"
    case dayTransaction = "Day transactions"
    case dayVolume = "Day volume"
    case hourTransaction = "Hour transactions"
    case hourVolume = "Hour volume"
}

final class MainPageController: UIViewController {

    enum Section {
        case banners([Banner])
        case selector([String])
        case referal
        case header(String)
        case loader
        case token(TokenSearch)
    }

    @IBOutlet private weak var tableView: UITableView!

    private var sections: [Section] = []
    private var tokens: [TokenSearch] = []

    private var banners: [Banner] = []
    private var selectors: [String] = [
        "New and hot", "Hour transactions", "Hour volume", "Day transactions", "Day volume"
    ]

    private var rating: RatingType = .new

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Top trades"
//        if let session = WalletConnectClientController.shared.session {
//            let addressButton = UIButton(type: .system)
//            addressButton.setTitle("\(session.walletInfo?.accounts.first?.prefix(8) ?? "")", for: .normal)
//            addressButton.setTitleColor(.white, for: .normal)
//            addressButton.titleEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
//            addressButton.backgroundColor = UIColor.hex("212121")
//            addressButton.addTarget(self, action: #selector(openWallet), for: .touchUpInside)
//            addressButton.layer.cornerRadius = 8
//            addressButton.layer.borderWidth = 1
//            addressButton.layer.borderColor = UIColor.hex("979797").withAlphaComponent(0.25).cgColor
//            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addressButton)
//        } else {
//            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "connectButton")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showWalletConnect))
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSections()

        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "FavoritesCell", bundle: .main), forCellReuseIdentifier: "FavoritesCell")
        tableView.register(UINib(nibName: "BannersCarouselCell", bundle: .main), forCellReuseIdentifier: "BannersCarouselCell")
        tableView.register(UINib(nibName: "RefferalTableCell", bundle: .main), forCellReuseIdentifier: "RefferalTableCell")
        tableView.register(UINib(nibName: "TitleTableCell", bundle: .main), forCellReuseIdentifier: "TitleTableCell")
        tableView.register(UINib(nibName: "MainSelectorCell", bundle: .main), forCellReuseIdentifier: "MainSelectorCell")
        tableView.register(UINib(nibName: TokenSearchCell.reuseId, bundle: .main), forCellReuseIdentifier: TokenSearchCell.reuseId)
        tableView.register(LoaderCell.self, forCellReuseIdentifier: "LoaderCell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self

        loadbanners()
        loadData()
    }

    @objc private func openWallet() {
        tabBarController?.selectedIndex = 3
    }

    private func loadbanners() {
        FirDatabaseService.shared.getBanners { banners in
            self.banners = banners
            self.configureSections()
            self.tableView.reloadData()
        }
    }

    private func loadData() {
        tokens.removeAll()
        configureSections()
        NetworkManager.shared.tokenTopRaiting(rating: rating) { [weak self] result in
            switch result {
            case .success(let tokens):
                self?.tokens = tokens
            case .failure(let error):
                break
                // TODO Handle error
            }
            self?.configureSections()
            self?.tableView.reloadData()
        }
    }

    @objc private func showWalletConnect() {
        let controller = ConnectWalletViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

    private func configureSections() {
        if tokens.isEmpty {
            sections = [.banners(banners), .header("Pancakeswap V2 Top Tokens:"), .selector(selectors), .loader]
        } else {
            sections = [.banners(banners), .header("Pancakeswap V2 Top Tokens:"), .selector(selectors)] + tokens.map { .token($0) }
        }
    }
}

extension MainPageController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.row] {
        case .banners(let banners):
            let cell = tableView.dequeueReusableCell(withIdentifier: "BannersCarouselCell", for: indexPath) as! BannersCarouselCell
            cell.banners = banners
            return cell
        case .referal:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RefferalTableCell", for: indexPath)
            return cell
        case .header(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableCell", for: indexPath) as! TitleTableCell
            cell.mainTitleLabel.text = title
            return cell
        case .selector(let elements):
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainSelectorCell", for: indexPath) as! MainSelectorCell
            cell.elements = elements
            cell.onSelectedIndexPath = { [weak self] in
                self?.rating = RatingType(rawValue: self?.selectors[$0.row] ?? "") ?? .new
                self?.loadData()
            }
            return cell
        case .token(let search):
            let cell = tableView.dequeueReusableCell(withIdentifier: TokenSearchCell.reuseId, for: indexPath) as! TokenSearchCell
            cell.setupUI(with: search)
            return cell
        case .loader:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoaderCell", for: indexPath) as! LoaderCell
            cell.state = .loading
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.row] {
        case .referal:
            let vc = RefOnboardingController()
            present(vc, animated: true, completion: nil)
        case .token(let token):
            let chart = ChartController(address: token.address ?? "")
            navigationController?.pushViewController(chart, animated: true)
        default:
            break
        }
    }
}
