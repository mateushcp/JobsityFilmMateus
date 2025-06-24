//
//  DetailHEader.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import UIKit

class DetailHeader: UITableViewHeaderFooterView {
    static let reuseID = "DetailHeader"

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Metrics.radiusMedium
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel = UILabel.makeHeaderLabel(font: Typography.titleLG)
    private let scheduleLabel = UILabel.makeBodyLabel()
    private let genresLabel = UILabel.makeBodyLabel()
    private let summaryLabel = UILabel.makeBodyLabel(numberOfLines: 0)

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Colors.gray100
        [posterImageView,
         titleLabel,
         scheduleLabel,
         genresLabel,
         summaryLabel].forEach {
            contentView.addSubview($0)
        }
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metrics.medium),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.medium),
            posterImageView.heightAnchor.constraint(equalToConstant: 200),
            posterImageView.widthAnchor.constraint(equalToConstant: 140),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metrics.medium),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: Metrics.medium),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.medium),

            scheduleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.small),
            scheduleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            scheduleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            genresLabel.topAnchor.constraint(equalTo: scheduleLabel.bottomAnchor, constant: Metrics.small),
            genresLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genresLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            summaryLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: Metrics.medium),
            summaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.medium),
            summaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.medium),
            summaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Metrics.medium)
        ])
    }

    func configure(show: Show) {
        titleLabel.text = show.name
        scheduleLabel.text = show.schedule.days.joined(separator: ", ") + " às " + show.schedule.time
        genresLabel.text = show.genres.joined(separator: " • ")
        summaryLabel.text = show.summary?.replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression) ?? ""
        if let urlString = show.image?.original,
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

private extension UILabel {
    static func makeHeaderLabel(font: UIFont) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = Colors.gray100
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    static func makeBodyLabel(numberOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        label.font = Typography.bodyMD
        label.textColor = Colors.gray400
        label.numberOfLines = numberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
