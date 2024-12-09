//
//  SettingsFormScreen.swift
//  qdemo
//
//  Created by bill donner on 4/23/24.
//

import SwiftUI
struct DismissButtonView: View {
  @Environment(\.dismiss) var dismiss
  var body: some View {
    VStack {
      // add a dismissal button
      HStack {
        Spacer()
        Button {
          dismiss()
        } label: {
          Image(systemName: "x.circle").padding(EdgeInsets(top:10, leading: 0, bottom: 40, trailing: 20))
        }
      }
      Spacer()
    }
  }
}

struct AddScoreView: View {
    let leaderboardService: LeaderboardService
    @State private var playerName = ""
    @State private var score = ""

    var body: some View {
     NavigationStack {
            TextField("Player Name", text: $playerName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Score", text: $score)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()

            Button("Add Score") {
                if let scoreInt = Int(score) {
                    leaderboardService.addScore(playerName: playerName, score: scoreInt)
                }
                playerName = ""
                score = ""
            }
            .padding()
        }
        .navigationBarTitle("Add New Score", displayMode: .inline)
    }
}
struct FreeportSettingsScreen: View {
  let gs: GameState
  let chmgr: ChaMan
  let lrdb: LeaderboardService
  @Binding var showSettings:Bool
  @AppStorage("OnboardingDone") private var onboardingdone = false
  @AppStorage("elementWidth") var elementWidth = 100.0
  @AppStorage("shuffleUp") private var shuffleUp = true
  @AppStorage("fontsize") private var fontsize = 24.0
  @AppStorage("padding") private var padding = 2.0
  @AppStorage("border") private var border = 3.0
  
  @State var selectedLevel:Int = 1
  @State var showOnBoarding = false
  @State var clearLeaderboard = false
  @State var addToLeaderboard = false
  @State var showReset = false
  @State var showDebug = false
  @State var showEnvDump = false
  @State var showSentimentsLog = false
  @State var showGameLog = false
  
  var body: some View {
    ZStack {
      DismissButtonView()
      VStack {
        Text("Freeport Controls")
        Form {
          Section(header: Text("App Information")) {
            Text("App Name: \(Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Unknown")")
            Text("Version: \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown")")
            Text("Build: \(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown")")
            Text("Bundle Identifier: \(Bundle.main.bundleIdentifier ?? "Unknown")")
          }
          Section(header: Text("CloudKit Configuration")) {
            Text("cloudKitLeaderBoardContainerID: \(cloudKitLeaderBoardContainerID)")
            Text("cloudKitSentimentsContainerID: \(cloudKitSentimentsContainerID)")
          }
          Section(header: Text("Not For Civilians")) {
//            Button(action:{ onboardingdone = false }) {
//              Text("Replay OnBoarding")
//            }
            Button(action: {
              showGameLog.toggle()
            }) {
              Text("Game History")
            }
            Button(action:{ clearLeaderboard.toggle() }) {
              Text("Clear Leaderboard")
            }
            Button(action:{ addToLeaderboard.toggle() }) {
              Text("Add To Leaderboard")
            }
            Button(action:{ showSentimentsLog.toggle() }) {
              Text("Show Sentiments Log")
            }
            Button(action:{ showEnvDump.toggle() }) {
              Text("Show Environment Dump")
            }
            Button(action:{ gs.gimmees += 10 }) {
              Text("Gimmee 10 Gimmees")
            }
            Button(action:{ showDebug.toggle() }) {
              Text("Show Debug")
            }
            Button(action:{
              let _ = gs.resetBoardReturningUnplayed()
              chmgr.totalresetofAllChallengeStatuses(gs: gs)
              //showSettings = false //should blow us back to top
              
            }) {
              Text("Factory Reset")
            }.padding(.vertical)
            
          }
        }
        .sheet(isPresented: $addToLeaderboard) {
          AddScoreView(leaderboardService: lrdb)
            .preferredColorScheme(.light)
        } 
        .sheet(isPresented: $showSentimentsLog) {
          FetcherView( )
        }
        .sheet(isPresented: $showGameLog) {
          GameLogScreen(gameState: gs, challengeManager: chmgr )
        }
        .sheet(isPresented: $showEnvDump) {
          EnvironmentDumpView()
        }
        .fullScreenCover(isPresented: $showDebug) {
          AllocatorView(chmgr:chmgr,gs:gs)
        }
        
        Spacer()
        // Text("It is sometimes helpful to rotate your device!!").font(.footnote).padding()
      }
      
    }
  }
}


#Preview ("Settings"){
  FreeportSettingsScreen(gs: 
                          GameState.mock,
                         chmgr: ChaMan.mock,
                         lrdb:LeaderboardService(),
                         showSettings:.constant(true))
}


