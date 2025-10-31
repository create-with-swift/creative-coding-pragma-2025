//
//  SquareAloneView.swift
//  FindingBeauty
//
//  Created by Tiago Pereira on 30/10/25.
//

import SwiftUI

struct SquareAloneView: View {
    
    let squareSize: CGFloat = 120.0
    
    private let backgroundColor: Color = .black
    
    private let strokeColor: Color = .white
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
            
            let path = Path { path in
                path.addRect(CGRect(
                    x: center.x - (squareSize / 2),
                    y: center.y - (squareSize / 2),
                    width: squareSize,
                    height: squareSize
                ))
            }
            
            context.stroke(
                path, with: .color(strokeColor),
                lineWidth: strokeWidth
            )
        }
        .ignoresSafeArea()
    }
    
    private func generateSquarePath(
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        height: CGFloat) -> Path {
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
    
    private func generateCirclePath(
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        height: CGFloat) -> Path {
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
    SquareAloneView()
}
