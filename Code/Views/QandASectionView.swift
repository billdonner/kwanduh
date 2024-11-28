//
//  QuestionAndAnswersSectionView.swift
//  kwanduh
//
//  Created by bill donner on 11/28/24.
//

import SwiftUI

struct QandASectionView: View {
    let chmgr: ChaMan
    let gs: GameState
    let ch: Challenge
    let geometry: GeometryProxy
    let colorScheme: ColorScheme
    @Binding var answerGiven: String?
    @Binding var answerCorrect: Bool
    let row: Int
    let col: Int

    @State private var questionedWasAnswered = false

    var body: some View {
        VStack(spacing: 10) {
            // Question section
            QandAQuestionView(chmgr: chmgr, gs: gs, geometry: geometry, row: row, col: col)
                .frame(maxWidth: max(0, geometry.size.width), maxHeight: max(0, geometry.size.height * 0.4)) // Adjust size
            
            // Shuffle the answers and show the buttons
            QandAnswerButtonsView(
                row: row,
                col: col,
                answers: ch.answers.shuffled(),
                geometry: geometry,
                colorScheme: colorScheme,
                disabled: questionedWasAnswered,
                answerGiven: $answerGiven,
                answerCorrect: $answerCorrect
            ) { answer, row, col in
                handleAnswer(answer: answer, row: row, col: col)
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
        .frame(maxWidth: max(0, geometry.size.width), maxHeight: max(0, geometry.size.height * 0.8)) // Adjust size
    }

    private func handleAnswer(answer: String, row: Int, col: Int) {
        if !questionedWasAnswered { // Only allow one answer
            let challenge = chmgr.everyChallenge[gs.board[row][col]]
            answerCorrect = (answer == challenge.correct)
            questionedWasAnswered = true
            answerGiven = answer // Triggers the alert
        } else {
            print("Double tap: \(answer)")
        }
    }
}
