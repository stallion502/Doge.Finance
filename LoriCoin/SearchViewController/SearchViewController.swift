//
//  SearchViewController.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/6/21.
//

import UIKit
import MaterialActivityIndicator

class SearchViewController: UIViewController {

    enum Section {
        case search(TokenSearch)
        case previouSearches([String])
        case loader
    }

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var startTypingLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: MaterialActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!

    var onUpdateSearchBar: (String) -> Void = { _ in }

    private var searchResults: [TokenSearch] = []

    private var sections: [Section] {
        var sections: [Section] = searchResults.map { .search($0) } + [.loader]
        if !previousSearches.isEmpty {
            sections.insert(.previouSearches(previousSearches), at: 0)
        }
        return sections
    }

    private var offset: Int = 0
    private var size: Int = 20
    var isLoading: Bool = false
    private var allLoaded: Bool = false

    var previousSearches: [String] = []

    var searchQuery: String = "" {
        didSet {
            clearResults()
            imageView.isHidden = !searchQuery.isEmpty
            startTypingLabel.isHidden = !searchQuery.isEmpty
            loadData()
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        previousSearches = SearchService.shared.searches
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        previousSearches = SearchService.shared.searches
        setupUI()
        configureNotifications()
    }

    func clearResults() {
        offset = 0
        isLoading = false
        allLoaded = false
        searchResults.removeAll()
        tableView.reloadData()
    }

    private func setupUI() {
        
        startTypingLabel.text = "Start typing symbol / name / adress..."
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: TokenSearchCell.reuseId, bundle: .main), forCellReuseIdentifier: TokenSearchCell.reuseId)
        tableView.register(LoaderCell.self, forCellReuseIdentifier: "LoaderCell")
        tableView.register(UINib(nibName: "PreviousSearchesCell", bundle: .main), forCellReuseIdentifier: "PreviousSearchesCell")
        tableView.delegate = self
        tableView.dataSource = self
        activityIndicatorView.color = .white
        activityIndicatorView.startAnimating()
    }

    private func loadData() {
        guard !searchQuery.isEmpty && !isLoading && !allLoaded else { return }
        isLoading = true
        tableView.reloadData()
        print("search start")
//        activityIndicatorView.startAnimating()
        BaseNetworkManager.shared.tokenSearch(filter: searchQuery, take: size, skip: offset) { [weak self] result in
            self?.activityIndicatorView.stopAnimating()
            switch result {
            case .success(let searches):
                self?.searchResults = searches
                self?.offset += searches.count
                self?.isLoading = false
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    private func configureNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }

        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        tableView.contentInset = .zero
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }


    private func loadMoreData() {
        guard !searchQuery.isEmpty && !isLoading && !allLoaded else { return }
        isLoading = true
        print("search load more")
        BaseNetworkManager.shared.tokenSearch(filter: searchQuery, take: 5, skip: offset) { [weak self] result in
            switch result {
            case .success(let searches):
                self?.searchResults.append(contentsOf: searches)
                self?.searchResults = Array(Set(self?.searchResults ?? []))
                self?.offset += searches.count
                self?.allLoaded = searches.isEmpty
                self?.isLoading = false
                self?.tableView.reloadData()
            case .failure(let error):
                self?.allLoaded = true
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.row] {
        case .search(let searchResult):
            let cell = tableView.dequeueReusableCell(withIdentifier: TokenSearchCell.reuseId, for: indexPath) as! TokenSearchCell
            cell.setupUI(with: searchResult)
            return cell
        case .loader:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoaderCell", for: indexPath) as! LoaderCell
            if isLoading {
                cell.state = .loading
            } else if allLoaded {
                cell.state = .allLoaded
            } else if !searchResults.isEmpty {
                cell.state = .showMore
            }
            cell.onShowMore = { [weak self] in
                self?.loadMoreData()
            }
            return cell
        case .previouSearches(let searches):
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousSearchesCell", for: indexPath) as! PreviousSearchesCell
            cell.searches = searches
            cell.onSelectSearch = { [weak self] search in
                self?.onUpdateSearchBar(search)
                self?.searchQuery = search
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row > sections.count - 3 && !searchResults.isEmpty else { return }
        loadMoreData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch sections[indexPath.row] {
        case .search(let search):
            let controller = ChartController(address: search.address ?? "")
            guard let tab = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController, let nav = tab.selectedViewController as? UINavigationController else {
                return
            }
            nav.pushViewController(controller, animated: true)
        default:
            break
        }
    }
}
