//
//  FavoritesController.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/9/21.
//

import UIKit

class FavoritesController: UIViewController {

    @IBOutlet private weak var successView: SuccessView!
    @IBOutlet private weak var tableView: UITableView!
    private var favorites: [TokenInfo] = []

    private let searchResultsController = SearchViewController()
    private lazy var search = UISearchController(searchResultsController: searchResultsController)

    private var isSearchShown: Bool = false

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FavoritesService.shared.tokens = favorites
    }

    override func didMove(toParent parent: UIViewController?) {
        // TODO        removeSubscriptions()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem =
             UIBarButtonItem(
                image: UIImage(named: "search")?.withRenderingMode(.alwaysTemplate),
                style: .plain,
                target: self,
                action: #selector(showSearch)
             )
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Favorites"
        successView.play()
        favorites = FavoritesService.shared.tokens
        successView.isHidden = !favorites.isEmpty
        tableView.reloadData()
        prepareSubscriptions()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        successView.setup(model: .favorites)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "FavoritesCell", bundle: .main), forCellReuseIdentifier: "FavoritesCell")

        prepareSearch()
        prepareSubscriptions()
    }

    private func prepareSearch() {
        search.searchBar.setValue("Cancel", forKey: "cancelButtonText")
        search.hidesNavigationBarDuringPresentation = true
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search by adress, symbol or name..."
        search.searchBar.barStyle = .black
        search.searchResultsUpdater = self
    }

    private func prepareSubscriptions() {
        favorites.enumerated().forEach { el in
            if let address = el.element.address {
                BaseSocketManager.shared.subscribeOnPriceChange(
                    address: address
                ) { [weak self] token, _ in
                    self?.updateFavorite(info: token)
                }
            }
        }
    }

    private func removeSubscriptions() {
        favorites.enumerated().forEach { el in
            if let address = el.element.address {
                BaseSocketManager.shared.removeSubscription(address)
            }
        }
    }

    private func updateFavorite(info: TokenSocketModel?) {
        guard let info = info, let index = favorites.firstIndex(where: { $0.address == info.token }) else { return }
        if let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? FavoritesCell {
            cell.update(with: favorites[index], newInfo: info)
        }
        updateFavoriteModel(info: info)
    }

    private func updateFavoriteModel(info: TokenSocketModel?) {
        guard let info = info, let index = favorites.firstIndex(where: { $0.address == info.token }) else { return }
        var favorite = favorites[index]
        if let dayVolumeChange = info.dayVolumeChange, dayVolumeChange != 0 {
            favorite.dayVolumeChange = dayVolumeChange
        }
        if let dayPriceChange = info.dayPriceChange, dayPriceChange != 0 {
            favorite.dayPriceChange = dayPriceChange
        }
        if let liquidityInBnb = info.liquidityInBnb, liquidityInBnb != 0 {
            favorite.liquidityInBnb = liquidityInBnb
        }
        if let liquidityInUsdt = info.liquidityInUsdt, liquidityInUsdt != 0 {
            favorite.liquidityInUsdt = liquidityInUsdt
        }
        if let marketCap = info.marketCap, marketCap != 0 {
            favorite.marketCap = marketCap
        }
        if let priceInBnb = info.priceInBnb, priceInBnb != 0 {
            favorite.priceInBnb = priceInBnb
        }
        if let priceInUsdt = info.priceInUsdt, priceInUsdt != 0 {
            favorite.usdtPrice = priceInUsdt
        }
        favorites[index] = favorite
//        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    private func removeSubscription(for address: String) {
        BaseSocketManager.shared.removeSubscription(address)
    }

    @objc private func showSearch() {
        isSearchShown = !isSearchShown
        if isSearchShown {
            navigationItem.searchController = search
            UIView.animate(withDuration: 0.3) {
                self.navigationItem.hidesSearchBarWhenScrolling = false
                self.search.searchBar.sizeToFit()
            } completion: { _ in
                self.navigationItem.hidesSearchBarWhenScrolling = true
            }
        }
        else {
            navigationItem.searchController = nil
        }
    }
}

extension FavoritesController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
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

extension FavoritesController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! FavoritesCell
        cell.setup(with: favorites[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let address = favorites[indexPath.row].address else { return }
        let controller = ChartController(address: address)
        navigationController?.pushViewController(controller, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            FavoritesService.shared.tokens = favorites
            successView.isHidden = !favorites.isEmpty
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
