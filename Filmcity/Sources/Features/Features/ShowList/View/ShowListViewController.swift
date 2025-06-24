//
//  ShowListViewController.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//


import UIKit

final class ShowListViewController: UIViewController {
    private let viewModel: ShowListViewModel
    private lazy var contentView = ShowListView()
    private lazy var dataSource = makeDataSource()

    init(viewModel: ShowListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate   = self
        contentView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Populares"

        contentView.collectionView.register(
            ShowCell.self,
            forCellWithReuseIdentifier: ShowCell.reuseID
        )
        contentView.collectionView.delegate   = self
        contentView.collectionView.dataSource = dataSource

        viewModel.loadNextPage()
    }

    private func makeDataSource() -> UICollectionViewDiffableDataSource<Int, Show> {
        UICollectionViewDiffableDataSource(
            collectionView: contentView.collectionView
        ) { [weak self] collectionView, indexPath, show in
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ShowCell.reuseID,
                    for: indexPath
                ) as? ShowCell
            else {
                return UICollectionViewCell()
            }
            cell.configure(with: show)
            cell.delegate = self
            return cell
        }
    }

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Show>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.shows)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - ShowListViewModelDelegate
extension ShowListViewController: ShowListViewModelDelegate {
    func didUpdateShows() { reloadData() }
    func didFail(with error: Error) {
        let alert = UIAlertController(
            title: "Erro",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDelegate
extension ShowListViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY   = scrollView.contentOffset.y
        let threshold = scrollView.contentSize.height
                      - scrollView.frame.height
                      + Metrics.large
        if offsetY > threshold {
            viewModel.loadNextPage()
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let show = viewModel.show(at: indexPath.item)
        let detailVM = ShowDetailViewModel(showId: show.id,
                                           service: viewModel.service)
        let detailVC = ShowDetailViewController(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - ShowListViewDelegate
extension ShowListViewController: ShowListViewDelegate {
    func showListViewDidRequestNextPage(_ view: ShowListView) {
        viewModel.loadNextPage()
    }
    func showListView(_ view: ShowListView, didSearch text: String) {
        viewModel.search(text)
    }
    func showListView(_ view: ShowListView, didSelectItemAt index: Int) {
        let show = viewModel.show(at: index)
        let detailVM = ShowDetailViewModel(showId: show.id,
                                           service: viewModel.service)
        let detailVC = ShowDetailViewController(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - ShowCellDelegate
extension ShowListViewController: ShowCellDelegate {
    func showCell(_ cell: ShowCell, didToggleFavorite show: Show) {
        if FavoritesManager.shared.isFavorite(show) {
            FavoritesManager.shared.remove(show)
        } else {
            FavoritesManager.shared.add(show)
        }
    }
}
