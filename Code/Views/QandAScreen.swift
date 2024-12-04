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
struct QandATopBarView: View {
  let gs:GameState
  let topic: String
  let hint:String
  let handlePass: () -> Void
  let handleGimmee: () -> Void
  let toggleHint: () -> Void
  @Binding var elapsedTime: TimeInterval   // Elapsed time in seconds
  @Binding var killTimer: Bool
  
  @State private var timer: Timer? = nil  // Timer to track elapsed time
  
  func startTimer() {
    elapsedTime = 0
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      elapsedTime += 1
    }
  }
  
  public func stopTimer() {
    // guard against doing this twice
    if timer != nil {
      gs.totaltime += elapsedTime
      timer?.invalidate()
      timer = nil
    }
  }
  
  var formattedElapsedTime: String {
    let minutes = Int(elapsedTime) / 60
    let seconds = Int(elapsedTime) % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
  
  var body: some View {
    ZStack {
      HStack(alignment: .top ) {
        VStack(alignment:.leading) {
          Text(topic).multilineTextAlignment(.leading)
            .font(.headline)
            .lineLimit(2,reservesSpace: true)
            .foregroundColor(.primary)
          elapsedTimeView
          additionalInfoView
        }.padding()
        Spacer()
        Button(action: {
          handlePass()
        }) {
          Image(systemName: "xmark")
            .font(.title)
            .foregroundColor(.primary)
          
        }
        .padding( )
      }.padding(.top)
      
    }.debugBorder()
      .onAppear {
        startTimer()
      }
      .onDisappear {
        stopTimer()
      }
      .onChange(of: killTimer) { oldValue, newValue in
        stopTimer()
      }
  }
  
  
  var elapsedTimeView: some View {
    Text("time to answer: \(formattedElapsedTime)")
      .font(.footnote)
      .foregroundColor(.secondary)
  }
  
  var additionalInfoView: some View {
    Text("score:\(gs.totalScore()) gimmees:\(gs.gimmees)")
      .font(.footnote)
      .foregroundColor(.secondary)
  }
}

struct QandAScreen: View {
    @Bindable var chmgr: ChaMan
    @Bindable var gs: GameState
    let row: Int
    let col: Int
    @Binding var isPresentingDetailView: Bool
    @Environment(\.dismiss) var dismiss

    @State var gimmeeAlert = false
    @State var answerCorrect: Bool = false
    @State var showHint: Bool = false
    @State var answerGiven: String? = nil
    @State var lastAnswerGiven: String? = nil
    @State var killTimer: Bool = false
  @State private var elapsedTime: TimeInterval = 0  // Add this property to QandAScreen
    @State var questionedWasAnswered: Bool = false
    @State var showThumbsUp: Challenge? = nil
    @State var showThumbsDown: Challenge? = nil

    var body: some View {
        GeometryReader { geometry in
            let challenge = chmgr.everyChallenge[gs.board[row][col]]
            ZStack {
                VStack {
                  QandATopBarView(
                      gs: gs,
                      topic: challenge.topic,
                      hint: challenge.hint,
                      handlePass: { killTimer = true; dismiss() },
                      handleGimmee: handleGimmee,
                      toggleHint: toggleHint,
                      elapsedTime: $elapsedTime,  // Correctly pass elapsedTime as a binding
                      killTimer: $killTimer       // Pass killTimer as expected
                  )
                    .disabled(questionedWasAnswered)

                    QandASectionView(
                        chmgr: chmgr,
                        gs: gs,
                        challenge: challenge,
                        geometry: geometry,
                        answerGiven: $answerGiven,
                        answerCorrect: $answerCorrect,
                        row: row,
                        col: col,
                        gimmeeAlert: $gimmeeAlert,
                        toggleHint: toggleHint,
                        showThumbsUp: { showThumbsUp = $0 },
                        showThumbsDown: { showThumbsDown = $0 }
                    )
                    .disabled(questionedWasAnswered)
                }
                .background(Color(UIColor.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 10)
                .padding(.bottom, 30)
            }
        }
        .onDisappear {
            handleDismissal()
        }
    }

    private func handleDismissal() {
        guard let answer = lastAnswerGiven else { return }
        let challenge = chmgr.everyChallenge[gs.board[row][col]]
        if answerCorrect {
            answeredCorrectly(challenge, row: row, col: col, answered: answer)
        } else {
            answeredIncorrectly(challenge, row: row, col: col, answered: answer)
        }
        questionedWasAnswered = true
        isPresentingDetailView = false
    }

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

struct QandASectionView: View {
    let chmgr: ChaMan
    let gs: GameState
    let challenge: Challenge
    let geometry: GeometryProxy
    @Binding var answerGiven: String?
    @Binding var answerCorrect: Bool
    let row: Int
    let col: Int
    @Binding var gimmeeAlert: Bool
    let toggleHint: () -> Void
    let showThumbsUp: (Challenge) -> Void
    let showThumbsDown: (Challenge) -> Void

    var body: some View {
        VStack(spacing: 10) {
            QandAButtonsView(
                gimmeeAlert: $gimmeeAlert,
                gimmees: gs.gimmees,
                challenge: challenge,
                toggleHint: toggleHint,
                showThumbsUp: showThumbsUp,
                showThumbsDown: showThumbsDown
            )
            Text(challenge.question)
                .font(.title3)
        }
    }
}

struct QandAButtonsView: View {
    @Binding var gimmeeAlert: Bool
    let gimmees: Int
    let challenge: Challenge
    let toggleHint: () -> Void
    let showThumbsUp: (Challenge) -> Void
    let showThumbsDown: (Challenge) -> Void

    var body: some View {
        HStack(spacing: 15) {
            Button(action: { gimmeeAlert = true }) {
                Image(systemName: "arrow.trianglehead.2.clockwise")
            }
            .disabled(gimmees < 1)

            Button(action: toggleHint) {
                Image(systemName: "lightbulb")
            }
            .disabled(challenge.hint.count <= 1)

            Button(action: { showThumbsUp(challenge) }) {
                Image(systemName: "hand.thumbsup")
            }

            Button(action: { showThumbsDown(challenge) }) {
                Image(systemName: "hand.thumbsdown")
            }
        }
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
