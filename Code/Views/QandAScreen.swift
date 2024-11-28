import SwiftUI

/// Represents the state of a game cell
enum GameCellState: Codable {
    case playedCorrectly
    case playedIncorrectly
    case unplayed
    case blocked
}

/// Represents the current state of play in the game
enum StateOfPlay: Int, Codable {
    case initializingApp
    case playingNow
    case justLost
    case justWon
    case justAbandoned
}

/// Represents a single game move
struct GameMove: Codable, Hashable {
    let row: Int
    let col: Int
    let movenumber: Int
}

/// Represents the status of a challenge
enum ChallengeStatus: Int, Codable {
    case inReserve, allocated, playedCorrectly, playedIncorrectly, abandoned
}


/// Represents a color mapping for topics
enum FreeportColor: Int, CaseIterable, Comparable, Codable {
    case myLightYellow, myDeepPink, myLightBlue, myRoyalBlue, myPeach, myOrange, myLavender
    case myMint, myLightCoral, myAqua, myLemon, mySkyBlue, mySunshineYellow, myOceanBlue
    case mySeafoam, myPalmGreen, myCoral, myLagoon, myShell, mySienna, myCoconut
    case myPineapple, myBurntOrange, myGoldenYellow, myCrimsonRed, myPumpkin, myChestnut
    case myHarvestGold, myAmber, myMaroon, myRusset, myMossGreen, myIceBlue, myMidnightBlue
    case myFrost, mySlate, mySilver, myPine, myBerry, myEvergreen, myStorm, myHolly
    case myBlack0, myBlack1, myBlack2, myBlack3, myBlack4, myBlack5, myBlack6, myBlack7
    case myBlack8, myBlack9, myBlackA, myBlackB, myOffWhite, myOffBlack, myGold, myHotPink
    case myDarkOrange, myDarkViolet, myDarkGreen, myCrimson, myTeal, myNavy, myGoldenrod
    case myForestGreen, myDeepTeal, myChocolate, myBrown, myDarkGoldenrod, myDarkRed
    case myOrangeRed, mySaddleBrown, myDarkOliveGreen, myPrussianBlue, myAliceBlue
    case mySteelBlue, myDarkSlateGray, myDarkGray, myWhite

    static func < (lhs: FreeportColor, rhs: FreeportColor) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

struct QandAScreen: View {
    @Bindable var chmgr: ChaMan
    @Bindable var gs: GameState
    let row: Int
    let col: Int
    @Binding var isPresentingDetailView: Bool
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme

    @State var showInfo = false
    @State var gimmeeAlert = false
    @State var answerCorrect: Bool = false
    @State var showHint: Bool = false
    @State var answerGiven: String? = nil
    @State var lastAnswerGiven: String? = nil
    @State var killTimer: Bool = false
    @State var elapsedTime: TimeInterval = 0
    @State var questionedWasAnswered: Bool = false
    @State var showThumbsUp: Challenge? = nil
    @State var showThumbsDown: Challenge? = nil

    var body: some View {
        GeometryReader { geometry in
            let ch = chmgr.everyChallenge[gs.board[row][col]]
            ZStack {
                VStack {
                    QandATopBarView(
                        gs: gs,
                        topic: ch.topic,
                        hint: ch.hint,
                        handlePass: { killTimer = true; dismiss() },
                        handleGimmee: handleGimmee,
                        toggleHint: toggleHint,
                        elapsedTime: $elapsedTime,
                        killTimer: $killTimer
                    )
                    .disabled(questionedWasAnswered)
                    .debugBorder()

          
              
                  QandASectionView (
                    chmgr: chmgr,          // Pass ChaMan object
                           gs: gs,                // Pass GameState object
                           ch: ch,
                           geometry: geometry,
                           colorScheme: colorScheme,
                           answerGiven: $answerGiven,
                           answerCorrect: $answerCorrect,
                           row: row,
                           col:col
                  )
                    .disabled(questionedWasAnswered)
                }
                .background(Color(UIColor.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 10)
                .padding(.bottom, 30)

                .hintAlert(
                    isPresented: $showHint,
                    title: "Here's Your Hint:",
                    message: ch.hint,
                    buttonTitle: "Dismiss",
                    onButtonTapped: {
                        answerGiven = nil
                        showHint = false
                    },
                    animation: .spring()
                )

                .timeoutAlert(
                    item: $answerGiven,
                    title: (answerCorrect ? "You Got It!\nThe answer is:\n" : "Sorry...\nThe answer is:\n") + ch.correct,
                    message: ch.explanation ?? "xxx",
                    buttonTitle: nil,
                    timeout: 5.0,
                    fadeOutDuration: 0.5,
                    onButtonTapped: {
                       print("onbuttontapped called ", answerGiven?.description ?? "No answer given")
                      lastAnswerGiven = answerGiven
                        dismiss() // Only dismiss the view
                    }
                )
            }
            .sheet(isPresented: $showInfo) {
                ChallengeInfoScreen(challenge: ch)
            }
            .sheet(item: $showThumbsUp) { challenge in
                PositiveSentimentView(id: challenge.id)
                    .onDisappear {
                        print("Thumbs-up sheet dismissed")
                    }
            }
            .sheet(item: $showThumbsDown) { challenge in
                NegativeSentimentView(id: challenge.id)
                    .onDisappear {
                        print("Thumbs-down sheet dismissed")
                    }
            }
        }
        .onDisappear {
            handleDismissal()
        }
    }

  private func handleDismissal() {
      guard let answer = lastAnswerGiven else {
          print("No answer to process during dismissal.")
          return
      }

      let ch = chmgr.everyChallenge[gs.board[row][col]]
      if answerCorrect {
          answeredCorrectly(ch, row: row, col: col, answered: answer)
      } else {
          answeredIncorrectly(ch, row: row, col: col, answered: answer)
      }
      questionedWasAnswered = true
      isPresentingDetailView = false
  }
}

extension QandAScreen {
    func toggleHint() {
        let hint = chmgr.everyChallenge[gs.board[row][col]].hint
        if hint.count > 1 {
            showHint.toggle()
        }
    }

    func handleGimmee() {
        killTimer = true
        let idx = gs.board[row][col]
        let result = chmgr.replaceChallenge(at: idx)
        switch result {
        case .success(let index):
            gs.gimmees -= 1
            gs.board[row][col] = index[0]
            gs.cellstate[row][col] = .unplayed
            gs.replaced[row][col].append(idx)
            gs.replacedcount += 1
            print("Gimmee reallocation successful \(index)")
        case .error(let error):
            print("Couldn't handle gimmee reallocation \(error)")
        }
        gs.saveGameState()
        dismiss()
    }

    func answeredCorrectly(_ ch: Challenge, row: Int, col: Int, answered: String) {
        processAnswer(
            ch: ch,
            row: row,
            col: col,
            answered: answered,
            status: .playedCorrectly
        ) {
            gs.rightcount += 1
            chmgr.bumpRightcount(topic: ch.topic)
        }
    }

    func answeredIncorrectly(_ ch: Challenge, row: Int, col: Int, answered: String) {
        processAnswer(
            ch: ch,
            row: row,
            col: col,
            answered: answered,
            status: .playedIncorrectly
        ) {
            gs.wrongcount += 1
            chmgr.bumpWrongcount(topic: ch.topic)
        }
    }

    private func processAnswer(
        ch: Challenge,
        row: Int,
        col: Int,
        answered: String,
        status: ChallengeStatus,
        updateStats: () -> Void
    ) {
        performConsistencyChecks(before: true)
        updateStats()
        updateGameState(for: ch, row: row, col: col, answered: answered, status: status)
        performConsistencyChecks(before: false)
    }

    private func updateGameState(
        for ch: Challenge,
        row: Int,
        col: Int,
        answered: String,
        status: ChallengeStatus
    ) {
        gs.movenumber += 1
        gs.moveindex[row][col] = gs.movenumber
        gs.cellstate[row][col] = GameCellState(from: status)
        chmgr.stati[gs.board[row][col]] = status

        chmgr.ansinfo[ch.id] = AnsweredInfo(
            id: ch.id,
            answer: answered,
            outcome: status,
            timestamp: Date(),
            timetoanswer: elapsedTime,
            gamenumber: gs.gamenumber,
            movenumber: gs.movenumber,
            row: row,
            col: col
        )

        killTimer = true
        logAnswer(ch: ch, row: row, col: col, status: status)
        gs.saveGameState()
        chmgr.save()
    }

    private func performConsistencyChecks(before: Bool) {
        let phase = before ? "before" : "after"
        chmgr.checkAllTopicConsistency("mark \(phase)")
        conditionalAssert(gs.checkVsChaMan(chmgr: chmgr, message: "answered \(phase)"))
    }

    private func logAnswer(ch: Challenge, row: Int, col: Int, status: ChallengeStatus) {
        let moveIndex = gs.moveindex[row][col]
        TSLog("Challenge \(ch.id) index: \(moveIndex) answered with status \(status)")
    }
}

extension GameCellState {
    init(from status: ChallengeStatus) {
        switch status {
        case .playedCorrectly:
            self = .playedCorrectly
        case .playedIncorrectly:
            self = .playedIncorrectly
        case .inReserve, .allocated, .abandoned:
            self = .unplayed
        }
    }
}
