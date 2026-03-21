//
//  FocusProgressRing.swift
//  Focusie
//
//  Created by Anastasia Mousa on 21/3/26.
//

import SwiftUI

struct FocusProgressRing: View {
    
    let progress: Double
    let lineWidth: CGFloat
    
    init(progress: Double, lineWidth: CGFloat = 14) {
        self.progress = progress
        self.lineWidth = lineWidth
    }
    
    var body: some View {
        ZStack {
            
            backgroundRing
            
            progressRing
        }
        .animation(.easeInOut(duration: 0.25), value: clampedProgress)
    }
}

private extension FocusProgressRing {
    
    var clampedProgress: Double {
        max(0, min(progress, 1))
    }
    
    var backgroundRing: some View {
        Circle()
            .stroke(
                Color("RingBackground").opacity(0.35),
                lineWidth: lineWidth
            )
    }
    
    var progressRing: some View {
        Circle()
            .trim(from: 0, to: clampedProgress)
            .stroke(
                Color("Accent"),
                style: StrokeStyle(
                    lineWidth: lineWidth,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
            .rotationEffect(.degrees(-90))
    }
}

#Preview {
    ZStack {
        Color("Background")
            .ignoresSafeArea()
        
        FocusProgressRing(progress: 0.65)
            .frame(width: 220, height: 220)
            .padding()
    }
}
