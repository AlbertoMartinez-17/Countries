//
//  CountryDetailViewController.swift
//  Countries
//
//  Created by Daniel Ramirez on 05/12/25.
//

import UIKit

class CountryDetailViewController: UIViewController {

    private let countryName: String
    private let detail: CountryDetailItem?
    private let states: [StateItem]

    private let flagLabel = UILabel()
    private let capitalLabel = UILabel()
    private let languageLabel = UILabel()
    private let currencyButton = UIButton(type: .system)
    private let table = UITableView()

    init(countryName: String) {
        self.countryName = countryName
        self.detail = DataManager.shared.detail(for: countryName)
        self.states = DataManager.shared.states(for: countryName)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = countryName
        setupUI()
    }

    private func setupUI() {
        // Flag
        flagLabel.font = .systemFont(ofSize: 80)
        flagLabel.textAlignment = .center
        flagLabel.text = DataManager.shared.flagName(for: countryName) ?? ""

        capitalLabel.text = "Capital: \(detail?.capital ?? "---")"
        languageLabel.text = "Language: \(detail?.idioma ?? "---")"

        currencyButton.setTitle("Currency: \(DataManager.shared.currencyName(for: countryName) ?? "---")", for: .normal);        currencyButton.addTarget(self, action: #selector(openCurrencyTab), for: .touchUpInside)

        table.dataSource = self
        table.delegate = self
        table.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [flagLabel, capitalLabel, languageLabel, currencyButton])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        view.addSubview(table)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            table.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 12),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func openCurrencyTab() {
        // switch tab if possible
        if let tbc = presentingViewController as? UITabBarController {
            tbc.selectedIndex = 1
            dismiss(animated: true)
            return
        }
        if let tbc = tabBarController {
            tbc.selectedIndex = 1
            dismiss(animated: true)
            return
        }
        dismiss(animated: true)
    }
}

extension CountryDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        states.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = states[indexPath.row].estado
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = states[indexPath.row]
        let poiVC = PointsOfInterestViewController(countryName: countryName, stateName: state.estado)
        poiVC.modalPresentationStyle = .pageSheet
        present(poiVC, animated: true)
    }
}
