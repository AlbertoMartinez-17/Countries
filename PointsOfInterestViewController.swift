//
//  PointsOfInterestViewController.swift
//  Countries
//
//  Created by Daniel Ramirez on 05/12/25.
//

import UIKit

class PointsOfInterestViewController: UIViewController, UITableViewDataSource {
    private let countryName: String
    private let stateName: String
    private let places: [String]
    private let table = UITableView()

    init(countryName: String, stateName: String) {
        self.countryName = countryName
        self.stateName = stateName
        // find POI states for country and state
        let all = DataManager.shared.poiStates(for: countryName)
        self.places = all.first(where: { $0.estado == stateName })?.lugares ?? []
        super.init(nibName: nil, bundle: nil)
        title = stateName
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(table)
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = places[indexPath.row]
        return cell
    }
}
