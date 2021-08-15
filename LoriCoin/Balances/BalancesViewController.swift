//
//  BalancesViewController.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 7/22/21.
//

import UIKit

enum NetworkRPC {
    case smartChain

    var url: URL {
        switch self {
        case .smartChain:
            return URL(string: "https://bsc-dataseed.binance.org/")!
        }
    }
}

struct AmountAndToken {
    let info: TokenInfo?
    let amount: Double?
}

class BalancesViewController: UIViewController {

    enum Section {
        case header
        case bnbToken(Double)
        case token(TokenInfo)
        case addTokens
    }

    @IBOutlet weak var tableView: UITableView!

    private let service = EthereumNodeService()
    private var addesses: [String] = [Constants.boxer]

    private var sections: [Section] = [.header]
    private var bnbValue: Double?
    private var tokens: [TokenInfo] = []
    private var balances: [String: Double] = [:]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.titleView = NetworkView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(logout))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "wallet"), style: .plain, target: self, action: #selector(walletCheckerPressed))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UINib(nibName: "AddTokenCell", bundle: .main), forCellReuseIdentifier: "AddTokenCell")
        tableView.register(UINib(nibName: "BNBTokenCell", bundle: .main), forCellReuseIdentifier: "BNBTokenCell")
        tableView.register(UINib(nibName: "BalanceTokenCell", bundle: .main), forCellReuseIdentifier: "BalanceTokenCell")
        tableView.register(UINib(nibName: "BalanceHeaderTableViewCell", bundle: .main), forCellReuseIdentifier: "BalanceHeaderTableViewCell")
        loadBalances()
    }


    @objc private func walletCheckerPressed() {
        let controller = WalletCheckerController()
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func logout() {

    }

    private func loadBalances() {
        WalletConnectClientController.shared.balances(rpcURL: NetworkRPC.smartChain.url) { result in
            switch result {
            case .success(let value):
                self.bnbValue = value
                self.updateSections()
            default:
                break
            }
        }
        let walletAddress = "0xf98AAacF2a61EEa49C58B5C2c8655384816fCe06" // WalletConnectClientController.shared.session.walletInfo?.accounts.first ?? ""

        addesses.forEach { address in
            service.balanceOf(walletAddress: walletAddress, contractAddress: address, rpcURL: NetworkRPC.smartChain.url) { [weak self] value in
                self?.balances[address.uppercased()] = value?.toDouble()
            }

            BaseNetworkManager.shared.tokenInfo(address: address) { [weak self] result in
                switch result {
                case .success(let info):
                    self?.tokens.append(info)
                    self?.updateSections()
                default:
                    break
                }
            }
        }
    }

    private func updateSections() {
        sections = [.header]
        if let bnbValue = bnbValue {
            sections.append(.bnbToken(bnbValue))
        }
        sections.append(contentsOf: tokens.map { .token($0) })
        sections.append(.addTokens)
        tableView.reloadData()
    }
}

extension BalancesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.row] {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BalanceHeaderTableViewCell")!
            return cell
        case .bnbToken(let value):
            let cell = tableView.dequeueReusableCell(withIdentifier: "BNBTokenCell") as! BNBTokenCell
            cell.setup(with: value)
            return cell
        case .token(let token):
            let cell = tableView.dequeueReusableCell(withIdentifier: "BalanceTokenCell") as! BalanceTokenCell
            cell.setup(with: token, amount: balances[token.address?.uppercased() ?? ""] ?? 0)
            return cell
        case .addTokens:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTokenCell")!
            return cell
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
}
