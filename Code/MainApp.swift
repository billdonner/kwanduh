//
//  kwanduhApp.swift
//  kwanduh
//
//  Created by bill donner on 9/24/24.

//

import SwiftUI 


// Assuming a mock PlayData JSON file in the main bundle

let bonusPerWin = 10
let penaltyPerLoss = 0//2
let bonusPerRight = 3
let penaltyPerWrong = 0//1
let penaltyPerReplaced = 2

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
     let _ =  TSLog(">\(AppNameProvider.appName()) \(   AppVersionProvider.appVersion()) running; Assertions:\(shouldAssert ? "ON":"OFF") Debug:\(isDebugModeEnabled ? "ON":"OFF") Cloudkit:\(!cloudKitBypass ? "ON":"OFF")")
      if !onboardingdone {
        OuterOnboardingView(isOnboardingComplete: $onboardingdone)
      }
      else {
        ContentView(gs: gs,chmgr: chmgr,lrdb:leaderboardService)
          .debugBorder()
          .onAppear {
            ////conditionalAssert(gs.checkVsChaMan(chmgr: chmgr,message:"MainApp"))
            AppDelegate.lockOrientation(.portrait)// ensure applied
          }
      }
    }
  }
}
