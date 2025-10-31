//
//  SimplexNoise.swift
//  FindingBeauty
//
//  Created by Tiago Pereira on 29/10/25.
//

import Foundation

class SimplexNoise: NoiseGenerator {
    private var perm: [Int] = []
    private var permMod12: [Int] = []
    
    // Skewing and unskewing factors for 2D
    private let F2 = 0.5 * (sqrt(3.0) - 1.0)
    private let G2 = (3.0 - sqrt(3.0)) / 6.0
    
    // Gradient vectors for 2D
    private let grad3: [[Double]] = [
        [1,1,0], [-1,1,0], [1,-1,0], [-1,-1,0],
        [1,0,1], [-1,0,1], [1,0,-1], [-1,0,-1],
        [0,1,1], [0,-1,1], [0,1,-1], [0,-1,-1]
    ]
    
    init(seed: Int = 0) {
        var p = Array(0..<256)
        var rng = SeededRandomNumberGenerator(seed: seed)
        p.shuffle(using: &rng)
        perm = p + p
        permMod12 = perm.map { $0 % 12 }
    }
    
    func getValue(x: Double, y: Double, time: Double) -> Double {
        return noise(x: x, y: y)
    }
    
    private func noise(x: Double, y: Double) -> Double {
        var n0, n1, n2: Double
        
        // Skew the input space to determine which simplex cell we're in
        let s = (x + y) * F2
        let i = Int(floor(x + s))
        let j = Int(floor(y + s))
        
        let t = Double(i + j) * G2
        let X0 = Double(i) - t
        let Y0 = Double(j) - t
        let x0 = x - X0
        let y0 = y - Y0
        
        // Determine which simplex we are in
        let i1, j1: Int
        if x0 > y0 {
            i1 = 1; j1 = 0  // lower triangle, XY order: (0,0)->(1,0)->(1,1)
        } else {
            i1 = 0; j1 = 1  // upper triangle, YX order: (0,0)->(0,1)->(1,1)
        }
        
        // Offsets for middle corner in (x,y) unskewed coords
        let x1 = x0 - Double(i1) + G2
        let y1 = y0 - Double(j1) + G2
        let x2 = x0 - 1.0 + 2.0 * G2
        let y2 = y0 - 1.0 + 2.0 * G2
        
        // Work out the hashed gradient indices of the three simplex corners
        let ii = i & 255
        let jj = j & 255
        let gi0 = permMod12[ii + perm[jj]]
        let gi1 = permMod12[ii + i1 + perm[jj + j1]]
        let gi2 = permMod12[ii + 1 + perm[jj + 1]]
        
        // Calculate the contribution from the three corners
        var t0 = 0.5 - x0*x0 - y0*y0
        if t0 < 0 {
            n0 = 0.0
        } else {
            t0 *= t0
            n0 = t0 * t0 * dot(grad3[gi0], x: x0, y: y0)
        }
        
        var t1 = 0.5 - x1*x1 - y1*y1
        if t1 < 0 {
            n1 = 0.0
        } else {
            t1 *= t1
            n1 = t1 * t1 * dot(grad3[gi1], x: x1, y: y1)
        }
        
        var t2 = 0.5 - x2*x2 - y2*y2
        if t2 < 0 {
            n2 = 0.0
        } else {
            t2 *= t2
            n2 = t2 * t2 * dot(grad3[gi2], x: x2, y: y2)
        }
        
        // Add contributions from each corner to get the final noise value.
        // The result is scaled to return values in the interval [-1,1].
        return 70.0 * (n0 + n1 + n2)
    }
    
    private func dot(_ g: [Double], x: Double, y: Double) -> Double {
        return g[0] * x + g[1] * y
    }
}
