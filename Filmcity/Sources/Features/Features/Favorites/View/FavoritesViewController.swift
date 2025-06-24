//
//  FavoritesViewController.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import UIKit

class FavoritesViewController: UIViewController {
    private let viewModel = FavoritesViewModel()
    private lazy var contentView = FavoritesView()
    private lazy var dataSource = makeDataSource()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favoritos"
        
        contentView.collectionView.register(
            FavoriteCell.self,
            forCellWithReuseIdentifier: FavoriteCell.reuseID
        )
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = dataSource
        
        contentView.delegate = self
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavorites()
    }
    
    private func makeDataSource()
    -> UICollectionViewDiffableDataSource<Int, Show> {
        UICollectionViewDiffableDataSource(
            collectionView: contentView.collectionView) { collectionView, indexPath, show in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FavoriteCell.reuseID,
                    for: indexPath) as? FavoriteCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: show)
                cell.deleteAction = { [weak self] in
                    self?.viewModel.remove(at: indexPath.item)
                }
                return cell
            }
    }
    
    private func reloadData() {
        var snap = NSDiffableDataSourceSnapshot<Int, Show>()
        snap.appendSections([0])
        snap.appendItems(viewModel.favorites)
        dataSource.apply(snap, animatingDifferences: true)
        contentView.emptyStateLabel.isHidden = !viewModel.favorites.isEmpty
    }
}

// MARK: - FavoritesViewModelDelegate
extension FavoritesViewController: FavoritesViewModelDelegate {
    func favoritesDidUpdate(_ viewModel: FavoritesViewModel) {
        reloadData()
    }
}

// MARK: - FavoritesViewDelegate
extension FavoritesViewController: FavoritesViewDelegate {
    func favoritesViewDidRequestLoad(_ view: FavoritesView) {
        viewModel.loadFavorites()
    }
    func favoritesView(_ view: FavoritesView, didSelectItemAt index: Int) {
        let show = viewModel.favorites[index]
        let vieModel = ShowDetailViewModel(showId: show.id, service: TVMazeService())
        let viewController = ShowDetailViewController(viewModel: vieModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    func favoritesView(_ view: FavoritesView, didDeleteItemAt index: Int) {
        viewModel.remove(at: index)
    }
}

// MARK: - UICollectionViewDelegate
extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        contentView.delegate?.favoritesView(contentView,
                                            didSelectItemAt: indexPath.item
        )
    }
}
