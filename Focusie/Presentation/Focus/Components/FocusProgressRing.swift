//
//  FocusProgressRing.swift
//  Focusie
//
//  Created by Anastasia Mousa on 21/3/26.
//

import SwiftUI

struct FocusProgressRing: View {
    
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.gray.opacity(0.15),
                    lineWidth: 14
                )
            
            Circle()
                .trim(from: 0, to: max(0, min(progress, 1)))
                .stroke(
                    Color.primary,
                    style: StrokeStyle(
                        lineWidth: 14,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .rotationEffect(.degrees(-90))
        }
        .animation(.easeInOut(duration: 0.25), value: progress)
    }
}
