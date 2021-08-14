//
//  WebController.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/6/21.
//

import UIKit
import WebKit

class WebController: UIViewController {

    private lazy var webKit = WKWebView(frame: view.bounds)

    private let url: URL
    private let selfTitle: String

    init(url: URL, title: String) {
        self.url = url
        selfTitle = title
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
        view.addSubview(webKit)
        webKit.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webKit.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webKit.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webKit.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        navigationItem.title = selfTitle
        webKit.load(URLRequest(url: url))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "closeDelivery"), style: .plain, target: self, action: #selector(backPressed))
    }

    @objc private func backPressed() {
        dismiss(animated: true, completion: nil)
    }
}
