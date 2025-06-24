//
//  AuthenticationViewController.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 21/06/25.
//

import UIKit

final public class AuthenticationViewController: UIViewController {
    let viewModel = AuthenticationViewModel()

    var onSuccess: (() -> Void)?

    lazy var authView: AuthenticationView = {
        let v = AuthenticationView()
        v.delegate = self
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    public override func loadView() {
        let container = UIView()
        container.backgroundColor = .clear
        view = container
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(authView)
        NSLayoutConstraint.activate([
            authView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            authView.widthAnchor.constraint(equalToConstant: 343),
            authView.heightAnchor.constraint(equalToConstant: 600)
        ])

        viewModel.onAuthenticationResult = { [weak self] success in
            guard let self = self else { return }
            if success {
                self.onSuccess?()
            } else {
                let alert = UIAlertController(
                    title: "Erro",
                    message: "Autenticação falhou. Tente novamente.",
                    preferredStyle: .alert
                )
                alert.addAction(.init(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
}

extension AuthenticationViewController: AuthenticationViewDelegate {
    func authenticationViewDidTapBiometric(_ view: AuthenticationView) {
        viewModel.authenticateWithBiometrics()
    }
    func authenticationView(_ view: AuthenticationView, didEnterPin pin: String) {
        viewModel.authenticate(withPin: pin)
    }
}
