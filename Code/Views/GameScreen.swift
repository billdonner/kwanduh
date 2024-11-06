//
//  GameScreen.swift
//  basic
//
//  Created by bill donner on 6/23/24.
//
import SwiftUI

struct GameScreen: View {
  
  @Bindable var gs: GameState
  @Bindable var chmgr: ChaMan
  @Bindable var lrdb: LeaderboardService
  @Binding  var topics: [String:FreeportColor]
  @Binding  var size:Int
  
  @State var isTouching: Bool = false
  @State var firstMove = true
  @State var startAfresh = true
  @State var showWinAlert = false
  @State var showLoseAlert = false
  @State var showCantStartAlert = false
  @State var showSettings =  false // force it up
  @State var showLeaderboard = false
  @State var showSendComment = false
  @State var showGameLog = false
  @State var showTopicSelector = false
  @State var showFreeportSettings = false
  @State var showScheme = false
  @State var marqueeMessage =  "Hit Play to Start a New Game"
  
  @State var chal: IdentifiablePoint? = nil
  @State var isPresentingDetailView = false
  @State var isPlayingButtonState = false
  
  @State var useOtherDiagonalAlert : Bool = false
  @State var showOtherDiagAlert : Bool = false
  @State var diagAlertCount: Int = 0
  
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
  
  func  onSingleTap (_ row:Int, _ col:Int ) {
    chal = IdentifiablePoint(row: row, col: col, status: chmgr.stati[row * gs.boardsize + col])
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
  
  var body: some View {
    NavigationStack {
      VStack (spacing:0) {
        topBar
        
        if gs.boardsize > 1 {
          
          ScoreBarView(gs: gs,marqueeMessage:$marqueeMessage).frame(height:50)
          
          MainGridView(gs: gs, chmgr:chmgr,
                       firstMove: $firstMove,
                       isTouching: $isTouching,
                       marqueeMessage: $marqueeMessage,
                      useOtherDiagonalAlert: $useOtherDiagonalAlert,
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
              diagAlertCount = 0
            }
            .onDisappear {
              print("Yikes the GameScreen is Disappearing!")
            }
            .onChange(of:useOtherDiagonalAlert) {
              if useOtherDiagonalAlert {
                diagAlertCount += 1
                showOtherDiagAlert =  diagAlertCount == 1
                  useOtherDiagonalAlert = false
                }
              }
//            .alert("You should try the other diagonal",isPresented:$showOtherDiagAlert){
//              Button("OK", role: .cancel) {
//              }
//            }
//          
            .fullScreenCover(item: $chal) { cha in
              QandAScreen(
                chmgr: chmgr, gs: gs,
                row: cha.row, col: cha.col,
                          isPresentingDetailView: $isPresentingDetailView,
                          useOtherDiagonalAlert: $useOtherDiagonalAlert)
            }
        }
        else {
          loadingVeew
        }
      }
      .youWinAlert(isPresented: $showWinAlert, title: "You Win",
                   bodyMessage: "Good job, keep going...",
                   buttonTitle: "OK"){
        onYouWin()
      }
      .youLoseAlert(isPresented: $showLoseAlert, title: "You Lose",bodyMessage: "Lost this time, but keep going...", buttonTitle: "OK"){
        onYouLose()
      }
    }    .navigationViewStyle(StackNavigationViewStyle())
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
    }).font(.headline)//.font(.custom(mainFont,size:mainFontSize*0.9))
      .alert("You need to add at least one more topic. The total number of questions in your topics must be at least the number of boxes in your game board.",isPresented: $showCantStartAlert){
        Button("OK", role: .cancel) {
          withAnimation {
            onCantStartNewGameAction()
          }
        }
      }
  }
  
  var loadingVeew: some View {
    Text("Loading...")
      .onAppear {
        onAppearAction()
      }
      .alert("Can't start new Game from this download, sorry. \nWe will reuse your last download to start afresh.",isPresented: $showCantStartAlert){
        Button("OK", role: .cancel) {
          onCantStartNewGameAction()
        }
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

//fixed, immovable height
//        VStack {
//          if gs.gamestate ==  StateOfPlay.playingNow {
//            MarqueeMessageView(
//              message: $marqueeMessage,
//              fadeInDuration: 1.0,
//              fadeOutDuration: 3.0,
//              displayDuration: 5.0 // Message stays visible for 5 seconds before fading out
//            ).opacity(marqueeMessage.isEmpty ? 0:1)
//          } else {
//            Color.clear
//          }
//        }
//        .frame(height:20).debugBorder()
