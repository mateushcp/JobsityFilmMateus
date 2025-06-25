//
//  PinViewController.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 23/06/25.
//

import UIKit

final class SetPinViewController: UIViewController {
    private lazy var setPinView: SetPinView = {
        let view = SetPinView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var onPinCreated: (() -> Void)?

    override func loadView() {
        view = UIView()
        view.backgroundColor = Colors.gray100
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(setPinView)
        NSLayoutConstraint.activate([
            setPinView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            setPinView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            setPinView.widthAnchor.constraint(equalToConstant: 300),
        ])
    }
}

extension SetPinViewController: SetPinViewDelegate {
    func setPinView(_ view: SetPinView, didTapSave pin: String, confirm: String) {
        guard !pin.isEmpty, pin == confirm else {
            let alert = UIAlertController(
                title: "Error",
                message: "PIN is empty or not matching.",
                preferredStyle: .alert
            )
            alert.addAction(.init(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        KeychainHelper.standard.savePin(pin)
        onPinCreated?()
    }
}
