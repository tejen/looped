//
//  ContentView.swift
//  Looped
//
//  Created by Tejen Patel on 1/17/26.
//

import SwiftUI
import MusicKit

enum AppState {
    case onboarding
    case loading
    case stories
}

struct ContentView: View {
    @State private var appState: AppState = .onboarding
    @State private var isAuthorized = false
    @State private var stats: ListeningStats?
    @State private var isLoading = true

    var body: some View {
        ZStack {
            switch appState {
            case .onboarding:
                OnboardingView(isAuthorized: $isAuthorized)
                    .transition(.opacity)

            case .loading:
                LoadingView(stats: $stats, isLoading: $isLoading)
                    .transition(.opacity)

            case .stories:
                if let stats = stats {
                    StoryContainerView(stats: stats)
                        .transition(.opacity)
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appState)
        .onAppear {
            checkAuthorizationStatus()
        }
        .onChange(of: isAuthorized) { _, authorized in
            if authorized {
                withAnimation {
                    appState = .loading
                }
            }
        }
        .onChange(of: isLoading) { _, loading in
            if !loading && stats != nil {
                withAnimation {
                    appState = .stories
                }
            }
        }
    }

    private func checkAuthorizationStatus() {
        let status = MusicKitService.shared.checkAuthorizationStatus()
        if status == .authorized {
            isAuthorized = true
            appState = .loading
        }
    }
}

#Preview {
    ContentView()
}
