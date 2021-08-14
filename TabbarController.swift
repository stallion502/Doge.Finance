//
//  TabbarController.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 6/29/21.
//

import UIKit

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [
            mainViewController(),
            chartsViewController(),
            favoritesViewController(),
            walletCheckerController(),
        ]

        tabBar.barTintColor = .mainBackgorund
        tabBar.tintColor = .white
    }

    private func mainViewController() -> UIViewController {
        let controller = MainPageController()
        controller.tabBarItem = UITabBarItem(
            title: "Main",
            image: UIImage(named: "home"),
            selectedImage: UIImage(named: "home")
        )
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.barTintColor = .mainBackgorund
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }

    private func chartsViewController() -> UIViewController {
        let controller = ChartStartController()
        controller.tabBarItem = UITabBarItem(
            title: "Charts",
            image: UIImage(named: "charts"),
            selectedImage: UIImage(named: "charts")
        )
        controller.navigationItem.title = "Charts"
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.barTintColor = .mainBackgorund
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationController.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        return navigationController
    }

    private func favoritesViewController() -> UIViewController {
        let controller = FavoritesController()
        controller.tabBarItem = UITabBarItem(
            title: "Favourites",
            image: UIImage(named: "heart"),
            selectedImage: UIImage(named: "heart")
        )
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.barTintColor = .mainBackgorund
        navigationController.navigationBar.tintColor = .white
        return navigationController
    }

    private func walletController() -> UIViewController {
        let controller = BalancesViewController()
        controller.tabBarItem = UITabBarItem(
            title: "Wallet",
            image: UIImage(named: "wallet"),
            selectedImage: UIImage(named: "wallet")
        )
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.barTintColor = .mainBackgorund
        navigationController.navigationBar.tintColor = .white
        return navigationController
    }

    private func walletCheckerController() -> UIViewController {
        let controller = WalletCheckerController()
        controller.tabBarItem = UITabBarItem(
            title: "Checker",
            image: UIImage(named: "wallet"),
            selectedImage: UIImage(named: "wallet")
        )
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.barTintColor = .mainBackgorund
        navigationController.navigationBar.tintColor = .white
        return navigationController
    }
}
