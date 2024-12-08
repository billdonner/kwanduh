import SwiftUI
//https://useyourloaf.com/blog/iphone-16-screen-sizes/
// Function to calculate VStack spacing based on screen width
func spacing(for width: CGFloat) -> CGFloat {
    let spacingTable: [(width: CGFloat, spacing: CGFloat)] = [
        (320, 5),   // iPhone SE (1st generation), iPhone 5, 5S, 5C
        (375, 5),  // iPhone 6, iPhone 6S, iPhone 7, iPhone 8, iPhone SE (2nd & 3rd generation)
        (390, 15),  // iPhone 11 Pro, iPhone 12, iPhone 13, iPhone 14, iPhone 15
        (393, 27),  // iPhone 15 Pro, iphone 16
        (402,30),// iphone 16 pro
        (414, 20),  // iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus, iPhone 8 Plus, iPhone 11, iPhone 14 Plus
        (428, 35),  // iPhone 14 Pro Max, iPhone 15 Plus
        (430, 37),  // iPhone 15 Pro Max, iphone 16 Plus
        (440, 40)   //  iPhone 16 Pro Max
    ]

    // Find the closest match from the table
    let closestMatch = spacingTable.min { abs($0.width - width) < abs($1.width - width) }
    return closestMatch?.spacing ?? 10 // Default spacing
}


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
    .alert("We are giving you 5 gimmees.\nHit the Play button to get started!",isPresented:$gimmeeAlert) {
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
