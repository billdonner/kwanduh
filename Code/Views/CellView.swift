//
//  CellView.swift
//  kwanduh
//
//  Created by bill donner on 12/28/24.
//

import SwiftUI

struct CellView: View {
    let moveNumber: Int
    let state: GameCellState

    var body: some View {
        ZStack {
            // Background color based on cell state
            Rectangle()
                .fill(cellColor)
                .cornerRadius(5)

            // Display move number if the cell has been played
            if moveNumber >= 0 {
                Text("\(moveNumber)")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }

    // Define cell colors based on the state
    private var cellColor: Color {
        switch state {
        case .unplayed:
            return Color.blue.opacity(0.3)
        case .blocked:
            return Color.black.opacity(0.6)
        case .playedCorrectly:
            return Color.green.opacity(0.7)
        case .playedIncorrectly:
            return Color.red.opacity(0.7)
        }
    }
}
