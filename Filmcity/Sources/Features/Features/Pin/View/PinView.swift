//
//  PinView.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 23/06/25.
//

import UIKit

protocol SetPinViewDelegate: AnyObject {
    func setPinView(_ view: SetPinView, didTapSave pin: String, confirm: String)
}

final class SetPinView: UIView {
    weak var delegate: SetPinViewDelegate?
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Nenhum PIN cadastrado.\nPor favor, cadastre um novo PIN."
        label.font = Typography.bodyMD
        label.textColor = Colors.white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pinField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Digite seu PIN"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let confirmField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirme seu PIN"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Salvar PIN", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        backgroundColor = Colors.gray100
        layer.cornerRadius = 12
        
        addSubview(messageLabel)
        addSubview(pinField)
        addSubview(confirmField)
        addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            pinField.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
            pinField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            pinField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            confirmField.topAnchor.constraint(equalTo: pinField.bottomAnchor, constant: 16),
            confirmField.leadingAnchor.constraint(equalTo: pinField.leadingAnchor),
            confirmField.trailingAnchor.constraint(equalTo: pinField.trailingAnchor),
            
            saveButton.topAnchor.constraint(equalTo: confirmField.bottomAnchor, constant: 32),
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapSave() {
        delegate?.setPinView(self,
                             didTapSave: pinField.text ?? "",
                             confirm: confirmField.text ?? ""
        )
    }
}
