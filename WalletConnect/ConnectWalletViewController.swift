//
//  ConnectWalletViewController.swift
//  Multisig
//
//  Created by Andrey Scherbovich on 12.04.21.
//  Copyright © 2021 Gnosis Ltd. All rights reserved.
//

import UIKit
import WalletConnectSwift

class ConnectWalletViewController: UITableViewController {
    private var installedWallets = WalletsDataSource.shared.installedWallets

    // technically it is possible to select several wallets but to finish connection with one of them
    private var walletPerTopic = [String: InstalledWallet]()
    // `wcDidConnectClient` happens when app eneters foreground. This parameter should throttle unexpected events
    private var waitingForSession = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Connect Wallet"

        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .background
        tableView.registerCell(DetailedCell.self)
        tableView.registerCell(BasicCell.self)
        tableView.registerHeaderFooterView(BasicHeaderView.self)
        tableView.rowHeight = DetailedCell.rowHeight

        NotificationCenter.default.addObserver(
            self, selector: #selector(walletConnectSessionCreated(_:)), name: .wcDidConnectClient, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc private func walletConnectSessionCreated(_ notification: Notification) {
        guard let session = notification.object as? Session, waitingForSession else { return }
        waitingForSession = false

        DispatchQueue.main.sync { [unowned self] in
//            _ = OwnerKeyController.importKey(session: session, installedWallet: walletPerTopic[session.url.topic]) TODO
            self.dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return installedWallets.count != 0 ? installedWallets.count : 1
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if installedWallets.count != 0 {
                let wallet = installedWallets[indexPath.row]
                return tableView.detailedCell(
                    imageUrl: nil,
                    header: wallet.name,
                    description: nil,
                    indexPath: indexPath,
                    canSelect: false,
                    placeholderImage: UIImage(named: wallet.imageName))
            } else {
                return tableView.basicCell(
                    name: "Known wallets not found", indexPath: indexPath, withDisclosure: false, canSelect: false)
            }
        } else {
            return tableView.detailedCell(
                imageUrl: nil,
                header: "Display QR Code",
                description: nil,
                indexPath: indexPath,
                canSelect: false,
                placeholderImage: UIImage(systemName: "qrcode"))
        }
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        do {
            if indexPath.section == 0 {
                guard !installedWallets.isEmpty else { return }
                let installedWallet = installedWallets[indexPath.row]
                let link = installedWallet.universalLink.isEmpty ?
                    installedWallet.scheme :
                    installedWallet.universalLink

                let (topic, connectionURL) = try WalletConnectClientController.shared.connectToWallet(link: link)
                walletPerTopic[topic] = installedWallet
                waitingForSession = true

                // we need a delay so that WalletConnectClient can send handshake request
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1300)) {
                    UIApplication.shared.open(connectionURL, options: [:], completionHandler: nil)
                }
            } else {
                let connectionURI = try WalletConnectClientController.shared.connect().absoluteString
                waitingForSession = true
                show(WalletConnectQRCodeViewController.create(code: connectionURI), sender: nil)
            }
        } catch {
            // TODO
//            App.shared.snackbar.show(
//                error: WalletError.error(description: "Could not create connection URL", error: error))
            return
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueHeaderFooterView(BasicHeaderView.self)
        view.setName(section == 0 ? "On this device" : "On other device")
        return view
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection _section: Int) -> CGFloat {
        return BasicHeaderView.headerHeight
    }
}
