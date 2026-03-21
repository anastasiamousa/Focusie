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
                    Color.gray.opacity(0.2),
                    lineWidth: 12
                )
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.primary,
                    style: StrokeStyle(
                        lineWidth: 12,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: progress)
        }
    }
}
