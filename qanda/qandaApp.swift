//
//  mainapp.swift
//  basic
//
//  Created by bill donner on 7/8/24.
//

import SwiftUI
let gameTitle = "q a n d a"
let playDataURL  = Bundle.main.url(forResource: "playdata.json", withExtension: nil)
let starting_size = 3 // Example size, can be 3 to 8
let spareHeightFactor = isIpad ? 1.15:1.75// controls layout of grid if too small
let cornerradius = 0.0 // something like 8 makes nice rounded corners in main grid
var isDebugModeEnabled: Bool = false
var debugBorderColor: Color = .red
let shouldAssert = true //// External flag to control whether assertions should be enforced
let cloudKitBypass = true 




// Assuming a mock PlayData JSON file in the main bundle


// The app's main entry point
@main
struct QandaApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @AppStorage("OnboardingDone") private var onboardingdone = false
  @State var leaderboardService = LeaderboardService()
  @State var showOnboarding = false
  @State var chmgr = ChaMan(playData: PlayData.mock )
  @State var gs = GameState(size: starting_size,
                            topics:[],
                            challenges:Challenge.mockChallenges)
  
  var body: some Scene {
    WindowGroup {
      
      ContentView(gs: gs,chmgr: chmgr,lrdb:leaderboardService)
        .padding([.bottom])
       // .statusBar(hidden: true) // Hide the status bar
        .fullScreenCover(isPresented: $showOnboarding) {
          OnboardingScreen(isPresented: $showOnboarding)
        }
        .onAppear {
          TSLog("Assertions are \(shouldAssert ? "ON":"OFF")")
          conditionalAssert(gs.checkVsChaMan(chmgr: chmgr))
          AppDelegate.lockOrientation(.portrait)// ensure applied
          if (onboardingdone == false ) { // if not yet done then trigger it
            showOnboarding = true
            onboardingdone = true// flag it here while running straight swift
          }
        }
    }
  }
}

