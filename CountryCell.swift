//
//  CountryCell.swift
//  Countries
//
//  Created by Daniel Ramirez on 05/12/25.
//

import UIKit

class CountryCell: UICollectionViewCell {

    private let flagImageView = UIImageView()
    private let flagLabel = UILabel()
    private let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true

        // Imagen
        flagImageView.contentMode = .scaleAspectFit
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        flagImageView.isHidden = true

        // Emoji
        flagLabel.font = UIFont.systemFont(ofSize: 44)
        flagLabel.textAlignment = .center
        flagLabel.translatesAutoresizingMaskIntoConstraints = false
        flagLabel.isHidden = true

        // Nombre
        nameLabel.font = .systemFont(ofSize: 15, weight: .medium)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(flagImageView)
        contentView.addSubview(flagLabel)
        contentView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            flagImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            flagImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            flagImageView.widthAnchor.constraint(equalToConstant: 70),
            flagImageView.heightAnchor.constraint(equalToConstant: 50),

            flagLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            flagLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            nameLabel.topAnchor.constraint(equalTo: flagImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(name: String, flagAssetNameOrEmoji: String) {
        nameLabel.text = name

        // Si es emoji (normalmente 1-3 caracteres visibles)
        if flagAssetNameOrEmoji.count <= 3 {
            flagLabel.text = flagAssetNameOrEmoji
            flagLabel.isHidden = false

            flagImageView.image = nil
            flagImageView.isHidden = true
        }
        else {
            flagImageView.image = UIImage(named: flagAssetNameOrEmoji)
            flagImageView.isHidden = false

            flagLabel.text = nil
            flagLabel.isHidden = true
        }
    }
}
