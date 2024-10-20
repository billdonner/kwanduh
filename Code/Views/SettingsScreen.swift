import SwiftUI

struct SettingsScreen: View {
    @Bindable var chmgr: ChaMan
    @Bindable var gs: GameState
    let lrdb: LeaderboardService
    @Binding var showSettings: Bool
    
    @State private var l_gimms: Int
    @State private var l_boardsize: Int
    @State private var l_startInCorners: Bool
    @State private var l_facedown: Bool
    @State private var l_doubleDiag: Bool
    @State private var l_difficultyLevel: Int
    @State private var l_topicsinplay: [String:FreeportColor] // Updated to use TopicColor
    @State private var l_scheme: ColorSchemeName
    
    @State var firstOnAppear = true
  @State private var showSizeChangeAlert = false
    @State var cpv: [[Color]] = []
    
  @Environment(\.dismiss) var dismiss
    
  init(chmgr: ChaMan, gs: GameState, lrdb: LeaderboardService, showSettings: Binding<Bool>) {
    self.chmgr = chmgr
    self.gs = gs
    self.lrdb = lrdb
    self._showSettings = showSettings
    l_facedown = gs.facedown
    l_boardsize = gs.boardsize
    l_doubleDiag = gs.doublediag
    l_difficultyLevel = gs.difficultylevel
    l_startInCorners = gs.startincorners
    l_scheme = gs.currentscheme
    l_gimms = gs.gimmees
    l_topicsinplay = gs.topicsinplay
    
  }


    var colorPicker: some View {
        Picker("Color Palette", selection: $l_scheme) {
          ForEach(Array(allSchemeNames.enumerated()), id: \.element) { index, name in
              Text(name)
                  .tag(index) // Use the index as the tag
          }
        }
        .pickerStyle(SegmentedPickerStyle())
        .background(colorPaletteBackground(for: l_scheme).clipShape(RoundedRectangle(cornerRadius: 10)))
        .padding(.horizontal)
    }
    
    var body: some View {
        NavigationView {
            Form {
                
              Section(header: Text("Board")) {
                VStack(alignment: .center) {
                  SizePickerView(chosenSize: $l_boardsize)
                    .onChange(of: l_boardsize) {
                      switch l_boardsize {
                      default: l_facedown = true; l_startInCorners = true
                      }
                    }
                  PreviewGridView(gs: gs, chmgr: chmgr, boardsize: $l_boardsize, scheme: $l_scheme)
                    .frame(width: 200, height: 200)
                }
              }
                  
                Section(header: Text("About QANDA")) {
                    VStack {
                        HStack { Spacer()
                            AppVersionInformationView(
                                name: AppNameProvider.appName(),
                                versionString: AppVersionProvider.appVersion(),
                                appIcon: AppIconProvider.appIcon()
                            )
                            Spacer()
                        }
                     
                    }
                }
            }
            .onAppear {
                if firstOnAppear {
                    firstOnAppear = false
                    chmgr.checkAllTopicConsistency("GameSettings onAppear")
                }
                cpv = gs.previewColorMatrix(size: l_boardsize, scheme: l_scheme)
                TSLog("SettingsScreen onAppear")
            }
            .alert("You will end your game",isPresented: $showSizeChangeAlert) {
              Button("OK"   ) {
                finally()
              }
              Button("Cancel", role: .cancel) {
                dismiss()
              }
            }
            .navigationBarTitle("Game Settings", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Done") {
                  if l_boardsize != gs.boardsize {
                    showSizeChangeAlert = true
                  } else {
              finally()
                  }
                }
            )
        }
    }
    private func finally () {
      onDonePressed() // update global state
     dismiss()
  }
    private func onDonePressed() {
        // Copy every change into GameState
        gs.gimmees = l_gimms // copy in adjustment from topic selector
        gs.doublediag = l_doubleDiag
        gs.difficultylevel = l_difficultyLevel
        gs.startincorners = l_startInCorners
        gs.facedown = l_facedown
        gs.boardsize = l_boardsize
        gs.board = Array(repeating: Array(repeating: -1, count: l_boardsize), count: l_boardsize)
        gs.cellstate = Array(repeating: Array(repeating: .unplayed, count: l_boardsize), count: l_boardsize)
        gs.moveindex = Array(repeating: Array(repeating: -1, count: l_boardsize), count: l_boardsize)
        gs.onwinpath = Array(repeating: Array(repeating: false, count: l_boardsize), count: l_boardsize)
        gs.replaced = Array(repeating: Array(repeating: [], count: l_boardsize), count: l_boardsize)
        gs.topicsinplay = l_topicsinplay//.map { $0.name } // Convert back to [String] for GameState
        gs.currentscheme = l_scheme
      print("GameSettingScreen onDonePressed scheme is  \(l_scheme)" )
        chmgr.checkAllTopicConsistency("GameSettingScreen onDonePressed scheme is  \(l_scheme)")
        gs.saveGameState()
    }
}

#Preview {
    SettingsScreen(chmgr: ChaMan.mock, gs: GameState.mock, lrdb: LeaderboardService(), showSettings: (.constant(true)))
}
