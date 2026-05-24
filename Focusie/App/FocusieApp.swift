//
//  FocusieApp.swift
//  Focusie
//
//  Created by Anastasia Mousa on 9/3/26.
//

import SwiftUI

@main
struct FocusieApp: App {
    
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView()
                        .transition(.opacity)
                } else {
                    FocusView()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.45), value: showSplash)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                    showSplash = false
                }
            }
        }
    }
}
