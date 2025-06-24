//
//  FavoritesView.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import UIKit

protocol FavoritesViewDelegate: AnyObject {
  func favoritesViewDidRequestLoad(_ view: FavoritesView)
  func favoritesView(_ view: FavoritesView, didSelectItemAt index: Int)
  func favoritesView(_ view: FavoritesView, didDeleteItemAt index: Int)
}

class FavoritesView: UIView {
  weak var delegate: FavoritesViewDelegate?

  private let headerIcon: UIImageView = {
    let imageView = UIImageView()
    imageView.image = Icons.bookmark
    imageView.tintColor = Colors.purpleBase
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Favoritos"
    label.font = Typography.titleXL
    label.textColor = Colors.gray100
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.text = "Sua lista de filmes salvos"
    label.font = Typography.bodySM
    label.textColor = Colors.gray400
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let itemWidth = (UIScreen.main.bounds.width - Metrics.medium * 3) / 2
    layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
    layout.sectionInset = UIEdgeInsets(
      top: Metrics.medium,
      left: Metrics.medium,
      bottom: Metrics.medium,
      right: Metrics.medium
    )
    layout.minimumInteritemSpacing = Metrics.medium
    layout.minimumLineSpacing = Metrics.medium
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()

  let emptyStateLabel: UILabel = {
    let label = UILabel()
    label.text = "Nenhum filme salvo\nEncontre seus filmes favoritos e adicione à sua lista"
    label.font = Typography.bodyMD
    label.textColor = Colors.gray400
    label.numberOfLines = 0
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = Colors.gray100
    setupView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) not implemented")
  }

  private func setupView() {
    addSubview(headerIcon)
    addSubview(titleLabel)
    addSubview(subtitleLabel)
    addSubview(collectionView)
    addSubview(emptyStateLabel)

    NSLayoutConstraint.activate([
      headerIcon.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Metrics.medium),
      headerIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.medium),
      headerIcon.widthAnchor.constraint(equalToConstant: 24),
      headerIcon.heightAnchor.constraint(equalToConstant: 24),

      titleLabel.topAnchor.constraint(equalTo: headerIcon.bottomAnchor, constant: Metrics.small),
      titleLabel.leadingAnchor.constraint(equalTo: headerIcon.leadingAnchor),

      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.small),
      subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.medium),

      collectionView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: Metrics.medium),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),

      emptyStateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      emptyStateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      emptyStateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.medium),
      emptyStateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.medium)
    ])
  }
}
