//
//  SplashViewController.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import UIKit

final class SplashViewController: UIViewController {
    private let viewModel: SplashViewModel
    private let splashView = SplashView()

    var onFinished: (() -> Void)?

    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func loadView() {
        view = splashView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
    }

    private func startAnimation() {
        // escala inicial
        splashView.triangleImageView.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        viewModel.performInitialAnimation { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.8) {
                self.splashView.triangleImageView.alpha = 1
                self.splashView.triangleImageView.transform = .identity
            } completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut) {
                    self.splashView.logoImageView.alpha = 1
                } completion: { _ in
                    self.onFinished?()
                }
            }
        }
    }
}
