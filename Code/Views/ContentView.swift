import SwiftUI

struct ContentView: View {
  @State var restartCount = 0
  @Bindable var gs: GameState
  @Bindable var chmgr: ChaMan
  @Bindable var lrdb: LeaderboardService
 // @State var gimmeeAlert = false
  @State var current_size: Int = starting_size
  @State var current_topics: [String:FreeportColor] = [:]

  
  var body: some View {
    GameScreen(gs: gs, chmgr: chmgr, lrdb:lrdb, topics: $current_topics, size: $current_size)
          .onAppear {
            if gs.veryfirstgame {
              chmgr.loadAllData(gs: gs)
              chmgr.checkAllTopicConsistency("ContentView onAppear0")
              current_size = gs.boardsize
              if gs.topicsinplay.count == 0 {
                gs.topicsinplay = colorize(scheme:gs.currentscheme,  topics: getRandomTopics(GameState.preselectedTopicsForBoardSize(current_size),
                                                  from: chmgr.everyTopicName))
                gs.topicsinorder = gs.topicsinplay.keys.sorted()
              }
              gs.gimmees = 5 // give some to get started
             // gimmeeAlert = true
              //current_topics = gs.topicsinplay
              chmgr.checkAllTopicConsistency("ContentView onAppear2")
              TSLog("//ContentView first onAppear size:\(current_size) topics:\(gs.topicsinplay.count) restartcount \(restartCount)")
            } else {
              TSLog("//ContentView onAppear restart size:\(current_size) topics:\(gs.topicsinplay.count) restartcount \(restartCount)")
            }
            restartCount += 1
            gs.veryfirstgame = false
            gs.saveGameState()
          }
//          .alert(isPresented:$gimmeeAlert) {
//            Alert(title: Text("You got \(gs.gimmees) extra gimmees to get started!"), message: nil, dismissButton: .default(Text("OK")))
//          }
          .onDisappear {
            print("Yikes the ContentView is Disappearing!")
          }
        
      }
  }
  

#Preview ("light"){
  ContentView(gs: GameState.mock, chmgr: ChaMan.mock, lrdb:LeaderboardService())
}
#Preview ("dark"){
  ContentView(gs:GameState.mock, chmgr: ChaMan.mock, lrdb:LeaderboardService())
    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}



