//
//  NoiseGenerator.swift
//  Canvasing
//
//  Created by Tiago Pereira on 21/10/25.
//

import SwiftUI

// MARK: - Noise Protocol
protocol NoiseGenerator {
    func getValue(x: Double, y: Double, time: Double) -> Double
}

// MARK: - Noise Types Enum
enum NoiseType: String, CaseIterable {
    case uniform = "Uniform Distribution"
    case nonUniform = "Non-Uniform Distribution"
    case normal = "Normal Distribution"
    case perlin = "Perlin Noise"
}
