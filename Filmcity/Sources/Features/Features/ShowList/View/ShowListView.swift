//
//  ShowListView.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import UIKit

protocol ShowListViewDelegate: AnyObject {
    func showListViewDidRequestNextPage(_ view: ShowListView)
    func showListView(_ view: ShowListView, didSelectItemAt index: Int)
}

class ShowListView: UIView {
    weak var delegate: ShowListViewDelegate?

    private let headerIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Icons.slate
        imageView.tintColor = Colors.purpleBase
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Populares"
        label.font = Typography.titleXL
        label.textColor = Colors.gray100
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Explore os filmes populares hoje e encontre coisas novas para assistir!"
        label.font = Typography.bodySM
        label.textColor = Colors.gray400
        label.numberOfLines = 2
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
            right: Metrics.medium)
        layout.minimumInteritemSpacing = Metrics.medium
        layout.minimumLineSpacing = Metrics.medium

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.gray100
        setupView()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    private func setupView() {
        addSubview(headerIcon)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            headerIcon.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Metrics.medium),
            headerIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.medium),
            headerIcon.widthAnchor.constraint(equalToConstant: 24),
            headerIcon.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.topAnchor.constraint(equalTo: headerIcon.bottomAnchor, constant: Metrics.small),
            titleLabel.leadingAnchor.constraint(equalTo: headerIcon.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.medium),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.small),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: Metrics.medium),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func requestNextPage() {
        delegate?.showListViewDidRequestNextPage(self)
    }
}
