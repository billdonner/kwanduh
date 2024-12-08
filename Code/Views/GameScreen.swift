//
//  GameScreen.swift
//  basic
//
//  Created by bill donner on 6/23/24.
//
import SwiftUI

enum GameAlertType: Identifiable {
    case mustTapAdjacentCell
    case mustStartInCorner
    case cantStart
    case otherDiagonal
    case sameSideDiagonal
    case youWin
    case youLose

    var id: String {
        switch self {
        case .mustTapAdjacentCell: return "mustTapAdjacentCell"
        case .mustStartInCorner: return "mustStartInCorner"
        case .cantStart: return "cantStart"
        case .otherDiagonal: return "otherDiagonal"
        case .sameSideDiagonal: return "sameSideDiagonal"
        case .youWin: return "youWin"
        case .youLose: return "youLose"
        }
    }
}
 
struct GameScreen: View {
  
  struct Xdi: Identifiable
  {
    let row:Int
    let col:Int
    let challenge: Challenge
    let id=UUID()
  }
  
  @State var   qarb: QAReturnBlock? = nil
    @Bindable var gs: GameState
    @Bindable var chmgr: ChaMan
    @Bindable var lrdb: LeaderboardService
    @Binding var topics: [String: FreeportColor]
    @Binding var size: Int

    @AppStorage("OnboardingDone") private var onboardingdone = false
 
    @State var isTouching: Bool = false
    @State var firstMove = true

    @State var showSettings = false
    @State var showLeaderboard = false
    @State var showSendComment = false
    @State var showGameLog = false
    @State var showTopicSelector = false
    @State var showFreeportSettings = false
    @State var showScheme = false

    @State var chal: IdentifiablePoint? = nil
    @State var nowShowingQandAScreen = false
    @State var isPlayingButtonState = false

    @State var activeAlert: GameAlertType?

    @State var alreadyPlayed: Xdi?

    @Environment(\.dismiss) var dismiss

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: geometry.size.width < 400 ? 0 : 30) {
                // Top bar
                TopBarView(
                    playState: $gs.playstate,
                    isPlayingButtonState: $isPlayingButtonState,
                    showSettings: $showSettings,
                    showTopicSelector: $showTopicSelector,
                    showScheme: $showScheme,
                    showLeaderboard: $showLeaderboard,
                    showSendComment: $showSendComment,
                    showGameLog: $showGameLog,
                    onboardingDone: $onboardingdone,
                    showFreeportSettings: $showFreeportSettings,
                    gameTitle: gameTitle,
                    onStartGame: {
                        onStartGame(boardsize: gs.boardsize)
                    },
                    onEndGamePressed: {
                        onEndGamePressed()
                    },
                    chmgrCheckConsistency: {
                        chmgr.checkAllTopicConsistency("GameScreen")
                    },
                    conditionalAssert: { condition in
                        let _ = gs.checkVsChaMan(chmgr: chmgr, message: "GameScreen")
                    }
                )

                // Score bar
                ScoreBarView(gs: gs)
                    .frame(height: 40)
                    .layoutPriority(1)

                // Main game grid
                MainGridView(
                    gs: gs,
                    chmgr: chmgr,
                    firstMove: $firstMove,
                    isTouching: $isTouching,
                    onSingleTap: onSingleTap
                )
                .frame(width: geometry.size.width, height: geometry.size.width)
                .debugBorder()

                // Topic index
                TopicIndexView(
                    gs: gs,
                    chmgr: chmgr,
                    selectedTopics: $gs.topicsinplay,
                    topicsInOrder: $gs.topicsinorder,
                    opType: .showDetails,
                    isTouching: $isTouching
                )

                // Bottom buttons
                GameScreenBottomButtons(
                    gs: gs,
                    chmgr: chmgr,
                    isTouching: $isTouching
                )
                .layoutPriority(2)
            }
            .debugBorder()
            .onAppear {
                firstMove = true
            }
            .onChange(of: gs.cellstate) {
                onChangeOfCellState()
            }
            .onChange(of: gs.currentscheme) {
                gs.topicsinplay = colorize(scheme: gs.currentscheme, topics: Array(gs.topicsinplay.keys))
                gs.saveGameState()
            }
            .fullScreenCover(item: $alreadyPlayed) { xdi in
                if let ansinfo = chmgr.ansinfo[xdi.challenge.id] {
                    ReplayingScreen(ch: xdi.challenge, ansinfo: ansinfo, gs: gs)
                }
            }
            .fullScreenCover(item: $chal,onDismiss:  {
              // take a look at the binding
            guard let qarb = qarb else {
                print("QA screen returned with nil")
              return
              }
                print("QA screen return qablock \(qarb)")
              switch qarb.op {
              case .correct:
                gs.markCorrectMove(chmgr: chmgr, row: qarb.row, col: qarb.col, ch: qarb.ch, answered: qarb.answered, elapsedTime: qarb.elapsed)
              case .incorrect:
                gs.markIncorrectMove(chmgr: chmgr, row: qarb.row, col: qarb.col, ch: qarb.ch, answered: qarb.answered, elapsedTime: qarb.elapsed)
              case .replace:
                break
              case .donothing:
                break
              }
            }) { cha in
                QandAScreen(
                    chmgr: chmgr, gs: gs,
                    row: cha.row, col: cha.col,
                    isPresentingDetailView: $nowShowingQandAScreen, qarb: $qarb
                )
            }
          
          .sheet(isPresented: $showSettings) {
            BoardSizeScreen(chmgr: chmgr, gs: gs, showSettings: $showSettings)
          }
          .sheet(isPresented: $showTopicSelector) {
            TopicSelectorScreen(gs:gs, chmgr:chmgr ,gimmeCount: $gs.gimmees, isTouching: $isTouching)
          }
          .fullScreenCover(isPresented: $showLeaderboard) {
            LeaderboardScreen(leaderboardService: lrdb)
          }
          .sheet(isPresented: $showScheme) {
            SchemePickerView(gs:gs,chmgr:chmgr)
          }
          .sheet(isPresented: $showSendComment) {
            CommentsView()
          }
          .fullScreenCover(isPresented: $showGameLog) {
            GameLogScreen(gs:gs, chmgr: chmgr)
          }
          .sheet(isPresented: $showFreeportSettings) {
            FreeportSettingsScreen(gs: gs, chmgr: chmgr, lrdb: lrdb, showSettings: $showSettings)
          }
            .alert(item: $activeAlert) { alertType in
                alert(for: alertType)
            }
        }
    }

    // Generates the appropriate alert based on the activeAlert state

    private func alert(for type: GameAlertType) -> Alert {
      
        switch type {
        case .mustTapAdjacentCell:
          Alert(
            title: Text("Touch a box next to one you've already played . . ."),
            dismissButton: .cancel(Text("OK"), action: { dismiss() })
          )
        case .mustStartInCorner:
          Alert(
            title: Text("Start out in a corner"),
            dismissButton: .cancel(Text("OK"), action: { dismiss() })
          )
        case .cantStart:
          Alert(
            title: Text("You need to add at least one more topic."),
            message: Text("The total number of questions in your topics must be at least the number of boxes in your game board."),
            dismissButton: .cancel(Text("OK"), action: { onCantStartNewGameAction() })
          )
        case .otherDiagonal:
          Alert(
            title: Text("Go for the other diagonal!"),
            dismissButton: .cancel(Text("OK"), action: { dismiss() })
          )
        case .sameSideDiagonal:
          Alert(
            title: Text("Winning path connects corners on opposite sides of a diagonal!"),
            dismissButton: .cancel(Text("OK"), action: { dismiss() })
          )
        case .youWin:
          Alert(
            title: Text("You Win"),
            message: Text("Good job, keep going..."),
            dismissButton: .cancel(Text("OK"), action: { onYouWin() })
          )
        case .youLose:
          Alert(
                title: Text("You Lose"),
                message: Text("Lost this time, but keep going..."),
                dismissButton: .cancel(Text("OK"), action: { onYouLose() })
            )
        }
    }
}
