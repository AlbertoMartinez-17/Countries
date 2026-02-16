//
//  AnyCodable.swift
//  Countries
//
//  Created by Daniel Ramirez on 05/12/25.
//

import Foundation

struct AnyCodable: Codable {
    let value: Any

    init(_ value: Any) { self.value = value }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let v = try? container.decode(Bool.self) { value = v; return }
        if let v = try? container.decode(Int.self) { value = v; return }
        if let v = try? container.decode(Double.self) { value = v; return }
        if let v = try? container.decode(String.self) { value = v; return }
        if let v = try? container.decode([AnyCodable].self) { value = v.map { $0.value }; return }
        if let v = try? container.decode([String: AnyCodable].self) { value = v.mapValues { $0.value }; return }
        value = ()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let v = value as? Bool { try container.encode(v); return }
        if let v = value as? Int { try container.encode(v); return }
        if let v = value as? Double { try container.encode(v); return }
        if let v = value as? String { try container.encode(v); return }
        if let v = value as? [AnyCodable] { try container.encode(v); return }
        if let v = value as? [String: AnyCodable] { try container.encode(v); return }
        try container.encodeNil()
    }
}
