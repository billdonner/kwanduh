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


let spareHeightFactor = isIpad ? 1.15:1.75// controls layout of grid if too small


let bonusPerWin = 10
let penaltyPerLoss = 2
let bonusPerRight = 3
let penaltyPerWrong = 1
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
////ZStack {
//        GeometryReader { geometry in
//            Color.green
//                .edgesIgnoringSafeArea(.all)
//                .overlay(Text("Width: \(geometry.size.width)\nHeight: \(geometry.size.height)")
//                            .foregroundColor(.white)
//                            .font(.largeTitle))
//        } 
        
  
      ContentView(gs: gs,chmgr: chmgr,lrdb:leaderboardService)
        //.padding([.bottom])
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



