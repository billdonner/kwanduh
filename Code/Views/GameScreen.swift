//
//  GameScreen.swift
//  basic
//
//  Created by bill donner on 6/23/24.
//
import SwiftUI
struct Xdi: Identifiable
{
  let row:Int
  let col:Int
  let challenge: Challenge
  let id=UUID()
}
struct GameScreen: View {
  
  @Bindable var gs: GameState
  @Bindable var chmgr: ChaMan
  @Bindable var lrdb: LeaderboardService
  @Binding  var topics: [String:FreeportColor]
  @Binding  var size:Int
  
  @State var isTouching: Bool = false
  @State var firstMove = true
  @State var startAfresh = true
  
  @State var showSettings =  false // force it up
  @State var showLeaderboard = false
  @State var showSendComment = false
  @State var showGameLog = false
  @State var showTopicSelector = false
  @State var showFreeportSettings = false
  @State var showScheme = false
  // @State var marqueeMessage =  "Hit Play to Start a New Game"
  
  @State var chal: IdentifiablePoint? = nil
  @State var nowShowingQandAScreen = false
  @State var isPlayingButtonState = false
  

  @State var showOtherDiagAlert : Bool = false
  @State var didshowOtherDiagAlert : Bool = false
  
  @State var showWinAlert = false
  @State var showLoseAlert = false
  @State var showCantStartAlert = false
  @State var showMustStartInCornerAlert : Bool = false
  
  @State var showMustTapAdjacentCellAlert : Bool = false
  
  @State var showSameSideAlert = false
  
  @State var alreadyPlayed: Xdi?
  
  @Environment(\.dismiss) var dismiss
  // process single tap
  func  onSingleTap (_ row:Int, _ col:Int ) {
    var validTap = false
    
    // if this cell is already played then trigger a full screen cover to present it
    if gs.isAlreadyPlayed(row: row, col: col) {
      alreadyPlayed = Xdi(row: row, col: col,challenge: chmgr.everyChallenge[     gs.board[row][col]])
      return
    }
    // otherwise its not played yet
    //When a player tries to start the game in a box other than a corner, post the message "Start out in a corner . . ."
    if firstMove && !gs.isCornerCell(row:row,col:col) {
      showMustStartInCornerAlert = true
      return
    }
    //If a player tries to play a box that is not adjacent to a played box, post the message "Touch a box next to one you've already played . . ."
    
    if !firstMove && !gs.isCornerCell(row:row,col:col) && !hasAdjacentNeighbor(withStates: [.playedCorrectly, .playedIncorrectly], in: gs.cellstate, for: (row, col)) {
      showMustTapAdjacentCellAlert = true
      return
    }
    
 


    
    // if not playing ignore all other taps
    if gs.gamestate == .playingNow,
       gs.cellstate[row][col] == .unplayed {
      // consider valid tap if first move corner cell
      // or not first and either a corner or with an adjacent neighbor thats been played
      validTap = firstMove ? gs.isCornerCell(row: row, col: col) : (gs.isCornerCell(row: row, col: col) || hasAdjacentNeighbor(withStates: [.playedCorrectly, .playedIncorrectly], in: gs.cellstate, for: (row, col)))
    }

    if validTap {
      gs.lastmove = GameMove(row: row, col: col, movenumber: gs.movenumber)
      firstMove = false
      // this kicks off  the fullscreencover of the QandAScreen
      chal = IdentifiablePoint(row: row, col: col, status: chmgr.stati[row * gs.boardsize + col])
    }
  }
  
  
  // evaluate winners and losers
  func onChangeOfCellState() {
    print("**************onChangeOfCellState****************")
    let (path,iswinner) = winningPath(in:gs.cellstate)
    if iswinner {
      print("--->YOU WIN path is \(path)")
      for p in path {
        gs.onwinpath[p.0][p.1] = true
      }
      showWinAlert = true
      return
    }
    if !isPossibleWinningPath(in:gs.cellstate) {
      print("--->YOU LOSE")
      showLoseAlert = true
      return
    }
    //If you lose in both corners post a message to try the other diagonal Message should say "Go for the other diagonal!" showOtherDiagAlert
//    
//    if gs.cellstate[0][0] == .playedIncorrectly || gs.cellstate[gs.boardsize-1] [gs.boardsize-1] == .playedIncorrectly {
//      if !didshowOtherDiagAlert {showOtherDiagAlert = true
//        didshowOtherDiagAlert = true}
//      return
//    }
//    if gs.cellstate[0][gs.boardsize-1] == .playedIncorrectly || gs.cellstate[gs.boardsize-1] [0] == .playedIncorrectly {
//      if !didshowOtherDiagAlert {showOtherDiagAlert = true
//        didshowOtherDiagAlert = true}
//      return
//    }
  }
  
  //UI
  var body: some View {
    NavigationStack {
      VStack (spacing:0) {
        topBar
        ScoreBarView(gs: gs).frame(height:50)
        
        MainGridView(gs: gs, chmgr:chmgr,
                     firstMove: $firstMove,
                     isTouching: $isTouching,
                     onSingleTap: onSingleTap)
        
        TopicIndexView(gs:gs,chmgr:chmgr,selectedTopics:$gs.topicsinplay, topicsInOrder:$gs.topicsinorder, opType: .showDetails,isTouching:$isTouching)
        
        GameScreenBottomButtons(gs:gs, chmgr: chmgr, isTouching: $isTouching)
        
          .onChange(of:gs.cellstate) {
            onChangeOfCellState()
          }
          .onChange(of:gs.currentscheme) {
            gs.topicsinplay = colorize(scheme: gs.currentscheme,topics: Array(gs.topicsinplay.keys)) // do not change ordering
            gs.saveGameState()
          }
          .onAppear {
            firstMove = true
          }
          .onDisappear {
            print("Yikes the GameScreen is Disappearing!")
          }
      }
      
      
      .fullScreenCover(item: $alreadyPlayed) { xdi in
        if let ansinfo = chmgr.ansinfo[xdi.challenge.id] {
          ReplayingScreen(ch: xdi.challenge, ansinfo: ansinfo, gs: gs)
        }
      }
      
      .fullScreenCover(item: $chal) { cha in
        QandAScreen(
          chmgr: chmgr, gs: gs,
          row: cha.row, col: cha.col,
          isPresentingDetailView: $nowShowingQandAScreen)
      }
      
      .alert (
        "Touch a box next to one you've already played . . ."
        ,isPresented: $showMustTapAdjacentCellAlert) {
          Button("OK", role: .cancel) {
            withAnimation {
              dismiss()
            }
          }
        }
        .alert ("Go for the other diagonal!",isPresented: $showOtherDiagAlert ) {
          Button("OK", role: .cancel) {
            withAnimation {
              dismiss()
            }
          }
        }
        .alert ("Start out in a corner",isPresented: $showMustStartInCornerAlert) {
          Button("OK", role: .cancel) {
            withAnimation {
              dismiss()
            }
          }
        }
        .alert("You need to add at least one more topic. The total number of questions in your topics must be at least the number of boxes in your game board.",isPresented: $showCantStartAlert){
          Button("OK", role: .cancel) {
            withAnimation {
              onCantStartNewGameAction()
            }
          }
        }
        .youWinAlert(isPresented: $showWinAlert, title: "You Win",
                     bodyMessage: "Good job, keep going...",
                     buttonTitle: "OK"){ onYouWin()}
      
                     .youLoseAlert(isPresented: $showLoseAlert, title: "You Lose",bodyMessage: "Lost this time, but keep going...", buttonTitle: "OK"){onYouLose()}
      
    }.navigationViewStyle(StackNavigationViewStyle())
  }
  
  var playToggleButton: some View {
    Button(gs.gamestate ==  StateOfPlay.playingNow  ? "End " : "Play"  ,  action: {
      isPlayingButtonState.toggle()
      if gs.gamestate !=  StateOfPlay.playingNow {
        withAnimation {
          let ok =  onStartGame(boardsize: gs.boardsize)
          if !ok {
            showCantStartAlert = true
          }
          chmgr.checkAllTopicConsistency("GameScreen StartGamePressed")
          conditionalAssert(gs.checkVsChaMan(chmgr: chmgr))
        }
      } else {
        // this one has been trouble
        // conditionalAssert(gs.checkVsChaMan(chmgr: chmgr)) //cant check after endgamepressed
        isTouching = true
        onEndGamePressed()  //should estore consistency
        chmgr.checkAllTopicConsistency("GameScreen EndGamePressed")
      }
    }).font(.headline)
  }
  
  var loadingVeew: some View {
    Text("Loading...")
      .onAppear {
        onAppearAction()
      }
  }
  
  var actionMenu: some View {
    Menu {
      Button(action: {
        showSettings.toggle()
      }) {
        Text("Select Board Size")
      }.disabled(gs.gamestate == .playingNow)
      
      Button(action: {
        showTopicSelector.toggle()
      }) {
        Text("Select Topics")
      }.disabled(gs.gamestate == .playingNow)
      Button(action: {
        showScheme.toggle()
      }) {
        Text("Select Color Scheme")
      }
      Button(action: {
        showLeaderboard.toggle()
      }) {
        Text("Leaderboard")
      }
      
      Button(action: {
        showSendComment.toggle()
      }) {
        Text("Contact Us")
      }
      Button(action: {
        showGameLog.toggle()
      }) {
        Text("Game History")
      }
      if showFreeport {
        Button(action: {
          showFreeportSettings.toggle()
        }) {
          Text("Freeport Software")
        }
      }
    } label: {
      Image(systemName: "ellipsis.circle")
        .font(.headline)
        .padding(.leading, 20)
        .padding(.trailing,10)
      // .font(.custom(mainFont,size:mainFontSize*0.9))
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
  }
  
  var topBar: some View {
    return HStack {
      playToggleButton.padding(.leading,15)
      Spacer()
      Text(gameTitle).font(.custom(mainFont,size:mainFontSize))
      Spacer()
      actionMenu.padding(.trailing,10)
    }
  }
  
}
#Preview ("GameScreen") {
  GameScreen(
    gs:GameState.mock ,chmgr:
      ChaMan.mock, lrdb: LeaderboardService() ,
    topics:.constant(GameState.mock.topicsinplay),
    size:.constant(3)
  ).preferredColorScheme( .light)
}

#Preview ("Dark") {
  GameScreen(
    gs:GameState.mock ,chmgr:
      ChaMan.mock, lrdb: LeaderboardService() ,
    topics:.constant(GameState.mock.topicsinplay),
    size:.constant(3)
  ).preferredColorScheme( .dark)
}
