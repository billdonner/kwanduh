import SwiftUI

struct BoardSizeScreen: View {
  @Bindable var chmgr: ChaMan
  @Bindable var gs: GameState
 // let lrdb: LeaderboardService
  @Binding var showSettings: Bool
  
  @State private var l_boardsize: Int
  
  
  @State var firstOnAppear = true
  @State private var showSizeChangeAlert = false
  @State var cpv: [[Color]] = []
  
  @Environment(\.dismiss) var dismiss
  
  init(chmgr: ChaMan, gs: GameState, //lrdb: LeaderboardService,
       showSettings: Binding<Bool>) {
    self.chmgr = chmgr
    self.gs = gs
   // self.lrdb = lrdb
    self._showSettings = showSettings
    l_boardsize = gs.boardsize
  }
  
  
  var body: some View {
    NavigationView {
      Form {
        
        Section(header: Text("Board")) {
          VStack(alignment: .center) {
            SizePickerView(chosenSize: $l_boardsize)
            
            
            PreviewGridView(gs: gs, chmgr: chmgr, boardsize: $l_boardsize, scheme: $gs.currentscheme)
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
          chmgr.checkAllTopicConsistency("BoardSizeScreen onAppear")
        }
        cpv = gs.previewColorMatrix(size: l_boardsize, scheme: gs.currentscheme)
        TSLog("SettingsScreen onAppear")
      }
      .navigationBarTitle("Board Size", displayMode: .inline)
      .navigationBarItems(
        leading: Button("Cancel") {
          dismiss()
        },
        trailing: Button("Done") {
     onDonePressed()
          /* adjust */
          dismiss()
        })
    }
  }
  private func onDonePressed() {
      // Copy every change into GameState
    gs.boardsize = l_boardsize
      gs.board = Array(repeating: Array(repeating: -1, count: l_boardsize), count: l_boardsize)
      gs.cellstate = Array(repeating: Array(repeating: .unplayed, count: l_boardsize), count: l_boardsize)
      gs.moveindex = Array(repeating: Array(repeating: -1, count: l_boardsize), count: l_boardsize)
      gs.onwinpath = Array(repeating: Array(repeating: false, count: l_boardsize), count: l_boardsize)
      gs.replaced = Array(repeating: Array(repeating: [], count: l_boardsize), count: l_boardsize)

      chmgr.checkAllTopicConsistency("GameSettingScreen onDonePressed")
      gs.saveGameState()
  }
}


#Preview {
    BoardSizeScreen(chmgr: ChaMan.mock, gs: GameState.mock, showSettings: (.constant(true)))
}
