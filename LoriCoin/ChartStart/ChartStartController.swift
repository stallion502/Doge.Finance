//
//  ChartStartController.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 7/22/21.
//

import UIKit
import Lottie

class ChartStartController: UIViewController {

    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var tgButton: UIButton!
    @IBOutlet weak var socialsBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var animationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var animationContainerView: UIView!
    private let searchResultsController = SearchViewController()
    private lazy var search = UISearchController(searchResultsController: searchResultsController)
    private var tokens: [String: TokenInfo] = [:]
    private var socials: Socials?

    private var addresses: [String] = ["0x7130d2a12b9bcbfae4f2634d864a1ee1ce3ead9c", "0xba2ae424d960c26247dd6c32edc70b295c744c43", "0x8076c74c5e3f5852037f31ff0093eeb8c8add8d3", "0x47bead2563dcbf3bf2c9407fea4dc236faba485a"]

    lazy var animationView: AnimationView = {
        let av = AnimationView()
        av.loopMode = LottieLoopMode.loop
        av.contentMode = .scaleAspectFit
        av.clipsToBounds = false
        return av
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        navigationItem.largeTitleDisplayMode = .never
        animationView.play()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animationView.stop()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Charts"
        setupUI()
    }

    private func setupUI() {
        search.searchBar.setValue("Cancel", forKey: "cancelButtonText")
        search.hidesNavigationBarDuringPresentation = true
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search by adress, symbol or name..."
        search.searchBar.barStyle = .black
        search.searchBar.delegate = self
        search.searchResultsUpdater = self
        navigationItem.searchController = search

        animationContainerView.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        FirDatabaseService.shared.getSocials { socials in
            if let socials = socials {
                self.socials = socials
                self.tgButton.isHidden = socials.tg == nil
                self.twitterButton.isHidden = socials.twitter == nil
                self.socialsBottomConstraint.constant = -12
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
        }

        let animation = Lottie.Animation.named("searchnew")
        animationView.animation = animation

        collectionView.register(UINib(nibName: "TopCollectionCell", bundle: .main), forCellWithReuseIdentifier: "TopCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        animationViewHeight.constant = min(200, UIScreen.main.bounds.height - collectionView.frame.maxY - 250)
    }

    private func loadData() {
        addresses.forEach { address in

            NetworkManager.shared.tokenInfo(address: address) { [weak self] result in
                switch result {
                case .success(let info):
                    self?.tokens[address] = info
                    self?.collectionView.reloadData()
                case .failure:
                    break
                }
            }
        }
    }

    @IBAction func tgPressed(_ sender: Any) {
        guard let url = URL(string: socials?.tg ?? "") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @IBAction func twitterPressed(_ sender: Any) {
        guard let url = URL(string: socials?.twitter ?? "") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension ChartStartController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResultsController.searchQuery = ""
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        if !searchText.isEmpty && !SearchService.shared.searches.contains(searchText) {
            SearchService.shared.searches.append(searchText)
        }
    }
}

extension ChartStartController: UISearchResultsUpdating {
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
        guard key != searchResultsController.searchQuery else { return }
        searchResultsController.searchQuery = key
    }
}

extension ChartStartController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCollectionCell", for: indexPath) as! TopCollectionCell
        cell.setup(with: tokens[addresses[indexPath.row]])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 48) / 2, height: (collectionView.frame.height - 16) / 2)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let charts = ChartController(address: addresses[indexPath.row], type: .none)
        navigationController?.pushViewController(charts, animated: true)
    }
}

