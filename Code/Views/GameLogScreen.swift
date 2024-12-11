import SwiftUI

struct SingleGameLogView: View {
    let gameState: GameState
    let challengeManager: ChaMan

    var body: some View {
        VStack {
            VStack(spacing: 8) {
              Text(gameState.playstate != .playingNow ? "Game #\(gameState.gamenumber)" : "Now Playing").font(.title)
              HStack {
                Text("\(gameState.gamestart)").font(.footnote)
                Text("\(Int(gameState.totaltime)) seconds").font(.footnote)
              }
                Text("Topics: \(joinWithCommasAnd(Array(gameState.topicsinplay.keys)))").font(.footnote)
            }
            .padding(.horizontal)

            GameBoardView(gameState: gameState)
            .padding(.horizontal)

            List {
                ForEach(gameState.moveHistory(), id: \.self) { move in
                    VStack(alignment: .leading, spacing: 4) {
                        let row = move.row
                        let col = move.col
                        let replacedChallenges = gameState.replaced[row][col] // Track replacements
                        let challenge = challengeManager.everyChallenge[gameState.board[row][col]]
                        let answerInfo = challengeManager.ansinfo[challenge.id]
                        let statusSymbol: String = switch gameState.cellstate[row][col] {
                        case .playedCorrectly: "✅"
                        case .playedIncorrectly: "❌"
                        default: ""
                        }

                        Text("\(move.movenumber):")
                            .font(.headline)

                        Text("Question: \(challenge.question)")
                            .font(.headline)

                        if let ansInfo = answerInfo {
                            Text("Your Answer: \(ansInfo.answer) \(statusSymbol)")
                                .font(.caption)
                        }

                        if !replacedChallenges.isEmpty {
                            Text("Replaced Challenges:")
                                .font(.caption)
                            ForEach(replacedChallenges, id: \.self) { repIndex in
                                let replacedChallenge = challengeManager.everyChallenge[repIndex]
                                Text("-> \(replacedChallenge.question)")
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .padding(.horizontal)

            Spacer()

            // Display game state message
            switch gameState.playstate {
            case .initializingApp:
                Text("Not currently playing")
            case .playingNow:
                Text("Currently playing")
            case .justLost:
                Text("You lost 😞")
            case .justWon:
                Text("You won! 😎")
                Text("Winning Path: \(gameState.prettyPathOfGameMoves())")
            case .justAbandoned:
                Text("Game abandoned")
            }
        }
        .padding()
    }
}
struct GameLogScreen: View {
   let  gameState: GameState
    let challengeManager: ChaMan

  var body: some View {
    VStack{
      let paths = gameState.savedGamePaths
        TabView {
          if gameState.playstate  == .playingNow {
            SingleGameLogView(gameState: gameState, challengeManager: challengeManager)
          }
          if !paths.isEmpty {
            ForEach(paths.reversed(), id: \.self) { path in
              if let loadedGameState = GameState.loadGameStateFromFile(at: path) {
                SingleGameLogView(gameState: loadedGameState, challengeManager: challengeManager)
              } else {
                Text("Failed to load game at path: \(path)")
                  .foregroundColor(.red)
                  .padding()
              }
            }
          }
        }
        .tabViewStyle(PageTabViewStyle())
      
    }.dismissable {
  print ("dismissed")
    }
  }
}
