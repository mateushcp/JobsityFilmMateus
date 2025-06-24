//
//  EpisodeDetailsViewController.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import UIKit

class EpisodeDetailViewController: UIViewController {
    private let viewModel: EpisodeDetailViewModel
    private lazy var contentView = EpisodeDetailView()
    
    init(viewModel: EpisodeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episódio"
        navigationController?.navigationBar.prefersLargeTitles = false
        configureContent()
    }
    
    private func configureContent() {
        let episode = viewModel.episode
        contentView.configure(with: episode)
    }
}
