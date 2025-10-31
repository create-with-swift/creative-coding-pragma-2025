//
//  SquaresInAGridView.swift
//  FindingBeauty
//
//  Created by Tiago Pereira on 30/10/25.
//

import SwiftUI

struct SquaresInAGridView: View {
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
            
            // Draw squares
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
                            // Center the square at origin
                            x: -squareSize / 2,
                            y: -squareSize / 2,
                            width: squareSize,
                            height: squareSize
                        ))
                    }
                    
                    // Applying position
                    let transform = CGAffineTransform.identity
                        .translatedBy(x: centerX, y: centerY)
                    
                    let transformedPath = square.applying(transform)
                    
                    // Draw it
                    context.stroke(transformedPath, with: .color(strokeColor), lineWidth: strokeWidth)
                }
            }
            
        }
        .background(backgroundColor)
        
    }
}

#Preview {
    SquaresInAGridView()
}
