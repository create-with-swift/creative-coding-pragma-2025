//
//  PerlinNoiseImageView.swift
//  FindingBeauty
//
//  Created by Tiago Pereira on 29/10/25.
//

import SwiftUI

struct PerlinNoiseImageView: View {
    
    let noiseGenerator: NoiseGenerator = PerlinNoise(seed: 13)
    
    var body: some View {
        GeometryReader { proxy in
            
            let width = proxy.size.width
            let height = proxy.size.height
            
            Canvas { context, size in
                context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(Color.white))
                
                for x in 0..<Int(width) {
                    for y in 0..<Int(height) {
                        let noise = noiseGenerator.getValue(x: Double(x) * 0.01, y: Double(y) * 0.01, time: 0.0)
                        
                        let pixelPath = Path(roundedRect: CGRect(x: x, y: y, width: 1, height: 1), cornerSize: CGSize(width: 0, height: 0))
                        
                        let fillColor = Color.black.opacity(noise)
                        
                        context.fill(pixelPath, with: .color(fillColor))
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    PerlinNoiseImageView()
}
