//
//  GameScreenExt.swift
//  basic
//
//  Created by bill donner on 8/4/24.
//

import SwiftUI

extension GameScreen /* actions */ { 
  func onAppearAction () {
    // on a completely cold start
    if gs.gamenumber == 0 {
      print("//GameScreen OnAppear Coldstart size:\(gs.boardsize) topics: \(topics)")
    } else {
      print("//GameScreen OnAppear Warmstart size:\(gs.boardsize) topics: \(topics)")
    }
    chmgr.checkAllTopicConsistency("gamescreen on appear")
  }
  func onCantStartNewGameAction() {
    print("//GameScreen onCantStartNewGameAction")
    showCantStartAlert = false
  }
  func onYouWin () {
    withAnimation{
      endGame(status: .justWon)
      //marqueeMessage = "Congratulations: Press Play to keep going."
    }
  }
  func onYouLose () {
    withAnimation {
      endGame(status: .justLost)
      //marqueeMessage = "Sorry about that. Press Play to keep going."
    }
  }
  func onEndGamePressed () {
   // print("//GameScreen EndGamePressed")
    endGame(status:.justAbandoned)
  }
  func onBoardSizeChange() {
    
  }

  func onDump() {
    chmgr.dumpTopics()
  }
  func onStartGame(boardsize:Int ) -> Bool {
   // print("//GameScreen onStartGame before  topics: \(gs.topicsinplay) size:\( boardsize)")
    // chmgr.dumpTopics()
    showOtherDiagAlert = false
    didshowOtherDiagAlert = false
    showWinAlert = false
    showLoseAlert = false
    showCantStartAlert = false
    showMustStartInCornerAlert = false
    showMustTapAdjacentCellAlert = false
    showSameSideAlert = false
    isTouching = false // turn off overlay
    let ok = gs.setupForNewGame(boardsize:boardsize,chmgr: chmgr )
   // print("//GameScreen onStartGame after")
    // chmgr.dumpTopics()
    if !ok {
      print("Failed to allocate \(gs.boardsize*gs.boardsize) challenges for topics \(gs.topicsinplay.keys.joined(separator: ","))")
      print("Consider changing the topics in setting and trying again ...")
    } else {
      firstMove = true
    }
    chmgr.checkAllTopicConsistency("on start game")
    print("--->NEW GAME STARTED")
    return ok
  }
  func endGame(status:StateOfPlay){
    isTouching = false // turn off overlay
    chmgr.checkAllTopicConsistency("end game")
    gs.teardownAfterGame(state: status, chmgr: chmgr)
  }
}
