import SwiftUI
func colorize(scheme:ColorSchemeName,topics:[String]) -> [String:FreeportColor] {
  let colors = availableColorsForScheme(  scheme)
  assert(topics.count <= colors.count,"Too many topics \(topics.count) for \(colors.count) colors")
  let colorMap: [String:FreeportColor] = zip(topics,colors).reduce(into: [:]) { result, pair in
    result[pair.0] = pair.1
  }
  return colorMap
}
struct ContentView: View {
  @State var restartCount = 0
  @Binding var gs: GameState
  @Bindable var chmgr: ChaMan
  @Bindable var lrdb: LeaderboardService
  @State var current_size: Int = starting_size
  @State var current_topics: [String:FreeportColor] = [:]

  
  var body: some View {
    // GeometryReader { geometry in
//    NavigationView {
//      VStack(spacing:isIpad ? 20: 0) {
    GameScreen(gs: $gs, chmgr: chmgr, lrdb:lrdb, topics: $current_topics, size: $current_size)
          .onAppear {
            if gs.veryfirstgame {
              chmgr.loadAllData(gs: gs)
              chmgr.checkAllTopicConsistency("ContentView onAppear0")
              current_size = gs.boardsize
              if gs.topicsinplay.count == 0 {
                gs.topicsinplay = colorize(scheme:gs.currentscheme,  topics: getRandomTopics(GameState.minTopicsForBoardSize(current_size),
                                                  from: chmgr.everyTopicName))
              }
              //current_topics = gs.topicsinplay
              chmgr.checkAllTopicConsistency("ContentView onAppear2")
              TSLog("//ContentView first onAppear size:\(current_size) topics:\(gs.topicsinplay.count) restartcount \(restartCount)")
            } else {
              TSLog("//ContentView onAppear restart size:\(current_size) topics:\(gs.topicsinplay.count) restartcount \(restartCount)")
            }
            restartCount += 1
            gs.veryfirstgame = false
          }
          .onDisappear {
            print("Yikes the ContentView is Disappearing!")
          }
        
      }
//     .navigationBarTitle("Actions Menu", displayMode: .inline)
//      .navigationBarItems(trailing: actionMenu)
 //   }
  }
  

#Preview ("light"){
  ContentView(gs:.constant( GameState.mock), chmgr: ChaMan.mock, lrdb:LeaderboardService())
}
#Preview ("dark"){
  ContentView(gs:.constant( GameState.mock), chmgr: ChaMan.mock, lrdb:LeaderboardService())
    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}



