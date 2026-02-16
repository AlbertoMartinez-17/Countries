//
//  DataManager.swift
//  Countries
//
//  Created by Daniel Ramirez on 05/12/25.
//

import Foundation

final class DataManager {
    static let shared = DataManager()
    private init() {}

    // Raw loaded
    lazy var countries: [CountryItem] = {
        (try? JSONLoader.load("Countrys", as: [CountryItem].self)) ?? []
    }()

    lazy var countryDetails: [CountryDetailItem] = {
        (try? JSONLoader.load("CountriesDetails", as: [CountryDetailItem].self)) ?? []
    }()

    lazy var flags: FlagsDict = {
        (try? JSONLoader.load("Flags", as: FlagsDict.self)) ?? [:]
    }()

    lazy var currencies: [CurrencyItem] = {
        (try? JSONLoader.load("Currency", as: [CurrencyItem].self)) ?? []
    }()

    lazy var currencyConversions: [CurrencyConversion] = {
        (try? JSONLoader.loadCurrencyConversion("CurrencyConversion")) ?? []
    }()

    // Capitals: array of dictionary elements; merge them into a single mapping country->states
    lazy var capitals: [String: [StateItem]] = {
        guard let arr = try? JSONLoader.loadCapitals("Capitals") else { return [:] }
        var merged: [String: [StateItem]] = [:]
        for element in arr {
            for (country, states) in element {
                merged[country] = states
            }
        }
        return merged
    }()

    // Points of interest: Paises -> array of dict elements; merge to country-> [POIState]
    lazy var pointsOfInterest: [String: [POIState]] = {
        guard let arr = try? JSONLoader.loadPOI("PointsOfInterest") else { return [:] }
        var merged: [String: [POIState]] = [:]
        for element in arr {
            for (country, states) in element {
                merged[country] = states
            }
        }
        return merged
    }()

    // Helper accessors
    func detail(for countryName: String) -> CountryDetailItem? {
        countryDetails.first { $0.nombre == countryName }
    }

    func flagName(for countryName: String) -> String? {
        flags[countryName]
    }

    func states(for countryName: String) -> [StateItem] {
        capitals[countryName] ?? []
    }

    func poiStates(for countryName: String) -> [POIState] {
        pointsOfInterest[countryName] ?? []
    }

    func currencyName(for countryName: String) -> String? {
        currencies.first(where: { $0.nombre == countryName })?.moneda
    }

    // lookup rate from A -> B. returns optional double
    // currencyConversions is array like [ {currency: "USD", rates: {...}}, ... ]
    func rate(from: String, to: String) -> Double? {
        if from == to { return 1.0 }
        // try find entry for 'from'
        if let entry = currencyConversions.first(where: { $0.currency == from }) {
            if let r = entry.rates[to] { return r }
        }
        // if not found, try to find reverse and invert
        if let reverse = currencyConversions.first(where: { $0.currency == to }), let revRate = reverse.rates[from], revRate != 0 {
            return 1.0 / revRate
        }
        // not found
        return nil
    }

    // list of currency codes (short like USD, CAD, MXN) from conversions or from Currency.json parsing:
    func currencyCodes() -> [String] {
        // try to use conversions order
        let codesFromConv = currencyConversions.map { $0.currency }
        if !codesFromConv.isEmpty { return codesFromConv }
        // fallback parse short codes from CurrencyItem.moneda like "Dólar estadounidense (USD)"
        var codes: [String] = []
        for c in currencies {
            if let code = extractCode(from: c.moneda) { codes.append(code) }
        }
        return Array(Set(codes)).sorted()
    }
}

extension DataManager {
    func extractCode(from full: String) -> String? {
        if let start = full.lastIndex(of: "("), let end = full.lastIndex(of: ")"), start < end {
            let code = full[full.index(after: start)..<end]
            return String(code)
        }
        return nil
    }
}
