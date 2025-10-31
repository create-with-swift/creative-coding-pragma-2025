//
//  WorleyNoise.swift
//  FindingBeauty
//
//  Created by Tiago Pereira on 29/10/25.
//

import Foundation

class WorleyNoise: NoiseGenerator {
    private var permutation: [Int] = []
    
    init(seed: Int = 0) {
        var p = Array(0..<256)
        var rng = SeededRandomNumberGenerator(seed: seed)
        p.shuffle(using: &rng)
        permutation = p + p
    }
    
    func getValue(x: Double, y: Double, time: Double) -> Double {
        return noise(x: x, y: y)
    }
    
    private func noise(x: Double, y: Double) -> Double {
        // Determine which cell we're in
        let cellX = Int(floor(x))
        let cellY = Int(floor(y))
        
        var minDistance = Double.infinity
        
        // Check the current cell and all 8 neighboring cells
        for offsetX in -1...1 {
            for offsetY in -1...1 {
                let neighborX = cellX + offsetX
                let neighborY = cellY + offsetY
                
                // Get the feature point position within this cell
                let featurePoint = getFeaturePoint(cellX: neighborX, cellY: neighborY)
                
                // Calculate distance to this feature point
                let dx = x - featurePoint.x
                let dy = y - featurePoint.y
                let distance = sqrt(dx * dx + dy * dy)
                
                minDistance = min(minDistance, distance)
            }
        }
        
        // Normalize the distance to roughly [-1, 1] range
        // You can adjust the scaling factor to change the appearance
        return 1.0 - min(minDistance * 2.0, 1.0) * 2.0
    }
    
    // Generate a consistent random feature point for a given cell
    private func getFeaturePoint(cellX: Int, cellY: Int) -> (x: Double, y: Double) {
        let hash = hash2D(x: cellX, y: cellY)
        
        // Use the hash to generate pseudo-random coordinates within the cell
        let randomX = Double(hash & 0xFF) / 255.0
        let randomY = Double((hash >> 8) & 0xFF) / 255.0
        
        return (
            x: Double(cellX) + randomX,
            y: Double(cellY) + randomY
        )
    }
    
    // Hash function to generate consistent random values for each cell
    private func hash2D(x: Int, y: Int) -> Int {
        let wrappedX = x & 255
        let wrappedY = y & 255
        
        let index1 = permutation[wrappedX]
        let index2 = permutation[(index1 + wrappedY) & 255]
        
        return permutation[index2]
    }
}
