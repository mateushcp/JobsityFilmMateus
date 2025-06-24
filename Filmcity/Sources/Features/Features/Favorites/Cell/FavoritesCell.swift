//
//  FavoriteCell.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 20/06/25.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    static let reuseID = "FavoriteCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Metrics.radiusMedium
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Icons.trash.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = Colors.purpleBase
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bodySMBold
        label.textColor = Colors.white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var deleteAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        contentView.addSubview(deleteButton)
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = Colors.gray300
        setupConstraints()
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5),
            
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metrics.small),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.small),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: Metrics.small),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.small),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.small),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -Metrics.small)
        ])
    }
    
    func configure(with show: Show) {
        titleLabel.text = show.name
        if let urlString = show.image?.medium,
           let url = URL(string: urlString) {
            ImageLoader.shared.load(from: url) { [weak self] image in
                DispatchQueue.main.async { self?.posterImageView.image = image }
            }
        } else {
            posterImageView.image = Icons.slate
        }
    }
    
    @objc private func didTapDelete() {
        deleteAction?()
    }
}
