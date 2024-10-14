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
  @Bindable var dmangler: Dmangler
  @Binding  var topics: [String:FreeportColor]
  @Binding  var size:Int
  
  @State var isTouching: Bool = false
  @State   var firstMove = true
  @State   var startAfresh = true
  @State   var showWinAlert = false
  @State   var showLoseAlert = false
  @State   var showCantStartAlert = false
  @State   var showSettings =  false // force it up
  @State   var showLeaderboard = false
  @State   var showSendComment = false
  @State var showTopicSelector = false
  @State var marqueeMessage =  "Hit Play to Start a New Game"
  
  @State var chal: IdentifiablePoint? = nil
  @State var isPresentingDetailView = false
  @State var isPlayingButtonState = false
 
  var actionMenu: some View {
    Menu {
      Button(action: {
      showSettings.toggle()
      }) {
        Text("Settings")
      }
      
      Button(action: {
        showTopicSelector.toggle()
      }) {
        Text("Topics")
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
    } label: {
      Image(systemName: "ellipsis.circle")
        .font(.body)
    }
    .sheet(isPresented: $showSettings) {
      SettingsScreen(chmgr: chmgr, gs: gs, lrdb: lrdb, showSettings: $showSettings)
    }
    .sheet(isPresented: $showTopicSelector) {
//      TopicSelectorView(allTopics: chmgr.everyTopicName,
//                        selectedTopics: $gs.topicsinplay, // Pass the new array of TopicColor
//                        selectedScheme: $gs.currentscheme,
//                        chmgr: chmgr,
//                        gs: gs,
//                        minTopics: GameState.minTopicsForBoardSize(l_boardsize),
//                        maxTopics: GameState.maxTopicsForBoardSize(l_boardsize),
//                        gimms: $l_gimms)
      Color.red  
    }
    .sheet(isPresented: $showLeaderboard) {
      LeaderboardScreen(leaderboardService: lrdb)
    }
    .sheet(isPresented: $showSendComment) {
      CommentsView()
    }
  }


  struct SheetView: View {
    var title: String
    
    var body: some View {
      VStack {
        Text(title)
          .font(.largeTitle)
          .padding()
        Spacer()
      }
    }
  }

  var bodyMsg: String {
    let t =  """
    That was game \(gs.gamenumber) of which:\nyou've won \(gs.woncount) and \nlost \(gs.lostcount) games
"""
    return t
  }
  
  func  onSingleTap (_ row:Int, _ col:Int ) {
       chal = IdentifiablePoint(row: row, col: col, status: chmgr.stati[row * gs.boardsize + col])

  }
  var body: some View {
    NavigationView {
      VStack(spacing:0) {
        //   topButtonsVeew.padding(.horizontal)
        //   .debugBorder()
        
        //fixed, immovable height
        MarqueeMessageView(
          message: $marqueeMessage,
          fadeInDuration: 1.0,
          fadeOutDuration: 3.0,
          displayDuration: 5.0 // Message stays visible for 5 seconds before fading out
        ).opacity(marqueeMessage.isEmpty ? 0:1)
          .frame(height:20).debugBorder()
        
        
        if gs.boardsize > 1 {
          
          MainGridView(gs: gs, chmgr:chmgr,
                       // boardsize:$gs.boardsize,
                       firstMove: $firstMove, isTouching: $isTouching, marqueeMessage: $marqueeMessage, onSingleTap: onSingleTap)
          .debugBorder()
          
          ScoreBarView(gs: gs,marqueeMessage:$marqueeMessage)
            .debugBorder()
          TopicIndexView(dmangler: dmangler,selectedTopics:$gs.topicsinplay)
//          TopicIndexView(gs:gs,chmgr:chmgr,inPlayTopics:$gs.topicsinplay,scheme: $gs.currentscheme)
          
          GameScreenBottomButtons(gs:gs, chmgr: chmgr, isTouching: $isTouching)
          
          
            .onChange(of:gs.cellstate) {
              onChangeOfCellState()
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
                                 .onAppear() {TSLog("GameScreen onAppear")  }
        .navigationBarTitle(gameTitle, displayMode: .inline)
        .navigationBarItems(trailing: actionMenu)
        .navigationBarItems(leading: playToggleButton)
    }
    
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
    }).font(.body)
    .alert("Can't start new Game - consider changing the topics or hit Full Reset",isPresented: $showCantStartAlert){
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
        dmangler: Dmangler(),
        topics:.constant(GameState.mock.topicsinplay),
       size:.constant(3)
        
      ).preferredColorScheme( .light)
    }


#Preview ("Dark") {
  GameScreen(
    gs:GameState.mock ,chmgr:
      ChaMan.mock, lrdb: LeaderboardService() ,
    dmangler: Dmangler(),
    topics:.constant(GameState.mock.topicsinplay),
   size:.constant(3)
       
      ).preferredColorScheme( .dark)
    }
