//
//  SplashView.swift
//  Focusie
//
//  Created by Anastasia Mousa on 24/5/26.
//

import SwiftUI

struct SplashView: View {
    
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            Image("PaperTexture")
                .resizable()
                .scaledToFill()
                .opacity(0.15)
                .ignoresSafeArea()
            
            VStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(Color("Accent").opacity(0.16))
                        .frame(width: 96, height: 96)
                    
                    MinimalSplashFlower()
                        .frame(width: 54, height: 70)
                        .scaleEffect(isAnimating ? 1 : 0.92)
                        .opacity(isAnimating ? 1 : 0.8)
                        .animation(
                            .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                
                Text("Focusie")
                    .font(FocusieFont.semiBold(size: 34))
                    .foregroundColor(Color("PrimaryText"))
                
                Text("Grow your focus gently.")
                    .font(FocusieFont.medium(size: 16))
                    .foregroundColor(Color("PrimaryText").opacity(0.6))
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

private struct MinimalSplashFlower: View {
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(Color("Accent").opacity(0.55))
                    .frame(width: 18, height: 18)
                    .offset(x: -9)
                
                Circle()
                    .fill(Color("Accent").opacity(0.45))
                    .frame(width: 18, height: 18)
                    .offset(x: 9)
                
                Circle()
                    .fill(Color("Accent").opacity(0.5))
                    .frame(width: 18, height: 18)
                    .offset(y: -9)
                
                Circle()
                    .fill(Color("Accent").opacity(0.4))
                    .frame(width: 18, height: 18)
                    .offset(y: 9)
                
                Circle()
                    .fill(Color.white.opacity(0.8))
                    .frame(width: 8, height: 8)
            }
            .frame(width: 44, height: 44)
            
            Capsule()
                .fill(Color("Accent").opacity(0.38))
                .frame(width: 4, height: 30)
        }
    }
}

#Preview {
    SplashView()
}
