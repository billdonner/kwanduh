//
//  DebugView.swift
//  qandao
//
//  Created by bill donner on 8/30/24.
//

import SwiftUI

struct DebugView: View {
  let gs:GameState
  let chmgr:ChaMan
  
    var body: some View {
      Text("\(gs.totaltime)")
      
      Text("\(chmgr.freeChallengesCount())")

    }
}

#Preview {
  DebugView(gs: GameState.mock, chmgr: ChaMan.mock)
}
