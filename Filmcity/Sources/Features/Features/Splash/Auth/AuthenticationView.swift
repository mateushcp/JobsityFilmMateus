//
//  AuthenticationView.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import UIKit

protocol AuthenticationViewDelegate: AnyObject {
    func authenticationViewDidTapBiometric(_ view: AuthenticationView)
    func authenticationView(_ view: AuthenticationView, didEnterPin pin: String)
}

final class AuthenticationView: UIView {
    weak var delegate: AuthenticationViewDelegate?

    private let backgroundView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "backgroundView"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.titleLG
        label.textColor = Colors.white
        label.text = "Olá, bem-vindo!"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bodyMD
        label.textColor = Colors.gray600
        label.text = "Desbloqueie com segurança usando Face ID ou digite seu PIN."
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let faceIdButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "faceId"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let pinTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.placeholder = "Digite seu PIN"
        textField.font = Typography.bodyMD
        textField.textColor = .white
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let submitPinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Entrar com PIN", for: .normal)
        button.titleLabel?.font = Typography.bodyMD
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let ellipse1 = UIImageView(image: UIImage(named: "Ellipse1"))
    private let ellipse2 = UIImageView(image: UIImage(named: "Ellipse2"))
    private let ellipse3 = UIImageView(image: UIImage(named: "Ellipse3"))

    private var didAnimateEllipses = false

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        layer.cornerRadius = 20
        clipsToBounds = true
        setupSubviews()
        setupConstraints()

        faceIdButton.addTarget(self, action: #selector(didTapBiometric), for: .touchUpInside)
        submitPinButton.addTarget(self, action: #selector(didTapSubmitPin), for: .touchUpInside)
        animateFaceButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil, !didAnimateEllipses else { return }
        didAnimateEllipses = true
        animateEllipses()
    }

    private func setupSubviews() {
        addSubview(backgroundView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(faceIdButton)
        addSubview(pinTextField)
        addSubview(submitPinButton)
        [ellipse1, ellipse2, ellipse3].forEach {
            $0.contentMode = .scaleAspectFit
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 62),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            faceIdButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            faceIdButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32),
            faceIdButton.widthAnchor.constraint(equalToConstant: 60),
            faceIdButton.heightAnchor.constraint(equalToConstant: 60),

            pinTextField.topAnchor.constraint(equalTo: faceIdButton.bottomAnchor, constant: 80),
            pinTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            pinTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),

            submitPinButton.topAnchor.constraint(equalTo: pinTextField.bottomAnchor, constant: 16),
            submitPinButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            ellipse1.centerXAnchor.constraint(equalTo: faceIdButton.centerXAnchor),
            ellipse1.centerYAnchor.constraint(equalTo: faceIdButton.centerYAnchor),
            ellipse2.centerXAnchor.constraint(equalTo: faceIdButton.centerXAnchor),
            ellipse2.centerYAnchor.constraint(equalTo: faceIdButton.centerYAnchor),
            ellipse3.centerXAnchor.constraint(equalTo: faceIdButton.centerXAnchor),
            ellipse3.centerYAnchor.constraint(equalTo: faceIdButton.centerYAnchor),
        ])
    }

    private func animateEllipses() {
        [ellipse3, ellipse2, ellipse1].enumerated().forEach { idx, e in
            e.alpha = 0
            UIView.animate(
                withDuration: 1.0,
                delay: Double(idx) * 0.4,
                options: [.repeat, .autoreverse],
                animations: { e.alpha = 0.15 }
            )
        }
    }

    private func animateFaceButton() {
        UIView.animate(
            withDuration: 1.2,
            delay: 0,
            options: [.repeat, .autoreverse],
            animations: { self.faceIdButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) }
        )
    }

    @objc private func didTapBiometric() {
        delegate?.authenticationViewDidTapBiometric(self)
    }

    @objc private func didTapSubmitPin() {
        guard let pin = pinTextField.text, !pin.isEmpty else { return }
        delegate?.authenticationView(self, didEnterPin: pin)
    }
}
