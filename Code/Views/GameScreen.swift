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
  @State var showTopicSelector = false
  @State var showFreeport = false
  @State var showScheme = false
  @State var marqueeMessage =  "Hit Play to Start a New Game"
  
  @State var chal: IdentifiablePoint? = nil
  @State var isPresentingDetailView = false
  @State var isPlayingButtonState = false
  
  var actionMenu: some View {
    Menu {
      Button(action: {
        showSettings.toggle()
      }) {
        Text("Board Size")
      }.disabled(gs.gamestate == .playingNow)
      
      Button(action: {
        showTopicSelector.toggle()
      }) {
        Text("Topics")
      }.disabled(gs.gamestate == .playingNow)
      
      Button(action: {
        showLeaderboard.toggle()
      }) {
        Text("Leaderboard")
      }
      Button(action: {
        showScheme.toggle()
      }) {
        Text("Color Scheme")
      }
      Button(action: {
        showSendComment.toggle()
      }) {
        Text("Contact Us")
      }
      Button(action: {
        showFreeport.toggle()
      }) {
        Text("Freeport Software")
      }
    } label: {
      Image(systemName: "ellipsis.circle")
        .font(.title)
    }
    .sheet(isPresented: $showSettings) {
      SettingsScreen(chmgr: chmgr, gs: gs, lrdb: lrdb, showSettings: $showSettings)
    }
    .sheet(isPresented: $showTopicSelector) {
      TopicSelectorView(gs:gs, chmgr:chmgr ,gimmeCount: $gs.gimmees, isTouching: $isTouching)
    }
    .sheet(isPresented: $showLeaderboard) {
      LeaderboardScreen(leaderboardService: lrdb)
    }
    .sheet(isPresented: $showScheme) {
      SchemePickerView(gs:gs,chmgr:chmgr)
    }
    .sheet(isPresented: $showSendComment) {
      CommentsView()
    }
    .sheet(isPresented: $showFreeport) {
      FreeportSettingsScreen(gs: gs, chmgr: chmgr, lrdb: lrdb, showSettings: $showSettings)
    }
  }
  
  var bodyMsg: String {
    let t =  """
   you've won \(gs.woncount) and \nlost \(gs.lostcount) games
"""
    return t
  }
  
  func  onSingleTap (_ row:Int, _ col:Int ) {
    chal = IdentifiablePoint(row: row, col: col, status: chmgr.stati[row * gs.boardsize + col])
  }
  var body: some View {
    NavigationStack {
      VStack(spacing:0) {
      HStack {
        playToggleButton.padding(.horizontal,10)
        Spacer()
        Text(gameTitle).font(.custom("Georgia-Bold",size:48))
        Spacer()
        actionMenu.padding(.horizontal,10)
      }

        
   
        //fixed, immovable height
        VStack {
          if gs.gamestate ==  StateOfPlay.playingNow {
            MarqueeMessageView(
              message: $marqueeMessage,
              fadeInDuration: 1.0,
              fadeOutDuration: 3.0,
              displayDuration: 5.0 // Message stays visible for 5 seconds before fading out
            ).opacity(marqueeMessage.isEmpty ? 0:1)
            
          } else {
            Color.clear
          }
        }
        .frame(height:20).debugBorder()
        
        
        if gs.boardsize > 1 {
          
          MainGridView(gs: gs, chmgr:chmgr,
                       firstMove: $firstMove,
                       isTouching: $isTouching,
                       marqueeMessage: $marqueeMessage,
                       onSingleTap: onSingleTap)
          
          ScoreBarView(gs: gs,marqueeMessage:$marqueeMessage).debugBorder()
          
          TopicIndexView(gs:gs,chmgr:chmgr,selectedTopics:$gs.topicsinplay, opType: .showDetails,isTouching: $isTouching)
          
          GameScreenBottomButtons(gs:gs, chmgr: chmgr, isTouching: $isTouching)
          
            .onChange(of:gs.cellstate) {
              onChangeOfCellState()
            }
            .onChange(of:gs.currentscheme) {
              //print("gs.currentscheme has changed to \(gs.currentscheme)")
              gs.topicsinplay = colorize(scheme: gs.currentscheme,topics: Array(gs.topicsinplay.keys))
              gs.saveGameState()
            }
          
            .onDisappear {
              print("Yikes the GameScreen is Disappearing!")
            }
          
            .fullScreenCover(item: $chal) { cha in
              QandAScreen(row: cha.row, col: cha.col,
                          isPresentingDetailView: $isPresentingDetailView, chmgr: chmgr, gs: gs)
            }
        }
        else {
          loadingVeew
        }
      }
    .youWinAlert(isPresented: $showWinAlert, title: "You Win",
                 bodyMessage: bodyMsg, buttonTitle: "OK"){
      onYouWin()
    }
                 .youLoseAlert(isPresented: $showLoseAlert, title: "You Lose",
                               bodyMessage: bodyMsg, buttonTitle: "OK"){
                   onYouLose()
                 }
                               .onAppear() {
                                 TSLog("GameScreen onAppear")
                               }
//                               .navigationTitle("")
//                               .navigationBarTitleDisplayMode(.inline)
//                               .navigationBarItems(trailing: actionMenu)
//                               .navigationBarItems(leading: playToggleButton)
  }    .navigationViewStyle(StackNavigationViewStyle())
  
    
  }
  
  var playToggleButton: some View {
    Button(gs.gamestate ==  StateOfPlay.playingNow  ? "End" : "Play"  ,  action: {
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
    }).font(.title)
    
      .alert("Can't start new Game because you don't have enough unanswered questions in the topics you have selected - you will need to change your topics",isPresented: $showCantStartAlert){
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
