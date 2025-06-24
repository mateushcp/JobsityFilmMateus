//
//  SearchViewController.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import UIKit

class SearchViewController: UIViewController {
    private let viewModel: ShowListViewModel
    private lazy var contentView = SearchView()
    private lazy var dataSource = makeDataSource()

    init(viewModel: ShowListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate    = self
        contentView.delegate  = self
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.collectionView.register(
            ShowCell.self,
            forCellWithReuseIdentifier: ShowCell.reuseID
        )
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = dataSource
    }

    private func makeDataSource() -> UICollectionViewDiffableDataSource<Int, Show> {
        UICollectionViewDiffableDataSource(
            collectionView: contentView.collectionView) { collectionView, idxPath, show in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ShowCell.reuseID,
                    for: idxPath) as? ShowCell
                else { return UICollectionViewCell() }
                cell.configure(with: show)
                return cell
            }
    }

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Show>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.shows)
        dataSource.apply(snapshot, animatingDifferences: true)
        contentView.emptyStateLabel.isHidden = !viewModel.shows.isEmpty
    }
}

extension SearchViewController: ShowListViewModelDelegate {
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

extension SearchViewController: SearchViewDelegate {
    func searchView(_ view: SearchView, didSearch text: String) {
        guard !text.isEmpty else {
            viewModel.shows.removeAll()
            reloadData()
            return
        }
        viewModel.search(text)
    }
    func searchView(_ view: SearchView, didSelectItemAt index: Int) {
        let show = viewModel.show(at: index)
        let viewModel = ShowDetailViewModel(showId: show.id, service: viewModel.service)
        let viewController = ShowDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        contentView.delegate?.searchView(
            contentView,
            didSelectItemAt: indexPath.item
        )
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // contentView.delegate?.searchViewDidRequestNextPage(contentView)
    }
}
