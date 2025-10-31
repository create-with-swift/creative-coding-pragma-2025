//
//  DrawCircleRadiusVariationView.swift
//  FindingBeauty
//
//  Created by Tiago Pereira on 29/10/25.
//

import SwiftUI

struct DrawCircleRadiusVariationView: View {
    private let radius: CGFloat = 120
    
    private let backgroundColor: Color = .blue
    private let fillColor: Color = .black
    
    private let strokeColor: Color = .black
    private let strokeWidth: CGFloat = 12.0
    
    var body: some View {
        Canvas { context, size in
            
            context.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .color(backgroundColor)
            )
            
            let center = CGPoint(
                x: size.width / 2,
                y: size.height / 2
            )
            
            let path = generateCirclePath(
                x: center.x - radius,
                y: center.y - radius,
                width: radius * 2,
                height:  radius * 2
            )
            
            context.stroke(
                path, with: .color(strokeColor),
                lineWidth: strokeWidth
            )
        }
        .ignoresSafeArea()
    }
    
    private func generateCirclePath(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> Path {
        let circlePath = Path { path in
            path.addEllipse(in: CGRect(
                x: x,
                y: y,
                width: width,
                height: height
            ))
        }
        
        return circlePath
    }
}

#Preview {
    DrawCircleRadiusVariationView()
}
