//
//  WorleyNoiseImageView.swift
//  FindingBeauty
//
//  Created by Tiago Pereira on 29/10/25.
//

import SwiftUI

struct WorleyNoiseImageView: View {
    
    let noiseGenerator: NoiseGenerator = WorleyNoise(seed: 33)
    
    // Try values between 0.01 and 0.05)
    // Smaller (0.01) = larger cells
    // Larger (0.05) = smaller, more numerous cells
    let noiseScale: Double = 0.02
    
    var body: some View {
        GeometryReader { proxy in
            
            let width = proxy.size.width
            let height = proxy.size.height
            
            Canvas { context, size in
                
                context.fill(
                    Path(CGRect(origin: .zero, size: size)),
                    with: .color(Color.white)
                )
                
                for x in 0..<Int(width) {
                    for y in 0..<Int(height) {
                        // Scale down coordinates for visible cellular pattern
                        let noise = noiseGenerator.getValue(
                            x: Double(x) * noiseScale,
                            y: Double(y) * noiseScale,
                            time: 0.0
                        )
                        
                        let pixelPath = Path(roundedRect: CGRect(x: x, y: y, width: 1, height: 1), cornerSize: CGSize(width: 0, height: 0))
                        
                        // WorleyNoise returns values in [-1, 1], normalize to [0, 1]
                        let normalizedNoise = (noise + 1.0) / 2.0
                        let fillColor = Color.black.opacity(normalizedNoise)
                        
                        context.fill(pixelPath, with: .color(fillColor))
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    WorleyNoiseImageView()
}
