//
//  UniformNoise.swift
//  Canvasing
//
//  Created by Tiago Pereira on 21/10/25.
//

import Foundation

class UniformNoise: NoiseGenerator {
    func getValue(x: Double, y: Double, time: Double) -> Double {
        // Returns random value between -1 and 1
        // Each call produces a completely independent random value
        return Double.random(in: -1...1)
    }
}
