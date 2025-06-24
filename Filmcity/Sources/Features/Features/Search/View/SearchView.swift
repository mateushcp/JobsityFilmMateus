//
//  SearchView.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func searchView(_ view: SearchView, didSearch text: String)
    func searchView(_ view: SearchView, didSelectItemAt index: Int)
}

class SearchView: UIView {
    weak var delegate: SearchViewDelegate?

    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Icons.search
        imageView.tintColor = Colors.purpleBase
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Buscar"
        label.font = Typography.titleXL
        label.textColor = Colors.gray100
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Encontre filmes buscando pelo título"
        label.font = Typography.bodySM
        label.textColor = Colors.gray400
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Pesquisar série"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (UIScreen.main.bounds.width - Metrics.medium * 3) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.sectionInset = UIEdgeInsets(top: Metrics.medium,
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

    let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Nenhuma pesquisa realizada"
        label.font = Typography.bodyMD
        label.textColor = Colors.gray400
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.gray100
        setupView()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    private func setupView() {
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(searchBar)
        addSubview(collectionView)
        addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Metrics.medium),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.medium),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: Metrics.small),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.leadingAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.small),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            searchBar.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: Metrics.medium),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.medium),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.medium),

            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Metrics.medium),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),

            emptyStateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        searchBar.delegate = self
    }
}

extension SearchView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.searchView(self, didSearch: searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
