//
//  FocusView.swift
//  Focusie
//
//  Created by Anastasia Mousa on 9/3/26.
//

import SwiftUI

struct FocusView: View {

    @StateObject private var viewModel = FocusViewModel()

    @State private var selectedMinutes: Int = 15
    @State private var completedMinutes: Int = 0
    @State private var showCompletionSheet: Bool = false
    @State private var hasShownCompletionSheet: Bool = false

    private let suggestedDurations = [15, 30, 45, 60]

    private let durationColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            Image("PaperTexture")
                .resizable()
                .scaledToFill()
                .opacity(0.15)
                .ignoresSafeArea()

            GeometryReader { geo in
                ScrollView(showsIndicators: false) {
                    mainContent
                        .frame(width: min(geo.size.width - 56, 360))
                        .frame(maxWidth: .infinity)
                        .padding(.top, 22)
                        .padding(.bottom, 22)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        .onAppear {
            if !viewModel.state.isRunning {
                viewModel.send(action: .setDuration(selectedMinutes * 60))
            }
        }
        .onChange(of: viewModel.state.remainingSeconds) { oldValue, newValue in
            handleTick(oldSeconds: oldValue, newSeconds: newValue)
        }
        .onChange(of: viewModel.state.isRunning) { _, isRunning in
            if isRunning {
                hasShownCompletionSheet = false
            }
        }
        .sheet(isPresented: $showCompletionSheet) {
            completionSheet
        }
    }

    private var mainContent: some View {
        VStack(spacing: 20) {
            headerSection
            timerSection
            focusGardenSection
            durationSection
            buttonsSection
        }
    }

    private var headerSection: some View {
        VStack(spacing: 6) {
            Text("Focusie")
                .font(FocusieFont.semiBold(size: 30))
                .foregroundColor(Color("PrimaryText"))

            Text("Grow your focus, one minute at a time.")
                .font(FocusieFont.medium(size: 15))
                .foregroundColor(Color("PrimaryText").opacity(0.58))
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, 4)
    }

    private var timerSection: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.16))
                .frame(width: 222, height: 222)
                .shadow(color: Color.black.opacity(0.035), radius: 14, x: 0, y: 8)

            FocusProgressRing(progress: progress)
                .frame(width: 204, height: 204)

            VStack(spacing: 4) {
                Text(TimeFormatter.format(seconds: viewModel.state.remainingSeconds))
                    .font(FocusieFont.medium(size: 50))
                    .monospacedDigit()
                    .foregroundColor(Color("PrimaryText"))

                Text(viewModel.state.isRunning ? "Stay with it" : "Ready when you are")
                    .font(FocusieFont.medium(size: 14))
                    .foregroundColor(Color("PrimaryText").opacity(0.55))
            }
        }
    }

    private var focusGardenSection: some View {
        VStack(spacing: 8) {
            FocusFlowerProgressView(
                flowerCount: visibleFlowerCount,
                accentColor: Color("PrimaryText"),
                textColor: Color("PrimaryText")
            )

            Text(gardenMessage)
                .font(FocusieFont.medium(size: 14))
                .foregroundColor(Color("PrimaryText").opacity(0.58))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(maxWidth: .infinity)
        }
    }

    private var durationSection: some View {
        VStack(spacing: 12) {
            Text("Choose your focus time")
                .font(FocusieFont.medium(size: 18))
                .foregroundColor(Color("PrimaryText").opacity(0.76))

            LazyVGrid(columns: durationColumns, spacing: 12) {
                ForEach(suggestedDurations, id: \.self) { minutes in
                    durationButton(minutes: minutes)
                }
            }

            customDurationControls
        }
        .disabled(viewModel.state.isRunning)
        .opacity(viewModel.state.isRunning ? 0.5 : 1)
    }

    private func durationButton(minutes: Int) -> some View {
        Button {
            selectedMinutes = minutes
            viewModel.send(action: .setDuration(minutes * 60))
            completedMinutes = 0
            hasShownCompletionSheet = false
        } label: {
            Text("\(minutes) min")
                .font(FocusieFont.semiBold(size: 16))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(selectedMinutes == minutes ? Color("Accent") : Color.white.opacity(0.24))
                )
                .foregroundColor(selectedMinutes == minutes ? .white : Color("PrimaryText"))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color("PrimaryText").opacity(selectedMinutes == minutes ? 0 : 0.08), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    private var customDurationControls: some View {
        HStack(spacing: 18) {
            Button {
                updateDuration(by: -1)
            } label: {
                Image(systemName: "minus")
                    .font(.system(size: 14, weight: .semibold))
                    .frame(width: 36, height: 36)
                    .background(Color.white.opacity(0.22))
                    .clipShape(Circle())
            }

            Text("\(selectedMinutes) min")
                .font(FocusieFont.semiBold(size: 18))
                .foregroundColor(Color("PrimaryText"))
                .frame(minWidth: 76)

            Button {
                updateDuration(by: 1)
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .semibold))
                    .frame(width: 36, height: 36)
                    .background(Color.white.opacity(0.22))
                    .clipShape(Circle())
            }
        }
        .foregroundColor(Color("PrimaryText"))
        .buttonStyle(.plain)
    }

    private var buttonsSection: some View {
        VStack(spacing: 12) {
            Button {
                if viewModel.state.isRunning {
                    viewModel.send(action: .pauseTapped)
                } else {
                    viewModel.send(action: .setDuration(selectedMinutes * 60))
                    viewModel.send(action: .startTapped)
                }
            } label: {
                Text(viewModel.state.isRunning ? "Pause" : "Start focus")
                    .font(FocusieFont.semiBold(size: 18))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color("Accent"))
                    .foregroundColor(.white)
                    .cornerRadius(22)
                    .shadow(color: Color.black.opacity(0.055), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(.plain)

            Button {
                resetSession()
            } label: {
                Text("Reset")
                    .font(FocusieFont.semiBold(size: 16))
                    .foregroundColor(Color("PrimaryText").opacity(0.58))
                    .padding(.vertical, 8)
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 2)
    }

    private var completionSheet: some View {
        VStack(spacing: 18) {
            FocusCompletionFlower(accentColor: Color("Accent"))
                .frame(width: 94, height: 94)

            Text("Focus complete")
                .font(FocusieFont.semiBold(size: 24))
                .foregroundColor(Color("PrimaryText"))

            Text("Your Focusie garden grew a little today.")
                .font(FocusieFont.medium(size: 16))
                .foregroundColor(Color("PrimaryText").opacity(0.72))
                .multilineTextAlignment(.center)

            Button {
                showCompletionSheet = false
            } label: {
                Text("Done")
                    .font(FocusieFont.semiBold(size: 18))
                    .padding(.vertical, 13)
                    .padding(.horizontal, 30)
                    .background(Color("Accent"))
                    .foregroundColor(.white)
                    .cornerRadius(16)
            }
            .padding(.top, 6)
        }
        .padding(28)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }

    private var progress: Double {
        let total = Double(viewModel.state.totalSeconds)
        guard total > 0 else { return 0 }

        let remaining = Double(viewModel.state.remainingSeconds)
        return 1 - (remaining / total)
    }

    private var visibleFlowerCount: Int {
        min(completedMinutes, 15)
    }

    private var gardenMessage: String {
        if completedMinutes == 0 {
            return "Your Focusie garden is ready for some focus flowers."
        } else if completedMinutes == 1 {
            return "1 focus flower added."
        } else if completedMinutes > 15 {
            return "\(completedMinutes) focus flowers added. Showing your first 15."
        } else {
            return "\(completedMinutes) focus flowers added."
        }
    }

    private func updateDuration(by value: Int) {
        let newValue = min(max(selectedMinutes + value, 1), 180)
        selectedMinutes = newValue
        viewModel.send(action: .setDuration(newValue * 60))
        completedMinutes = 0
        hasShownCompletionSheet = false
    }

    private func resetSession() {
        viewModel.send(action: .setDuration(selectedMinutes * 60))
        viewModel.send(action: .resetTapped)
        completedMinutes = 0
        hasShownCompletionSheet = false
        showCompletionSheet = false
    }

    private func handleTick(oldSeconds: Int, newSeconds: Int) {
        updateCompletedMinutes(remainingSeconds: newSeconds)

        guard newSeconds <= 0 else { return }
        guard !hasShownCompletionSheet else { return }

        completedMinutes = selectedMinutes
        hasShownCompletionSheet = true
        showCompletionSheet = true
    }

    private func updateCompletedMinutes(remainingSeconds: Int) {
        let elapsedSeconds = max(viewModel.state.totalSeconds - remainingSeconds, 0)
        let elapsedMinutes = elapsedSeconds / 60

        if elapsedMinutes != completedMinutes {
            completedMinutes = elapsedMinutes
        }
    }
}

private struct FocusFlowerProgressView: View {
    let flowerCount: Int
    let accentColor: Color
    let textColor: Color

    private let columns = Array(
        repeating: GridItem(.fixed(18), spacing: 6),
        count: 5
    )

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white.opacity(0.16))
                .frame(width: 146, height: 88)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(textColor.opacity(0.05), lineWidth: 1)
                )

            if flowerCount == 0 {
                EmptyGardenDots(textColor: textColor)
            } else {
                LazyVGrid(columns: columns, spacing: 6) {
                    ForEach(0..<flowerCount, id: \.self) { index in
                        MiniGardenFlower(accentColor: accentColor)
                            .frame(width: 18, height: 24)
                            .rotationEffect(.degrees(index.isMultiple(of: 2) ? -5 : 5))
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .animation(.spring(response: 0.35, dampingFraction: 0.72), value: flowerCount)
            }
        }
        .frame(height: 94)
    }
}

private struct EmptyGardenDots: View {
    let textColor: Color

    var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.fixed(8), spacing: 10), count: 5),
            spacing: 10
        ) {
            ForEach(0..<15, id: \.self) { _ in
                Circle()
                    .fill(textColor.opacity(0.10))
                    .frame(width: 6, height: 6)
            }
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
    }
}

private struct MiniGardenFlower: View {
    let accentColor: Color

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.55))
                    .frame(width: 8, height: 8)
                    .offset(x: -4)

                Circle()
                    .fill(accentColor.opacity(0.45))
                    .frame(width: 8, height: 8)
                    .offset(x: 4)

                Circle()
                    .fill(accentColor.opacity(0.50))
                    .frame(width: 8, height: 8)
                    .offset(y: -4)

                Circle()
                    .fill(accentColor.opacity(0.40))
                    .frame(width: 8, height: 8)
                    .offset(y: 4)

                Circle()
                    .fill(Color.white.opacity(0.75))
                    .frame(width: 4, height: 4)
            }
            .frame(width: 18, height: 18)

            Capsule()
                .fill(accentColor.opacity(0.38))
                .frame(width: 2, height: 8)
        }
    }
}

private struct FocusCompletionFlower: View {
    let accentColor: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(accentColor.opacity(0.14))

            MiniGardenFlower(accentColor: accentColor)
                .frame(width: 52, height: 74)
                .scaleEffect(2.4)
        }
    }
}

#Preview {
    FocusView()
}
