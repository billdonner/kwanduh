import SwiftUI

struct ContentView: View {
  @State var restartCount = 0
  @Bindable var gs: GameState
  @Bindable var chmgr: ChaMan
  @Bindable var lrdb: LeaderboardService
  @State var current_size: Int = starting_size
  @State var current_topics: [String] = []

  
  var body: some View {
    // GeometryReader { geometry in
       VStack(spacing:isIpad ? 20: 0) {
         GameScreen(gs: gs, chmgr: chmgr, lrdb:lrdb, topics: $current_topics, size: $current_size) 
          .onAppear {
            if gs.veryfirstgame {
              chmgr.loadAllData(gs: gs)
              chmgr.checkAllTopicConsistency("ContentView onAppear0")
              current_size = gs.boardsize
              if gs.topicsinplay.count == 0 {
                gs.topicsinplay = getRandomTopics(GameState.minTopicsForBoardSize(current_size),
                                                  from: chmgr.everyTopicName)
              }
              current_topics = gs.topicsinplay
              chmgr.checkAllTopicConsistency("ContentView onAppear2")
       TSLog("//ContentView first onAppear size:\(current_size) topics:\(current_topics) restartcount \(restartCount)")
            } else {
              TSLog("//ContentView onAppear restart size:\(current_size) topics:\(current_topics) restartcount \(restartCount)")
            }
            restartCount += 1
            gs.veryfirstgame = false
          }
          .onDisappear {
            print("Yikes the ContentView is Disappearing!")
          }

         
          
        }
      }
 // }
}

#Preview ("light"){
  ContentView(gs: GameState.mock, chmgr: ChaMan.mock, lrdb:LeaderboardService())
}
#Preview ("dark"){
  ContentView(gs: GameState.mock, chmgr: ChaMan.mock, lrdb:LeaderboardService())
    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}



