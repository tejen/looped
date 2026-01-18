//
//  ContentView.swift
//  Looped
//
//  Created by Tejen Patel on 1/17/26.
//

import SwiftUI
import MusicKit

enum AppState: Equatable {
    case onboarding
    case loading
    case stories
    case permissionDenied
    case emptyLibrary
    case error(String)
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
                OnboardingView(isAuthorized: $isAuthorized, onPermissionDenied: {
                    withAnimation {
                        appState = .permissionDenied
                    }
                })
                    .transition(.opacity)

            case .loading:
                LoadingView(stats: $stats, isLoading: $isLoading, onError: { error in
                    withAnimation {
                        appState = .error(error)
                    }
                }, onEmptyLibrary: {
                    withAnimation {
                        appState = .emptyLibrary
                    }
                })
                    .transition(.opacity)

            case .stories:
                if let stats = stats {
                    StoryContainerView(stats: stats)
                        .transition(.opacity)
                }

            case .permissionDenied:
                PermissionDeniedView(onRetry: {
                    withAnimation {
                        appState = .onboarding
                    }
                })
                    .transition(.opacity)

            case .emptyLibrary:
                EmptyLibraryView(onRetry: {
                    withAnimation {
                        appState = .loading
                    }
                })
                    .transition(.opacity)

            case .error(let message):
                ErrorStateView(message: message, onRetry: {
                    withAnimation {
                        appState = .loading
                    }
                })
                    .transition(.opacity)
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
