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
    @State private var l_currentScheme: ColorSchemeName
    @State private var l_difficultyLevel: Int
  @State private var l_topicsinplay: [String:FreeportColor] // Updated to use TopicColor
    @State private var l_scheme: ColorSchemeName // hack //summer
    
    @State var firstOnAppear = true
    @State var showTopicSelector = false
    @State private var showFreeportSettings = false
    @State private var showCommentsMaker = false
    @State var cpv: [[Color]] = []
    
    @Environment(\.presentationMode) var presentationMode
    
  init(chmgr: ChaMan, gs: GameState, lrdb: LeaderboardService, showSettings: Binding<Bool>) {
    self.chmgr = chmgr
    self.gs = gs
    self.lrdb = lrdb
    self._showSettings = showSettings
    l_facedown = gs.facedown
    l_boardsize = gs.boardsize
    l_doubleDiag = gs.doublediag
    l_currentScheme = gs.currentscheme
    l_difficultyLevel = gs.difficultylevel
    l_startInCorners = gs.startincorners
    l_scheme = gs.currentscheme
    l_gimms = gs.gimmees
    l_topicsinplay = gs.topicsinplay
    
  }
//        // Initialize l_topicsinplay with TopicColor
//      l_topicsinplay = []
//      
//      print("settings gs =- Topics in play: \(gs.topicsinplay)")
//     
//      _l_topicsinplay = State(initialValue:gs.topicsinplay.map {
//          TopicColor(name: $0 ,
//                     colorSpec:convertColorTripleToColorSpec(colorTriple:
//                                                              gs.colorTripleForTopic($0) ))
//      ))})
//      print("settings =- Topics in play: \(l_topicsinplay)")
//    }
  let allSchemeNames: [String] = ["Bleak","Winter","Spring","Summer","Autumn"]

    var colorPicker: some View {
        Picker("Color Palette", selection: $l_scheme) {
            ForEach( allSchemeNames, id: \.self) { name in
              Text(name)
                    .tag(name)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .background(colorPaletteBackground(for: l_currentScheme).clipShape(RoundedRectangle(cornerRadius: 10)))
        .padding(.horizontal)
    }
    
    var body: some View {
        NavigationView {
            Form {
//                Section(header: Text("Topics")) {
//                    Text("You need gimmees to edit topics...").font(.footnote)
//                    Button(action: { showTopicSelector.toggle() }) {
//                        Text("Edit Topics")
//                    }
//                    .disabled(gs.gimmees <= 0)
//                    .fullScreenCover(isPresented: $showTopicSelector) {
//                      let _ = print("onwayoutofsettings topicsinplay:",$l_topicsinplay)
//                        TopicSelectorView(allTopics: chmgr.everyTopicName,
//                                          selectedTopics: $l_topicsinplay, // Pass the new array of TopicColor
//                                          selectedScheme: $l_currentScheme,
//                                          chmgr: chmgr,
//                                          gs: gs,
//                                          minTopics: GameState.minTopicsForBoardSize(l_boardsize),
//                                          maxTopics: GameState.maxTopicsForBoardSize(l_boardsize),
//                                          gimms: $l_gimms)
//                    }
//                }
                
              Section(header: Text("Board")) {
                VStack(alignment: .center) {
                  SizePickerView(chosenSize: $l_boardsize)
                    .onChange(of: l_boardsize) {
                      switch l_boardsize {
                      default: l_facedown = true; l_startInCorners = true
                      }
                    }
                  PreviewGridView(gs: gs, chmgr: chmgr, boardsize: $l_boardsize, scheme: $l_currentScheme)
                    .frame(width: 200, height: 200)
                }
              }
                  
                  Section(header: Text("Color Scheme")) {
                    
                    colorPicker
                      .onChange(of: l_scheme) {
                        withAnimation {
                          l_currentScheme = l_scheme
                        }
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
                        Button(action: { showFreeportSettings.toggle() }) {
                            Text("Freeport Settings")
                        }.sheet(isPresented: $showFreeportSettings) {
                            FreeportSettingsScreen(gs: gs, chmgr: chmgr, lrdb: lrdb, showSettings: $showSettings)
                        }
                    }
                }
            }
            .onAppear {
                if firstOnAppear {
                    firstOnAppear = false
                    chmgr.checkAllTopicConsistency("GameSettings onAppear")
                }
                cpv = gs.previewColorMatrix(size: l_boardsize, scheme: l_currentScheme)
                TSLog("SettingsScreen onAppear")
            }
            .navigationBarTitle("Game Settings", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Done") {
                    onDonePressed() // update global state
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }
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
        gs.currentscheme = l_currentScheme
        chmgr.checkAllTopicConsistency("GameSettingScreen onDonePressed")
        gs.saveGameState()
    }
}

#Preview {
    SettingsScreen(chmgr: ChaMan.mock, gs: GameState.mock, lrdb: LeaderboardService(), showSettings: (.constant(true)))
}
