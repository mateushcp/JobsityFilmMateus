//
//  EpisodeDetailsView.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import UIKit

protocol EpisodeDetailViewDelegate: AnyObject {
}

class EpisodeDetailView: UIView {
    weak var delegate: EpisodeDetailViewDelegate?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metrics.medium
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Metrics.radiusMedium
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.titleMD
        label.textColor = Colors.gray100
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bodyMD
        label.textColor = Colors.gray400
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let summaryLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bodyMD
        label.textColor = Colors.gray400
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.gray100
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentStack)
        [posterImageView,
         titleLabel,
         infoLabel,
         summaryLabel].forEach {
            contentStack.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Metrics.medium),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Metrics.medium),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Metrics.medium),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Metrics.medium),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -Metrics.medium * 2),
            
            posterImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configure(with episode: Episode) {
        titleLabel.text = episode.name
        infoLabel.text  = "S\(episode.season) • E\(episode.number)"
        summaryLabel.text = episode.summary?
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        ?? ""
        if let urlString = episode.image?.medium,
           let url = URL(string: urlString) {
            ImageLoader.shared.load(from: url) { [weak self] image in
                DispatchQueue.main.async {
                    self?.posterImageView.image = image
                }
            }
        } else {
            posterImageView.image = Icons.slate
        }
    }
}
