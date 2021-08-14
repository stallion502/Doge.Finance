//
//  DevWalletBalanceController.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/7/21.
//

import UIKit
import MaterialActivityIndicator

class DevWalletBalanceController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: MaterialActivityIndicatorView!
    private let walletAdress: String

    private var tokens: [TokenSearch] = []

    init(walletAdress: String) {
        self.walletAdress = walletAdress
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        navigationItem.title = "Wallet balance"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "closeDelivery"), style: .plain, target: self, action: #selector(backPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "bscpdf")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(openBSCSCan))
    }

    @objc private func openBSCSCan() {
        guard let url = URL(string: "https://bscscan.com/address/\(walletAdress)") else { return }
        let web = WebController(url: url, title: "Dev wallet")
        let vc = UINavigationController(rootViewController: web)
        present(vc, animated: true, completion: nil)
    }

    @objc private func backPressed() {
        dismiss(animated: true, completion: nil)
    }

    private func setupUI() {

        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: TokenSearchCell.reuseId, bundle: .main), forCellReuseIdentifier: TokenSearchCell.reuseId)
        tableView.delegate = self
        tableView.dataSource = self
        activityIndicator.color = .white
        activityIndicator.startAnimating()
    }

    private func loadData() {
        activityIndicator.startAnimating()
        ApolloManager.shared.walletBalance(address: walletAdress) { [weak self] result in
            self?.activityIndicator.stopAnimating()
            switch result {
            case .success(let eth):
                self?.tokens = eth?.ethereum?.address?.first?.balances?.map { $0.toSearchToken() } ?? []
                self?.tableView.reloadSections(IndexSet([0]), with: .automatic)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension DevWalletBalanceController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TokenSearchCell.reuseId, for: indexPath) as! TokenSearchCell
        cell.setupUI(with: tokens[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tokens.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let address = tokens[indexPath.row].address else { return }
        let controller = ChartController(address: address)
        navigationController?.pushViewController(controller, animated: true)
    }
}

