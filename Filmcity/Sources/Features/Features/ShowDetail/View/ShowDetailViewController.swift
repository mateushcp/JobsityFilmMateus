//
//  ShowDetailViewController.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import UIKit

class ShowDetailViewController: UIViewController {
    private let viewModel: ShowDetailViewModel
    private lazy var contentView = ShowDetailView()
    
    init(viewModel: ShowDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.tableView.register(
            DetailHeader.self,
            forHeaderFooterViewReuseIdentifier: "header"
        )
        contentView.tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        contentView.tableView.dataSource = self
        contentView.tableView.delegate   = self
        contentView.tableView.rowHeight   = UITableView.automaticDimension
        
        viewModel.loadDetail()
    }
}

extension ShowDetailViewController: ShowDetailViewModelDelegate {
    func didLoadDetail() {
        contentView.tableView.reloadData()
    }
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

extension ShowDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard viewModel.show != nil else { return 0 }
        return viewModel.episodesBySeason.count + 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        guard section > 0 else { return 0 }
        return viewModel.episodesBySeason[section-1].episodes.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let episode = viewModel.episodesBySeason[indexPath.section-1].episodes[indexPath.row]
        cell.textLabel?.text = "\(episode.number). \(episode.name)"
        cell.textLabel?.font = Typography.bodyMD
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        if section == 0, let show = viewModel.show {
            if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? DetailHeader {
                header.configure(show: show)
                return header
            }
            return nil
        }
        
        let header = UITableViewHeaderFooterView()
        let seasonNumber = viewModel.episodesBySeason[section - 1].season
        header.textLabel?.text = "Season \(seasonNumber)"
        header.textLabel?.font = Typography.titleMD
        header.contentView.backgroundColor = Colors.gray200
        return header
    }
}

extension ShowDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section > 0 else { return }
        let episode = viewModel.episodesBySeason[indexPath.section-1].episodes[indexPath.row]
        let episodeViewModel = EpisodeDetailViewModel(episode: episode)
        let episodeViewController = EpisodeDetailViewController(viewModel: episodeViewModel)
        navigationController?.pushViewController(episodeViewController, animated: true)
    }
}
