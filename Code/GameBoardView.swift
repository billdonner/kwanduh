//
//  File.swift
//  kwanduh
//
//  Created by bill donner on 12/28/24.
//


///
///
///
//
//  GameStateExt.swift
//  kwanduh
//
//  Created by bill donner on 10/27/24.
//
import SwiftUI
struct GameBoardView: View {
    let gameState: GameState // Use GameState to provide data

    var body: some View {
        VStack(spacing: 2) { // Vertical stack for rows
            ForEach(0..<gameState.boardsize, id: \.self) { row in
                HStack(spacing: 2) { // Horizontal stack for columns
                    ForEach(0..<gameState.boardsize, id: \.self) { col in
                        CellView(
                            moveNumber: gameState.moveindex[row][col],
                            state: gameState.cellstate[row][col]
                        )
                        .frame(width: 50, height: 50) // Adjust cell size as needed
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}
