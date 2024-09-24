//
//  TopicDetailsView.swift
//  basic
//
//  Created by bill donner on 7/30/24.
//

import SwiftUI
func isUsedup(_ status:ChaMan.ChallengeStatus) -> Bool {
  switch status {
  case .abandoned:
    return true
  case .playedCorrectly:
    return true
  case .playedIncorrectly:
    return true
  default:
    return false
  }
}
struct TopicDetailsView: View {
  let topic:String
  let gs:GameState
  let chmgr:ChaMan
  let colortrip: ColorTriple
  
  @State private var showApview:Challenge?  = nil
  @State var  showGamesLog =  false
  var body: some View {
    // let colors = gs.colorForTopic(topic)
    let tinfo = chmgr.tinfo[topic]
    
    if let tinfo = tinfo {
      let (chas, stas) = tinfo.getChallengesAndStatuses(chmgr: chmgr)

      VStack {
        ZStack {
          colortrip.0
            .ignoresSafeArea(edges: .top)
          
          VStack {
            Text(topic)
              .font(.largeTitle)
              .fontWeight(.bold)
            // .shadow(color: .black, radius: 1, x: 0, y: 1)
              .padding(.top, 50)
            Text("\(chas.count) challenges in this topic")
              .font(.footnote)
            //  .shadow(color: .black, radius: 1, x: 0, y: 1)
          }
          .foregroundColor(colortrip.1)
          .padding()
        }
        List {
          ForEach(0..<chas.count, id: \.self) { idx in
            if isUsedup(stas[idx]) {
              HStack {
                let ansinfo = chmgr.ansinfo[chas[idx].id]
                if let ansinfo = ansinfo
                {
                  let s = "\(ansinfo.movenumber).circle"
                  Image(systemName: s) .font(.headline)
                  //  .foregroundColor(colorScheme == .light ? .black : .white )
                }
                VStack(alignment: .leading) {
                  Text(truncatedText(chas[idx].question, count: 200))
                  let tt =  switch stas[idx] {
                  case .playedCorrectly: "✅"
                  case .playedIncorrectly:"❌"
                  case .abandoned:"💤"
                  default:"⁉️"
                  }
                  Text(tt).font(.headline)
                }
                Spacer()
                Image(systemName: "chevron.right")
                  .foregroundColor(.gray)
              }
              .contentShape(Rectangle()) // Make the entire HStack tappable
              .onTapGesture {
                showApview = chas[idx]
              }
            }
          }
        }
        Button(action:{showGamesLog = true})
        {
          Text("Games")
        }
        .fullScreenCover(item: $showApview) { challenge in
          if let ansinfo = chmgr.ansinfo [challenge.id] {
          AlreadyPlayedView(ch: challenge,ansinfo: ansinfo,  gs:gs)
          }
        }
      }
      .dismissButton(backgroundColor: gs.colorForTopic(topic).0) // put a dismiss button up there
      
      .fullScreenCover(isPresented: $showGamesLog) {
        GameLogScreen(gs:gs, chmgr: chmgr)
      }
    } else {
      Color.red.dismissButton(backgroundColor: .white) // put a dismiss button up there
    }
  }
  
}

#Preview {
  TopicDetailsView(topic:"Fun",gs:GameState.mock,
                   chmgr: ChaMan.mock, colortrip: GameState.mock.colorForTopic("Fun"))
}
