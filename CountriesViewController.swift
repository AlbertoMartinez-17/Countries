//
//  CountriesViewController.swift
//  Countries
//
//  Created by Daniel Ramirez on 05/12/25.
//

import UIKit

class CountriesViewController: UIViewController {

    private var countries: [CountryItem] = []
    private let cellId = "countryCell"

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CountryCell.self, forCellWithReuseIdentifier: cellId)
        cv.backgroundColor = .systemBackground
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Countries"
        view.backgroundColor = .systemBackground

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        countries = DataManager.shared.countries
    }
}

extension CountriesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        countries.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let c = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CountryCell
        let country = countries[indexPath.item]
        let flag = DataManager.shared.flagName(for: country.nombre) ?? ""
        c.configure(name: country.nombre, flagAssetNameOrEmoji: flag)
        return c
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let country = countries[indexPath.item]
        let detail = CountryDetailViewController(countryName: country.nombre)
        detail.modalPresentationStyle = .pageSheet
        present(detail, animated: true)
    }

    // 2 celdas por fila, tamaño estable
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let spacing: CGFloat = 12
        let totalSpacing = spacing * 1   // solo entre columnas
        let width = (collectionView.frame.width - totalSpacing) / 2

        return CGSize(width: width, height: 160)
    }
}
