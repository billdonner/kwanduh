//
//  ActionMenuView.swift
//  kwanduh
//
//  Created by bill donner on 11/21/24.
//


import SwiftUI

struct GameScreenActionMenuView: View {
    struct MenuState {
        var showSettings: Binding<Bool>
        var showTopicSelector: Binding<Bool>
        var showScheme: Binding<Bool>
        var showLeaderboard: Binding<Bool>
        var showSendComment: Binding<Bool>
        var showGameLog: Binding<Bool>
        var onboardingDone: Binding<Bool>
        var showFreeportSettings: Binding<Bool>
        var isPlaying: Bool
        var showFreeport: Bool
    }

    let state: MenuState

    var body: some View {
        Menu {
            Button(action: {
                state.showSettings.wrappedValue.toggle()
            }) {
                Text("Select Board Size")
            }
            .disabled(state.isPlaying)

            Button(action: {
                state.showTopicSelector.wrappedValue.toggle()
            }) {
                Text("Select Topics")
            }
            .disabled(state.isPlaying)

            Button(action: {
                state.showScheme.wrappedValue.toggle()
            }) {
                Text("Select Color Scheme")
            }

            Button(action: {
                state.showLeaderboard.wrappedValue.toggle()
            }) {
                Text("Leaderboard")
            }

            Button(action: {
                state.showSendComment.wrappedValue.toggle()
            }) {
                Text("Contact Us")
            }

            Button(action: {
                state.showGameLog.wrappedValue.toggle()
            }) {
                Text("Game History")
            }
            .disabled(true)

            Button(action: {
                state.onboardingDone.wrappedValue = false
            }) {
                Text("Replay OnBoarding")
            }

            if state.showFreeport {
                Button(action: {
                    state.showFreeportSettings.wrappedValue.toggle()
                }) {
                    Text("Freeport Software")
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .font(.title3)
                .padding(.leading, 20)
                .padding(.trailing, 1)
        }
    }
}
#Preview("ActionMenuView") {
    GameScreenActionMenuView(
        state: .init(
            showSettings: .constant(false),
            showTopicSelector: .constant(false),
            showScheme: .constant(false),
            showLeaderboard: .constant(false),
            showSendComment: .constant(false),
            showGameLog: .constant(false),
            onboardingDone: .constant(true),
            showFreeportSettings: .constant(false),
            isPlaying: false,
            showFreeport: true
        )
    )
}
