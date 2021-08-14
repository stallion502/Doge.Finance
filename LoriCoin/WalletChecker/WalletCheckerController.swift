//
//  WalletCheckerController.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 7/29/21.
//

import UIKit
import Lottie

class WalletCheckerController: UIViewController {

    @IBOutlet weak var pateViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var animationContainerView: UIView!
    private lazy var search = UISearchController(searchResultsController: nil)

    lazy var animationView: AnimationView = {
        let av = AnimationView()
        av.loopMode = LottieLoopMode.loop
        av.contentMode = .scaleAspectFit
        av.clipsToBounds = false
        return av
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let address = UIPasteboard.general.string, address.hasPrefix("0x") {
            pateViewBottomConstraint.constant = 12
        } else {
            pateViewBottomConstraint.constant = -100
        }

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animationView.stop()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Wallet checker"
        setupUI()
    }

    private func setupUI() {
        search.searchBar.setValue("Cancel", forKey: "cancelButtonText")
        search.hidesNavigationBarDuringPresentation = false
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search wallet by wallet address..."
        search.searchBar.barStyle = .black
        search.searchBar.delegate = self
        navigationItem.searchController = search

        animationContainerView.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        let animation = Lottie.Animation.named("searchnew")
        animationView.animation = animation
    }

    @IBAction func pastePressed(_ sender: Any) {
        guard let address = UIPasteboard.general.string, address.hasPrefix("0x") else { return }
        let controller = WalletCheckerDetail(address: address)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension WalletCheckerController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchResultsController.searchQuery = ""
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let address = searchBar.text, address.hasPrefix("0x") else { return }
        searchBar.resignFirstResponder()
        let controller = WalletCheckerDetail(address: address)
        navigationController?.pushViewController(controller, animated: true)
    }
}
