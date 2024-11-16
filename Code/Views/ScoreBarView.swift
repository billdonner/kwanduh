//
//  ScoreBarView.swift
//  qdemo
//
//  Created by bill donner on 5/24/24.
//

import SwiftUI
func formattedElapsedTime(_ elapsedTime:TimeInterval)-> String {
  let minutes = Int(elapsedTime) / 60
  let seconds = Int(elapsedTime) % 60
  return String(format: "%02d:%02d", minutes, seconds)
}

private struct OutString:View {
  let showchars:String
  let gs: GameState
 
  var body: some View{
    let realScore :Double = gs.totaltime == 0.0 ? 0.0 : ( Double(gs.totalScore())   * 100.0 / gs.totaltime)
    HStack {
      VStack(alignment: .leading,spacing: 0){
        HStack {
          Text(formattedElapsedTime(gs.totaltime))
            .font(isIpad ? .title:.headline)
          Text("score:").font(isIpad ? .body:.footnote);
          Text(String(format: "%.2f", realScore))  
            .font(isIpad ? .title:.headline)
          HStack{ Text("gimmees:");Text("\(gs.gimmees)")}
            .font(isIpad ? .body:.footnote)
          Spacer()
        }
 
        HStack {
          Text("won:");Text("\(gs.woncount)")
          Text("lost:");Text("\(gs.lostcount)")
          Text("right:");Text("\(gs.rightcount)")
          Text("wrong:");Text("\(gs.wrongcount)")
          Spacer()
        }.opacity(0.8)
          .font(isIpad ? .title:.footnote)
      }
      HStack {
        if showchars.count > 1 {Text("last game: ").opacity(0.8) }
        Text(showchars).font(showchars.count<=1 ? .title:.footnote)
      }
    }.padding(4)
  }
  }
struct ScoreBarView: View {
  let gs: GameState
 
  var body:some View {
 
    HStack {
      let showchars = if isWinningPath(in:gs.cellstate ) {"😎"}
      else {
        if !isPossibleWinningPath(in:gs.cellstate) {   "❌"   }
        else {  "♺"   }
      }
      OutString(showchars: showchars,gs:gs).font(isIpad ?.title:.body)
        .padding(.horizontal).padding(.vertical,0)
    }
    
    .onChange(of:gs.cellstate) {
      
      if isWinningPath(in:gs.cellstate) {
        print("--->you have won this game as detected by ScoreBarView")
       
        gs.woncount += 1
        gs.saveGameState()
        
      } else {
        if !isPossibleWinningPath(in:gs.cellstate) {
          print("--->you cant possibly win this game s detected by ScoreBarView")
         
          gs.lostcount += 1
          gs.saveGameState()
        }
      }
    }    .debugBorder()
  }
}

#Preview {
  @Previewable
  @State var marqueeMessage = "blah blah"
  ScoreBarView(gs: GameState.mock)//, marqueeMessage: $marqueeMessage )
}
