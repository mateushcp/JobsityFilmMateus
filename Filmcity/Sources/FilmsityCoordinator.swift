//
//  FilmsityCoordinator.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import UIKit

protocol Coordinator {
    func start()
}

final class FilmsityCoordinator: Coordinator {
    // MARK: – Dependencies
    private let window: UIWindow
    private let service: TVMazeServiceProtocol

    // Keep reference to SplashVC so we can present modals over it
    private weak var splashVC: SplashViewController?

    init(window: UIWindow,
         service: TVMazeServiceProtocol = TVMazeService()) {
        self.window = window
        self.service = service
    }

    func start() {
        showSplash()
    }

    // MARK: – Splash Flow

    private func showSplash() {
        let splashVM = SplashViewModel()
        let vc = SplashViewController(viewModel: splashVM)
        vc.onFinished = { [weak self] in
            self?.handleSplashFinished()
        }
        splashVC = vc

        window.rootViewController = vc
        window.makeKeyAndVisible()
    }

    private func handleSplashFinished() {
        let hasPin = (KeychainHelper.standard.readPin() ?? "").isEmpty == false
        if hasPin {
            presentAuthentication()
        } else {
            presentSetPin()
        }
    }

    // MARK: – PIN Setup Flow

    private func presentSetPin() {
        guard let splash = splashVC else { return }
        let setPinVC = SetPinViewController()
        setPinVC.modalPresentationStyle = .overFullScreen
        setPinVC.modalTransitionStyle = .crossDissolve
        setPinVC.onPinCreated = { [weak self] in
            setPinVC.dismiss(animated: true) {
                self?.presentAuthentication()
            }
        }
        splash.present(setPinVC, animated: true, completion: nil)
    }

    // MARK: – Authentication Flow

    private func presentAuthentication() {
        guard let splash = splashVC else { return }
        let authVC = AuthenticationViewController()
        authVC.modalPresentationStyle = .overFullScreen
        authVC.modalTransitionStyle = .crossDissolve
        authVC.onSuccess = { [weak self] in
            self?.showMainInterface()
        }
        splash.present(authVC, animated: true, completion: nil)
    }

    // MARK: – Main Interface

    private func showMainInterface() {
        window.rootViewController = makeTabBar()
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil,
            completion: nil
        )
    }

    // MARK: – Tab Builder

    private func makeTabBar() -> UITabBarController {
        let tab = UITabBarController()
        configure(tab.tabBar)

        let showListVC = ShowListViewController(viewModel: ShowListViewModel(service: service))
        showListVC.title = "Populares"

        let searchVC = SearchViewController(viewModel: ShowListViewModel(service: service))
        searchVC.title = "Buscar"

        let favVC = FavoritesViewController()
        favVC.title = "Favoritos"

        func makeNav(root: UIViewController, title: String, icon: UIImage) -> UINavigationController {
            let nav = UINavigationController(rootViewController: root)
            nav.tabBarItem = UITabBarItem(
                title: title,
                image: icon.withRenderingMode(.alwaysOriginal).resized(to: CGSize(width: 24, height: 24)),
                selectedImage: icon.withRenderingMode(.alwaysTemplate).resized(to: CGSize(width: 24, height: 24))
            )
            return nav
        }

        tab.viewControllers = [
            makeNav(root: showListVC, title: "Populares", icon: Icons.slate),
            makeNav(root: searchVC,    title: "Buscar",    icon: Icons.search),
            makeNav(root: favVC,       title: "Favoritos", icon: Icons.bookmark)
        ]

        return tab
    }

    private func configure(_ bar: UITabBar) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Colors.gray300
        bar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            bar.scrollEdgeAppearance = appearance
        }
        bar.tintColor = Colors.purpleBase
        bar.unselectedItemTintColor = Colors.gray500
    }
}
