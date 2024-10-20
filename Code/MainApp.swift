//
//  kwanduhApp.swift
//  kwanduh
//
//  Created by bill donner on 9/24/24.
//
//
//  kwanduhApp.swift
//  kwanduh
//
//  Created by bill donner on 9/16/24.
//

import SwiftUI 


// Assuming a mock PlayData JSON file in the main bundle


@main
struct mainApp : App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @AppStorage("OnboardingDone") private var onboardingdone = false
  @State var leaderboardService = LeaderboardService()
  @State var showOnboarding = false
  @State var chmgr = ChaMan(playData: PlayData.mock )
  @State var gs = GameState(size: starting_size,
                            topics:[:],
                            challenges:Challenge.mockChallenges)
  
  var body: some Scene {
    WindowGroup {
      ContentView(gs: $gs,chmgr: chmgr,lrdb:leaderboardService)
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



