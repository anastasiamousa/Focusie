//
//  FocusView.swift
//  Focusie
//
//  Created by Anastasia Mousa on 9/3/26.
//

import SwiftUI

struct FocusView: View {
    
    @StateObject private var viewModel = FocusViewModel()
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            Image("PaperTexture")
                .resizable()
                .scaledToFill()
                .opacity(0.15)
                .ignoresSafeArea()
            
            mainContent
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 40) {
            
            Text("Focusie")
                .font(FocusieFont.semiBold(size: 28))
                .foregroundColor(Color("PrimaryText"))
            
            ZStack {
                FocusProgressRing(progress: progress)
                    .frame(width: 220, height: 220)
                
                Text(TimeFormatter.format(seconds: viewModel.state.remainingSeconds))
                    .font(FocusieFont.medium(size: 56))
                    .monospacedDigit()
                    .foregroundColor(Color("PrimaryText"))
                    .padding(24)
            }
            
            VStack(spacing: 16) {
                
                Button(viewModel.state.isRunning ? "Pause" : "Start") {
                    if viewModel.state.isRunning {
                        viewModel.send(action: .pauseTapped)
                    } else {
                        viewModel.send(action: .startTapped)
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(Color("Accent"))
                
                Button("Reset") {
                    viewModel.send(action: .resetTapped)
                }
                .buttonStyle(.bordered)
                .tint(Color("Accent"))
            }
        }
        .padding()
    }
    
    private var progress: Double {
        let total = Double(viewModel.state.totalSeconds)
        let remaining = Double(viewModel.state.remainingSeconds)
        return 1 - (remaining / total)
    }
}

#Preview {
    FocusView()
}
