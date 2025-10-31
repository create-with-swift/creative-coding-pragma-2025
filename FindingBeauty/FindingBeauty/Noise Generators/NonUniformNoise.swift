//
//  NonUniformNoise.swift
//  Canvasing
//
//  Created by Tiago Pereira on 21/10/25.
//

import Foundation

class NonUniformNoise: NoiseGenerator {
    func getValue(x: Double, y: Double, time: Double) -> Double {
        // Using the "square of random" technique from Nature of Code
        // This makes smaller values more likely
        let random1 = Double.random(in: 0...1)
        let random2 = Double.random(in: 0...1)
        
        // If random2 is less than random1, use random2 (favors smaller values)
        // This creates a non-uniform distribution weighted toward 0
        let value = random2 < random1 ? random2 : random1
        
        // Convert from 0...1 to -1...1
        return (value * 2) - 1
    }
}
