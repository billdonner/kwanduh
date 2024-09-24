//
//  GameLogScreen.swift
//  basic
//
//  Created by bill donner on 8/13/24.
//

import SwiftUI

struct GameLogScreen: View {
  internal init( gs: GameState,chmgr:ChaMan) {
    self.movehistory = gs.moveHistory()
    self.gs = gs
    self.chmgr = chmgr
  }
  @State var showDetails :Challenge? = nil
  @State var movehistory: [GameMove] = []
  let gs:GameState
  let chmgr:ChaMan
  var body: some View {
    VStack{
      VStack {
        Text("Game #\(gs.gamenumber)").font(.title)
        Text("\(gs.gamestart)").font(.footnote)
        Text("\(Int(gs.totaltime)) secs").font(.footnote)
        Text("\(joinWithCommasAnd(gs.topicsinplay))").font(.footnote)
        /** List {
         ForEach(movehistory, id:\.self ) { move in
         let row = move.row
         let col = move.col
         let reps = gs.replaced[row][col] // a vector of challenge indices
         let ch = chmgr.everyChallenge[gs.board[row][col]]
         let ansinfo = chmgr.ansinfo[ch.id]
         let sym = switch gs.cellstate[row][col] {
         case .playedCorrectly:
         "✅"
         case .playedIncorrectly:
         "❌"
         case .unplayed:
         ""
         }
         Text("\(move.movenumber) : @(\(row),\(col))\(ch.topic)")
         
         HStack {
         Text("\(ch.question)")
         Spacer()
         Image(systemName: "chevron.right")
         .foregroundColor(.gray)
         }.onTapGesture {
         showDetails = ch
         }
         .fullScreenCover(item: $showDetails)
         { challenge in
         AlreadyPlayedView(ch: challenge, gs: gs, chmgr: chmgr)
         }
         Text("correct answer: \(ch.correct)")
         HStack {
         Text("your answer: \(ansinfo?.answer ?? "none" )")
         Spacer()
         Text("\(sym)").font(.caption)
         }
         if reps.count > 0 {
         // Text("Question: \(ch.question)")
         ForEach(reps,id:\.self) { rep in
         let cha = chmgr.everyChallenge[rep]
         Text(">>>Replaced: \(cha.question)")
         }
         }
         }
         }// list
         
         */
        switch gs.gamestate {
        case .initializingApp:
          Text("You are not currently playing")
        case .playingNow:
          Text("Currently playing")
        case .justLost:
          Text("You lost 😞")
        case .justWon:
          Text("You won 😎")
          Text("winning path is \(gs.prettyPathOfGameMoves())")
        case .justAbandoned:
          Text("You abandonded this game")
        }//switch
        
      }
      
    }.dismissButton(backgroundColor:.blue)
  }
}

#Preview {
  GameLogScreen(gs:GameState.mock, chmgr:ChaMan.mock)
}
