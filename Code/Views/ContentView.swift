import SwiftUI

struct ContentView: View {
  @State var restartCount = 0
  @Bindable var gs: GameState
  @Bindable var chmgr: ChaMan
  @Bindable var lrdb: LeaderboardService
  @State var gimmeeAlert = false
  @State var current_size: Int = starting_size  //defined in mainapp
  @State var current_topics: [String: FreeportColor] = [:]

  fileprivate func loadAndSetupBoard() {
    chmgr.loadAllData(gs: gs)
    chmgr.checkAllTopicConsistency("ContentView onAppear0")
    current_size = gs.boardsize
    if gs.topicsinplay.count == 0 {
      gs.topicsinplay = colorize(
        scheme: gs.currentscheme,
        topics: getRandomTopics(
          GameState.preselectedTopicsForBoardSize(current_size),
          from: chmgr.everyTopicName))
      gs.topicsinorder = gs.topicsinplay.keys.sorted()
    }
  }

  var body: some View {
    GameScreen(
      gs: gs, chmgr: chmgr, lrdb: lrdb, topics: $current_topics,
      size: $current_size
    )
    .onAppear {
      if gs.veryfirstgame {
    
        loadAndSetupBoard()
        if gs.gimmees == 0 {gimmeeAlert = true}
        current_topics = gs.topicsinplay
        chmgr.checkAllTopicConsistency("ContentView onAppear2")

      }
      
        TSLog(
            """
            //ContentView  size:\(current_size) topics:\(gs.topicsinplay.count)     alloc:\(chmgr.allocatedChallengesCount()) free:\(chmgr.freeChallengesCount())
              gamestate:\(gs.playstate)
   """
        )
      restartCount += 1
      gs.veryfirstgame = false
      gs.saveGameState()
    }
    .alert("We are giving you 5 gimmees to get started!",isPresented:$gimmeeAlert) {
      Button("OK", role: .cancel) {
        withAnimation {
          gs.gimmees = 5  // give some to get started
        }
      }
    }
    .onDisappear {
      print("Yikes the ContentView is Disappearing!")
    }
  }
}

#Preview("light") {
  ContentView(
    gs: GameState.mock,
    chmgr: ChaMan.mock,
    lrdb: LeaderboardService())
}
#Preview("dark") {
  ContentView(
    gs: GameState.mock,
    chmgr: ChaMan.mock,
    lrdb: LeaderboardService()
  )
  .preferredColorScheme( /*@START_MENU_TOKEN@*/.dark /*@END_MENU_TOKEN@*/)
}
