//
//  DevWalletBalanceController.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/7/21.
//

import UIKit
import MaterialActivityIndicator

class WhaleTransactionsController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: MaterialActivityIndicatorView!
    private let walletAdress: String

    private var tokens: [DexTrade] = []

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
        navigationItem.title = "Whale transactions"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "closeDelivery"), style: .plain, target: self, action: #selector(backPressed))
    }

    @objc private func backPressed() {
        dismiss(animated: true, completion: nil)
    }

    private func setupUI() {

        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "WhaleTableCell", bundle: .main), forCellReuseIdentifier: "WhaleTableCell")
        tableView.delegate = self
        tableView.dataSource = self
        activityIndicator.color = .white
        activityIndicator.startAnimating()
    }

    private func loadData() {
        activityIndicator.startAnimating()
        ApolloManager.shared.whaleTransactions(address: walletAdress) { [weak self] result in
            self?.activityIndicator.stopAnimating()
            switch result {
            case .success(let eth):
                self?.tokens = eth?.ethereum?.dexTrades ?? []
                self?.tableView.reloadSections(IndexSet([0]), with: .automatic)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension WhaleTransactionsController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WhaleTableCell", for: indexPath) as! WhaleTableCell
        cell.setupUI(with: tokens[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tokens.count
    }
}

