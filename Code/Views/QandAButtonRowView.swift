//
//  ButtonRowView.swift
//  kwanduh
//
//  Created by bill donner on 11/28/24.
//
import SwiftUI

struct QandAButtonRowView: View {
    let chmgr: ChaMan
    let gs: GameState
    let topicColor: Color

    var body: some View {
        HStack(spacing: isIpad ? 25 : 15) {
            gimmeeButton
            thumbsUpButton
            thumbsDownButton
            Spacer()
            hintButton
        }
        .foregroundColor(foregroundColorFrom(backgroundColor: topicColor))
    }

    private var gimmeeButton: some View {
        Button(action: {
            // Handle gimmee action
        }) {
            Text("Gimmee")
        }
    }

    private var thumbsUpButton: some View {
        Button(action: {
            // Handle thumbs-up action
        }) {
            Image(systemName: "hand.thumbsup")
        }
    }

    private var thumbsDownButton: some View {
        Button(action: {
            // Handle thumbs-down action
        }) {
            Image(systemName: "hand.thumbsdown")
        }
    }

    private var hintButton: some View {
        Button(action: {
            // Handle hint action
        }) {
            Text("Hint")
        }
    }
}
