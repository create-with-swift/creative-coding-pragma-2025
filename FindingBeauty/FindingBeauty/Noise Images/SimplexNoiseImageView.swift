//
//  SimplexNoiseImageView.swift
//  FindingBeauty
//
//  Created by Tiago Pereira on 29/10/25.
//

import SwiftUI

struct SimplexNoiseImageView: View {
    
    let noiseGenerator: NoiseGenerator = SimplexNoise(seed: 42)
    
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
                        // Scale down coordinates for smooth noise pattern
                        let noise = noiseGenerator.getValue(
                            x: Double(x) * 0.02,
                            y: Double(y) * 0.02,
                            time: 0.0
                        )
                        
                        let pixelPath = Path(roundedRect: CGRect(x: x, y: y, width: 1, height: 1), cornerSize: CGSize(width: 0, height: 0))
                        
                        // SimplexNoise returns values in [-1, 1], normalize to [0, 1]
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
    SimplexNoiseImageView()
}
