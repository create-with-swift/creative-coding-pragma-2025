//
//  AnimatedCircleWithPerlinNoiseView.swift
//  Canvasing
//
//  Created by Tiago Pereira on 21/10/25.
//

import SwiftUI

struct AnimatedCircleWithPerlinNoiseView: View {
    let radius: CGFloat = 60.0
    
    let backgroundColor: Color = .black
    let strokeColor: Color = .white
    let strokeWidth: CGFloat = 4.0
    
    let animationSpeed: Double = 0.3
    
    // How much noise affects the shape
    let noiseAmount: CGFloat = 1.5
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate * animationSpeed
            
            Canvas { context, size in
                // White background
                context.fill(
                    Path(CGRect(origin: .zero, size: size)),
                    with: .color(backgroundColor)
                )
                
                let center = CGPoint(
                    x: size.width / 2,
                    y: size.height / 2
                )
                
                let path = generateCirclePath(position: center, radius: radius * 2, time: time)
                
                context.stroke(
                    path, with: .color(strokeColor),
                    lineWidth: strokeWidth
                )
            }
            .ignoresSafeArea()
            
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
    AnimatedCircleWithPerlinNoiseView()
}
