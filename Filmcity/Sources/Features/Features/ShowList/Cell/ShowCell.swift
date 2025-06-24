//
//  ShowCell.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import UIKit

protocol ShowCellDelegate: AnyObject {
    func showCell(_ cell: ShowCell, didToggleFavorite show: Show)
}

final class ShowCell: UICollectionViewCell {
    static let reuseID = "ShowCell"

    // MARK: - Subviews

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Metrics.radiusMedium
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bodySMBold
        label.textColor = Colors.white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let favButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = Colors.purpleBase
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Properties

    private var currentShow: Show?
    weak var delegate: ShowCellDelegate?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = Colors.gray300
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(favButton)
        setupConstraints()
        favButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5),

            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: Metrics.small),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.small),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.small),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -Metrics.small),

            favButton.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 8),
            favButton.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -8),
            favButton.widthAnchor.constraint(equalToConstant: 24),
            favButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    // MARK: - Configuration

    func configure(with show: Show) {
        self.currentShow = show
        titleLabel.text = show.name

        if let urlString = show.image?.medium,
           let url = URL(string: urlString) {
            ImageLoader.shared.load(from: url) { [weak self] image in
                DispatchQueue.main.async {
                    self?.posterImageView.image = image
                }
            }
        } else {
            posterImageView.image = Icons.slate
        }

        updateFavoriteIcon()
    }

    private func updateFavoriteIcon() {
        guard let show = currentShow else { return }
        let isFav = FavoritesManager.shared.isFavorite(show)
        let starName = isFav ? "star.fill" : "star"
        favButton.setImage(UIImage(systemName: starName), for: .normal)
    }

    // MARK: - Actions

    @objc private func didTapFavorite() {
        guard let show = currentShow else { return }
        delegate?.showCell(self, didToggleFavorite: show)
        updateFavoriteIcon()
    }
}
