//
//  AnimatedCircleWithPointsView.swift
//  FindingBeauty
//
//  Created by Tiago Pereira on 29/10/25.
//

import SwiftUI

struct AnimatedCircleWithPointsView: View {
    
    let radius: CGFloat = 120.0
    
    let backgroundColor: Color = .blue
    
    let strokeColor: Color = .black
    let strokeWidth: CGFloat = 12.0
    
    let animationSpeed: Double = 1.0
    
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
                
                let path = generateCirclePath(
                    position: center,
                    size: radius * 2,
                    time: time
                )
                
                context.stroke(
                    path, with: .color(strokeColor),
                    lineWidth: strokeWidth
                )
            }
            .ignoresSafeArea()
        }
    }
    
    private func generateCirclePath(position: CGPoint, size: CGFloat, time: Double) -> Path {
        var points: [CGPoint] = []
        
        // Create 12 points around a circle
        for i in 0..<12 {
            let angle = (Double(i) / 12.0) * 2 * .pi
            let x = cos(angle) * size
            let y = sin(angle) * size
            points.append(CGPoint(x: x, y: y))
        }
        
        // Connect the points
        let path = Path { path in
            path.move(to: points[0])
            for i in 0..<points.count {
                let next = points[(i + 1) % points.count]
                let control = CGPoint(
                    x: (points[i].x + next.x) / 2,
                    y: (points[i].y + next.y) / 2
                )
                path.addQuadCurve(to: next, control: control)
            }
            path.closeSubpath()
        }
        
        // Simple rotation based on time
        let rotation = time
        
        // Position the circle at the center and rotate it
        let transform = CGAffineTransform.identity
            .translatedBy(x: position.x, y: position.y)
            .rotated(by: rotation)
        
        return path.applying(transform)
    }
}

#Preview {
    AnimatedCircleWithPointsView()
}
