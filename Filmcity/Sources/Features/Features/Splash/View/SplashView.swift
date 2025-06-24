//
//  SplashView.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import UIKit

final class SplashView: UIView {
    let triangleImageView: UIImageView = {
        let imageView = UIImageView(image: Images.splashTriangle)
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "mainLogo"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        backgroundColor = Colors.gray100
        addSubview(triangleImageView)
        addSubview(logoImageView)
        NSLayoutConstraint.activate([
            triangleImageView.topAnchor.constraint(equalTo: topAnchor),
            triangleImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            triangleImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            triangleImageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}
