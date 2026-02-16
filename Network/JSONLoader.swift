//
//  JSONLoader.swift
//  Countries
//
//  Created by Daniel Ramirez on 05/12/25.
//

import Foundation

enum JSONLoadError: Error {
    case missing(String)
    case decode(String, Error)
}

final class JSONLoader {

    // Generic loader
    static func load<T: Decodable>(_ name: String, as type: T.Type) throws -> T {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            throw JSONLoadError.missing(name)
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw JSONLoadError.decode(name, error)
        }
    }

    // Special loader for CurrencyConversion (array of objects)
    static func loadCurrencyConversion(_ name: String) throws -> [CurrencyConversion] {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            throw JSONLoadError.missing(name)
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([CurrencyConversion].self, from: data)
        } catch {
            throw JSONLoadError.decode(name, error)
        }
    }

    // Special loader for Capitals (array of dicts)
    static func loadCapitals(_ name: String) throws -> [CapitalsElement] {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            throw JSONLoadError.missing(name)
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([CapitalsElement].self, from: data)
        } catch {
            throw JSONLoadError.decode(name, error)
        }
    }

    // Special loader for Points of Interest
    static func loadPOI(_ name: String) throws -> [POIElement] {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            throw JSONLoadError.missing(name)
        }
        do {
            let data = try Data(contentsOf: url)
            // root is an object { "Paises": [ {...}, {...} ] }
            let top = try JSONDecoder().decode([String: [POIElement]].self, from: data)
            // look up "Paises"
            if let arr = top["Paises"] {
                return arr
            } else {
                return []
            }
        } catch {
            throw JSONLoadError.decode(name, error)
        }
    }
}
