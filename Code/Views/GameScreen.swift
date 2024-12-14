//
//  GameScreen.swift
//  basic
//
//  Created by bill donner on 6/23/24.
//
import SwiftUI

// removed firstmove



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
  
  @State var   qarb: QARBOp? = nil
  @Bindable var gs: GameState
  @Bindable var chmgr: ChaMan
  @Bindable var lrdb: LeaderboardService
  @Binding var topics: [String: FreeportColor]
  @Binding var size: Int
  
  @AppStorage("OnboardingDone") private var onboardingdone = false
  
  @State var isTouching: Bool = false
 
  @State  var isWinAlertPresented = false

  
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
  @State var otherDiagShownCount = maxShowOtherDiag
  @State var sameDiagShownCount = maxShowSameDiag
  @State var alreadyPlayed: Xdi?
  
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    GeometryReader { geometry in
      VStack(spacing:  spacing(for:geometry.size.width)) {
        // Top bar
        TopBarView(
          gs:gs,
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
            startTheGame(boardsize: gs.boardsize)
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
       // firstMove = true
      }
      .onChange(of: gs.cellstate) {
        withAnimation {
          onChangeOfCellState()
        }
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
      .fullScreenCover(isPresented: $isWinAlertPresented){
        WinAlertView(
            title: "You Win!",
            message: "Good job, keep going...",
            dismissAction: {
                isWinAlertPresented = false
                onYouWin()
            }
        )
        .background(Color.clear)
        .transition(.opacity) // Smooth fade in/out transition
        .animation(.easeInOut, value: isWinAlertPresented)
      }
      .fullScreenCover(item: $chal,onDismiss:  {
        // take a look at the binding
        guard let qarb = qarb else {
          print("QA screen returned with nil")
          return
        }
        print("QA screen return qablock \(qarb)")
        withAnimation {
          switch qarb {
            
          case .correct(let row, let col, let elapsed, let ch, let answered):
            gs.markCorrectMove(chmgr: chmgr, row: row, col:  col, ch: ch, answered:  answered, elapsedTime:  elapsed)
          case .incorrect(let row, let col, let elapsed, let ch, let answered):
            gs.markIncorrectMove(chmgr: chmgr, row: row, col:  col, ch: ch, answered:  answered, elapsedTime:  elapsed)
          case .replace(let row, let col, let elapsed):
            gs.markReplacementMove(chmgr: chmgr, row:  row, col: col, elapsedTime: elapsed)
          case .donothing :
            // should increase elapsed time
            break
          }
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
      .sheet(isPresented: $showGameLog) {
        GameLogScreen(gameState:gs, challengeManager: chmgr)
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
  
  private func nilAlert () -> Alert {
    return Alert(title:Text(""),message: Text(""),dismissButton: .cancel(Text(""), action: {
      dismiss()
    }))
  }
  
  private func alert(for type: GameAlertType) -> Alert {
   
      switch type {
      case .mustTapAdjacentCell:
        return Alert(
          title: Text("Touch a box next to one you've already played . . ."),
          dismissButton: .cancel(Text("OK"), action: { dismiss() })
        )
      case .mustStartInCorner:
        return Alert(
          title: Text("Start out in a corner"),
          dismissButton: .cancel(Text("OK"), action: { dismiss() })
        )
      case .cantStart:
        return Alert(
          title: Text("You need to add at least one more topic."),
          message: Text("The total number of questions in your topics must be at least the number of boxes in your game board."),
          dismissButton: .cancel(Text("OK"), action: { onCantStartNewGameAction() })
        )
      case .otherDiagonal:
        return  Alert(
          title: Text("Go for the other diagonal!"),
          dismissButton: .cancel(Text("OK"), action: { dismiss() })
        )
      
    case .sameSideDiagonal:
        return  Alert(
        title: Text("Winning path connects corners on opposite sides of a diagonal!"),
        dismissButton: .cancel(Text("OK"), action: { dismiss() })
      )
    case .youWin:
        return Alert(
          title: Text("You Win").font(.largeTitle),
        message: Text("Good job, keep going...").font(.title),
        dismissButton: .cancel(Text("OK"), action: { onYouWin() })
      )
    case .youLose:
        return Alert(
        title: Text("Lost this time").font(.largeTitle),
        message: Text("but keep going...").font(.largeTitle),
        dismissButton: .cancel(Text("OK"), action: { onYouLose() })
      )
    }
  }
   
}

// Win Alert View
struct WinAlertView: View {
    var title: String
    var message: String
    var dismissAction: () -> Void
    @State private var animateFireworks = false

    var body: some View {
        ZStack {
            // Semi-transparent background to allow gradient bleed
            LinearGradient(
                gradient: Gradient(colors: [Color.red.opacity(0.3), Color.blue.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                // Fireworks icon
                Image(systemName: "fireworks")
                    .resizable()
                    .scaledToFit()
                    .frame(width: animateFireworks ? 120 : 100, height: animateFireworks ? 120 : 100)
                    .foregroundColor(.red)
                    .scaleEffect(animateFireworks ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateFireworks)

                // Title
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top, 10)

                // Message
                Text(message)
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                // Dismiss button
                Button(action: dismissAction) {
                    Text("OK")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.9), Color.white.opacity(0.8)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.red.opacity(0.1), Color.blue.opacity(0.1)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(radius: 10)
            )
            .padding(.horizontal, 30)
        }
        .onAppear {
            animateFireworks = true
        }
        .onDisappear {
            animateFireworks = false
        }
    }
}
