//
//  CurrencyConversionViewController.swift
//  Countries
//
//  Created by Daniel Ramirez on 05/12/25.
//

import UIKit

class CurrencyConversionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    private var codes: [String] = []
    private let leftPicker = UIPickerView()
    private let rightPicker = UIPickerView()
    private let arrowLabel = UILabel()
    private let amountField = UITextField()
    private let resultLabel = UILabel()
    private let convertButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Currency"
        view.backgroundColor = .systemBackground

        // Get currency codes
        codes = DataManager.shared.currencyCodes()
        if codes.isEmpty {
            // fallback if needed
            codes = ["USD","CAD","EUR","MXN"]
        }

        leftPicker.delegate = self
        leftPicker.dataSource = self
        rightPicker.delegate = self
        rightPicker.dataSource = self

        arrowLabel.text = ">"
        arrowLabel.font = .boldSystemFont(ofSize: 28)
        arrowLabel.textAlignment = .center

        amountField.placeholder = "Amount"
        amountField.borderStyle = .roundedRect
        amountField.keyboardType = .decimalPad
        amountField.delegate = self

        resultLabel.text = "Result: --"
        resultLabel.font = .systemFont(ofSize: 20)
        resultLabel.textAlignment = .center

        convertButton.setTitle("Convert", for: .normal)
        convertButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        convertButton.addTarget(self, action: #selector(convertCurrency), for: .touchUpInside)

        // Layout
        let stack = UIStackView(arrangedSubviews: [
            leftPicker,
            arrowLabel,
            rightPicker
        ])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false

        amountField.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        convertButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        view.addSubview(amountField)
        view.addSubview(convertButton)
        view.addSubview(resultLabel)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.heightAnchor.constraint(equalToConstant: 180),

            amountField.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 20),
            amountField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            amountField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            convertButton.topAnchor.constraint(equalTo: amountField.bottomAnchor, constant: 20),
            convertButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            resultLabel.topAnchor.constraint(equalTo: convertButton.bottomAnchor, constant: 30),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    // MARK: - Picker setup
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { codes.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return codes[row]
    }

    // MARK: - Conversion Logic
    @objc private func convertCurrency() {
        guard let text = amountField.text,
              let amount = Double(text) else {
            resultLabel.text = "Result: Invalid number"
            return
        }

        // ❌ Prevent negative amounts
        if amount < 0 {
            resultLabel.text = "Result: No negatives"
            return
        }

        let from = codes[leftPicker.selectedRow(inComponent: 0)]
        let to   = codes[rightPicker.selectedRow(inComponent: 0)]

        // Get rate from DataManager
        guard let rate = DataManager.shared.rate(from: from, to: to) else {
            resultLabel.text = "Result: No rate"
            return
        }

        let result = amount * rate
        resultLabel.text = "Result: \(String(format: "%.2f", result)) \(to)"
    }
}
