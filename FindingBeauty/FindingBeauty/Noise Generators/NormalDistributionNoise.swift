//
//  NormalDistributionNoise.swift
//  Canvasing
//
//  Created by Tiago Pereira on 21/10/25.
//

import Foundation

class NormalDistributionNoise: NoiseGenerator {
    private let mean: Double = 0.0
    private let standardDeviation: Double = 0.3
    
    func getValue(x: Double, y: Double, time: Double) -> Double {
        // Box-Muller transform to generate Gaussian distribution
        let u1 = Double.random(in: 0...1)
        let u2 = Double.random(in: 0...1)
        
        let z0 = sqrt(-2.0 * log(u1)) * cos(2.0 * .pi * u2)
        
        // Scale by standard deviation and add mean
        let value = z0 * standardDeviation + mean
        
        // Clamp to -1...1 range
        return max(-1, min(1, value))
    }
}
