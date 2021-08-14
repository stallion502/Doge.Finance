//
//  AppDelegate.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 6/28/21.
//

import UIKit
import Firebase
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let configuration = YMMYandexMetricaConfiguration.init(apiKey: "911fb408-ca79-4976-aa08-41a62d820705")
        YMMYandexMetrica.activate(with: configuration!)


        window = UIWindow(frame: UIScreen.main.bounds)
        if  UserDefaults.standard.bool(forKey: "onboarding") {
            window?.rootViewController = TabbarController()
        } else {
            window?.rootViewController = OnboardingViewController() // TabbarController()
        }
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        BaseSocketManager.shared.restartSubscriptons()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        BaseSocketManager.shared.stopSubscription()
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            if let tabbar = window?.rootViewController as? TabbarController, let nav = tabbar.selectedViewController as? UINavigationController, let chart = nav.viewControllers.last as? ChartController {
                return chart.allowRotation ? .all : .portrait
            }
        }
        return .portrait
    }
}
