//
//  TopBarView.swift
//  kwanduh
//
//  Created by bill donner on 11/21/24.
//


import SwiftUI

struct TopBarView: View {
    @Binding var playState: StateOfPlay
    @Binding var isPlayingButtonState: Bool
    @Binding var showSettings: Bool
    @Binding var showTopicSelector: Bool
    @Binding var showScheme: Bool
    @Binding var showLeaderboard: Bool
    @Binding var showSendComment: Bool
    @Binding var showGameLog: Bool
    @Binding var onboardingDone: Bool
    @Binding var showFreeportSettings: Bool
    var gameTitle: String
    var onStartGame: () -> Bool
    var onEndGamePressed: () -> Void
    var chmgrCheckConsistency: () -> Void
    var conditionalAssert: (Bool) -> Void

    var body: some View {
        HStack {
            // Play toggle button
            Button(playState == StateOfPlay.playingNow ? "End" : "Play") {
                isPlayingButtonState.toggle()
                if playState != StateOfPlay.playingNow {
                    // Start game logic
                    withAnimation {
                        let ok = onStartGame()
                        if !ok {
                            // Handle inability to start the game (external alert)
                        }
                        chmgrCheckConsistency()
                        conditionalAssert(true)
                    }
                } else {
                    // End game logic
                    withAnimation {
                        conditionalAssert(false)
                        onEndGamePressed()
                        chmgrCheckConsistency()
                    }
                }
            }
            .font(.title3)

            Spacer()

            // Game title
            Text(gameTitle)
                .font(.custom(mainFont, size: mainFontSize))

            Spacer()

            // Action menu
            ActionMenuView(
                state: .init(
                    showSettings: $showSettings,
                    showTopicSelector: $showTopicSelector,
                    showScheme: $showScheme,
                    showLeaderboard: $showLeaderboard,
                    showSendComment: $showSendComment,
                    showGameLog: $showGameLog,
                    onboardingDone: $onboardingDone,
                    showFreeportSettings: $showFreeportSettings,
                    isPlaying: playState == .playingNow,
                    showFreeport: true
                )
            )
        }
        .padding(.horizontal)
        .debugBorder()
    }
}