//
//  Modelos.swift
//  Countries
//
//  Created by Daniel Ramirez on 05/12/25.
//

import Foundation

// Countries (Countrys.json)
struct CountryItem: Codable {
    let id: Int
    let nombre: String
}

// Country details (CountriesDetails.json)
struct CountryDetailItem: Codable {
    let nombre: String
    let capital: String
    let idioma: String
}

// Flags (Flags.json) -> [countryName: flagName]
typealias FlagsDict = [String: String]

// Currency (Currency.json)
struct CurrencyItem: Codable {
    let nombre: String
    let moneda: String
}

// CurrencyConversion.json -> array of single-key dictionaries
struct CurrencyConversion: Codable {
    let currency: String
    let rates: [String: Double]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        // decode as dictionary like { "USD": { "CAD": 1.211, ... } }
        let dict = try container.decode([String: [String: Double]].self)
        guard let key = dict.keys.first, let val = dict.values.first else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid currency conversion element")
        }
        self.currency = key
        self.rates = val
    }
}

// Capitals.json -> array with exactly one dict or more dicts; each element is a mapping country -> [ { "estado": "X" }, ... ]
// We expect array of dictionaries if your file was like you provided.
struct StateItem: Codable {
    let estado: String
}
typealias CapitalsElement = [String: [StateItem]] // one JSON array element

// PointsOfInterest.json structure:
// { "Paises": [ { "Estados Unidos": [ { "estado": "...", "lugares": [..] }, ... ] }, { "Canadá": [...] } ] }
struct POIState: Codable {
    let estado: String
    let lugares: [String]
}
typealias POIElement = [String: [POIState]] // each element in Paises array is a dict country -> [POIState]
