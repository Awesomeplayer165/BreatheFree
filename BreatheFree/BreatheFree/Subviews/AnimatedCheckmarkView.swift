//
//  AnimatedCheckmarkView.swift
//  Breathe
//
//  Created by Jacob Trentini on 11/24/22.
//

import SwiftUI

struct AnimatedCheckmarkView: View {
    @State private var outerTrimEnd: CGFloat = 0
    @State private var innerTrimEnd: CGFloat = 0
    @State private var strokeColor = Color.blue
    @State private var scale = 0.7
    private var shouldScale = true
    
    public var animationDuration: Double = 1.7
    public var size: CGSize = .init(width: 300, height: 300)
    public var innerShapeSizeRatio: CGFloat = 1/3
    
    public var fromColor: Color = .blue
    public var toColor: Color = .green
    
    public var strokeStyle: StrokeStyle = .init(lineWidth: 24, lineCap: .round, lineJoin: .round)
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: outerTrimEnd)
                .stroke(strokeColor, style: strokeStyle)
                .rotationEffect(.degrees(-90))
                .onAppear() {
                    strokeColor = fromColor
                    animate()
                }
            
            Checkmark()
                .trim(from: 0, to: innerTrimEnd)
                .stroke(strokeColor, style: strokeStyle)
                .frame(width: size.width * innerShapeSizeRatio, height: size.height * innerShapeSizeRatio)
        }
        .scaleEffect(scale)
        .frame(width: size.width, height: size.height)
    }
    
    func animate() {
        if shouldScale {
            withAnimation(.easeInOut(duration: 0.4 * animationDuration)) {
                outerTrimEnd = 1.0
            }
            
            withAnimation(
                .easeInOut(duration: 0.3 * animationDuration)
                .delay(0.4 * animationDuration)
            ) {
                innerTrimEnd = 1.0
            }
            
            withAnimation(
                .easeInOut(duration: 0.2 * animationDuration)
                .delay(0.2 * animationDuration)
            ) {
                strokeColor = .green
                scale = 1.3
            }
            
            withAnimation(
                .easeInOut(duration: 0.2 * animationDuration)
                .delay(0.4 * animationDuration)
            ) {
                scale = 1
            }
        } else {
            withAnimation(.easeInOut(duration: 0.5 * animationDuration)) {
                outerTrimEnd = 1.0
            }
            withAnimation(
                .easeInOut(duration: 0.3 * animationDuration)
                .delay(0.8 * animationDuration)
            ) {
                innerTrimEnd = 1.0
            }
            
            withAnimation(
                .easeInOut(duration: 0.2 * animationDuration)
                .delay(0.8 * animationDuration)
            ) {
                strokeColor = .green
            }
        }
    }
}

struct AnimatedCheckmarkView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedCheckmarkView()
    }
}

struct Checkmark: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.size.width
        let height = rect.size.height
        
        var path = Path()
        path.move(to: .init(x: 0 * width, y: 0.5 * height))
        path.addLine(to: .init(x: 0.4 * width, y: 1.0 * height))
        path.addLine(to: .init(x: 1.0 * width, y: 0 * height))
        return path
    }
}
