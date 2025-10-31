//
//  CirclesInAGridWithNoiseView.swift
//  FindingBeauty
//
//  Created by Tiago Pereira on 30/10/25.
//

import SwiftUI

struct CirclesInAGridWithNoiseView: View {
    // Grid configuration properties
    let columns = 16
    let rows = 16
    
    let widthScale: CGFloat = 0.8
    let heightScale: CGFloat = 0.8
    
    // Circle configuration properties
    let circleSize: CGFloat = 24.0
    let strokeWidth: CGFloat = 4.0
    
    // Appearance configuration properties
    let strokeColor: Color = .white
    let backgroundColor: Color = .black
    
    // Animation configuration properties
    let noiseAmount: CGFloat = 0.3  // How much distortion to apply
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            
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
                        
                        // Generate circle path with noise
                        let circlePath = generateCirclePath(
                            position: CGPoint(x: centerX, y: centerY),
                            radius: circleSize / 2,
                            time: time
                        )
                        
                        context.stroke(circlePath, with: .color(strokeColor), lineWidth: strokeWidth)
                    }
                }
            }
            .background(backgroundColor)
        }
    }
    
    private func generateCirclePath(position: CGPoint, radius: CGFloat, time: Double) -> Path {
        var points: [CGPoint] = []
        
        // Get the source of noise to be applied on the creation of the coordinates of the shape
        let noiseGenerator = PerlinNoise(seed: 42)
        
        // Create 12 points around a circle
        for i in 0..<12 {
            let angle = (Double(i) / 12.0) * 2 * .pi
            
            let baseX = cos(angle) * radius
            let baseY = sin(angle) * radius
            
            let noiseX = noiseGenerator.getValue(
                x: Double(i) * 0.1,
                y: time,
                time: time
            )
            
            let noiseY = noiseGenerator.getValue(
                x: Double(i) * 0.1 + 100,  // Offset for independent X and Y
                y: time,
                time: time
            )
            
            // Apply noise to distort the point
            let distortedX = baseX + CGFloat(noiseX) * radius * noiseAmount
            let distortedY = baseY + CGFloat(noiseY) * radius * noiseAmount
            
            points.append(CGPoint(x: distortedX, y: distortedY))
        }
        
        // Connect the points
        let path = Path { path in
            path.move(to: points[0])
            for i in 0..<points.count {
                let next = points[(i + 1) % points.count]
                let control = CGPoint(
                    x: (points[i].x + next.x) / 1.855,
                    y: (points[i].y + next.y) / 1.855
                )
                path.addQuadCurve(to: next, control: control)
            }
            path.closeSubpath()
        }
        
        // Simple rotation based on time
        let rotation = time * 0.5
        
        // Position the circle at the center and rotate it
        let transform = CGAffineTransform.identity
            .translatedBy(x: position.x, y: position.y)
            .rotated(by: rotation)
        
        return path.applying(transform)
    }
}

#Preview {
    CirclesInAGridWithNoiseView()
}
