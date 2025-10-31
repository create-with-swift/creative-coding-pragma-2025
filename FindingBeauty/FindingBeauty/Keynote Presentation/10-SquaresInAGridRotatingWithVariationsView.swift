//
//  SquaresInAGridRotatingWithVariationsView.swift
//  FindingBeauty
//
//  Created by Tiago Pereira on 30/10/25.
//

import SwiftUI

struct SquaresInAGridRotatingWithVariationsView: View {
    // Grid configuration properties
    let columns = 16
    let rows = 16
    
    let widthScale: CGFloat = 0.8
    let heightScale: CGFloat = 0.8
    
    // Squares configuration properties
    let squareSize: CGFloat = 24.0
    let strokeWidth: CGFloat = 4.0
    
    // Appearance configuration properties
    let strokeColor: Color = .white
    let backgroundColor: Color = .black
    
    // Animation configuration properties
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate * 2
            
            Canvas { context, size in
                // Grid dimensions (80% of screen)
                let width = size.width * widthScale
                let height = size.height * heightScale
                
                // Cell sizes
                let cellWidth = width / CGFloat(columns)
                let cellHeight = height / CGFloat(rows)
                
                // Centering offsets
                let startX = (size.width - width) / 2
                let startY = (size.height - height) / 2
                
                // Draw circles
                for row in 0..<rows {
                    for col in 0..<columns {
                        // Cell position
                        let x = startX + CGFloat(col) * cellWidth
                        let y = startY + CGFloat(row) * cellHeight
                        
                        // Center of cell
                        let centerX = x + cellWidth / 2
                        let centerY = y + cellHeight / 2
                        
                        // Create square
                        let square = Path { path in
                            path.addRect(CGRect(
                                x: -squareSize / 2,  // Center the square at origin
                                y: -squareSize / 2,
                                width: squareSize,
                                height: squareSize
                            ))
                        }
                        
                        // Applying position and rotation
                        
                        // Each square rotates at a different speed based on its position
                        // let rotation = time * (1.0 + Double(row + col) * 0.1)
                        
                        // Alternate rotation directions
                        // let rotation = time * (((row + col) % 2 == 0) ? 1.0 : -1.0)
                        
                        // Row-based variation
                        // let rotation = time * (1.0 + Double(row) * 0.2)
                        
                        // Column-based variation
                        // let rotation = time * (1.0 + Double(col) * 0.2)
                        
                        // Distance from center
                        // let centerCol = Double(columns) / 2.0
                        // let centerRow = Double(rows) / 2.0
                        // let distanceFromCenter = sqrt(pow(Double(col) - centerCol, 2) + pow(Double(row) - centerRow, 2))
                        // let rotation = time * (1.0 + distanceFromCenter * 0.1)
                        
                        // Sine wave pattern
                         let rotation = time * (1.0 + sin(Double(col) * 0.5) * 0.5)
                        
                        let transform = CGAffineTransform.identity
                            .translatedBy(x: centerX, y: centerY)
                            .rotated(by: rotation)
                        
                        let transformedPath = square.applying(transform)
                        
                        // Draw it
                        context.stroke(transformedPath, with: .color(strokeColor), lineWidth: strokeWidth)
                    }
                }
            }
            .background(backgroundColor)
        }
    }
}

#Preview {
    SquaresInAGridRotatingWithVariationsView()
}
