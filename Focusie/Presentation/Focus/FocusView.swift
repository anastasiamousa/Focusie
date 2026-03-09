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
        VStack(spacing: 40) {
            
            Text("Focusie")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Text(TimeFormatter.format(seconds: viewModel.state.remainingSeconds))
                .font(.system(size: 56, weight: .medium, design: .rounded))
            
            VStack(spacing: 16) {
                
                Button(viewModel.state.isRunning ? "Pause" : "Start") {
                    if viewModel.state.isRunning {
                        viewModel.send(action: .pauseTapped)
                    } else {
                        viewModel.send(action: .startTapped)
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Button("Reset") {
                    viewModel.send(action: .resetTapped)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
}

#Preview {
    FocusView()
}
