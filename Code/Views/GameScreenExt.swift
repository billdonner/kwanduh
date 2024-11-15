//
//  GameScreenExt.swift
//  basic
//
//  Created by bill donner on 8/4/24.
//

import SwiftUI

extension GameScreen /* actions */ {
  
  // process single tap
  func  onSingleTap (_ row:Int, _ col:Int ) {
    var validTap = false
    
    // if this cell is already played then trigger a full screen cover to present it
    if gs.isAlreadyPlayed(row: row, col: col) {
      alreadyPlayed = Xdi(row: row, col: col,challenge: chmgr.everyChallenge[     gs.board[row][col]])
      return
    }
    // otherwise its not played yet
    //When a player tries to start the game in a box other than a corner, post the message "Start out in a corner . . ."
    if gs.gamestate == .playingNow && firstMove && !gs.isCornerCell(row:row,col:col) {
      showMustStartInCornerAlert = true
      return
    }
    //If a player tries to play a box that is not adjacent to a played box, post the message "Touch a box next to one you've already played . . ."
    
    if gs.gamestate == .playingNow && !firstMove && !gs.isCornerCell(row:row,col:col) && !hasAdjacentNeighbor(withStates: [.playedCorrectly, .playedIncorrectly], in: gs.cellstate, for: (row, col)) {
      showMustTapAdjacentCellAlert = true
      return
    }
    

    // if not playing ignore all other taps
    if gs.gamestate == .playingNow,
       gs.cellstate[row][col] == .unplayed {
      // consider valid tap if first move corner cell
      // or not first and either a corner or with an adjacent neighbor thats been played
      validTap = firstMove ? gs.isCornerCell(row: row, col: col) : (gs.isCornerCell(row: row, col: col) || hasAdjacentNeighbor(withStates: [.playedCorrectly, .playedIncorrectly], in: gs.cellstate, for: (row, col)))
    }

    if validTap {
      gs.lastmove = GameMove(row: row, col: col, movenumber: gs.movenumber)
      firstMove = false
      // this kicks off  the fullscreencover of the QandAScreen
      chal = IdentifiablePoint(row: row, col: col, status: chmgr.stati[row * gs.boardsize + col])
    }
  }
  
  
  // evaluate winners and losers
  func onChangeOfCellState() {
    //TSLog("**************onChangeOfCellState****************")
    let (path,iswinner) = winningPath(in:gs.cellstate)
    if iswinner {
      TSLog("--->YOU WIN path is \(path)")
      for p in path {
        gs.onwinpath[p.0][p.1] = true
      }
      showWinAlert = true
      return
    }
    if !isPossibleWinningPath(in:gs.cellstate) {
     TSLog("--->YOU LOSE")
      showLoseAlert = true
      return
    }
    // Check if any corner is marked as played incorrectly
    let incorrectInACorner = gs.cellstate[0][0] == .playedIncorrectly ||
                             gs.cellstate[gs.boardsize - 1][gs.boardsize - 1] == .playedIncorrectly ||
                             gs.cellstate[0][gs.boardsize - 1] == .playedIncorrectly ||
                             gs.cellstate[gs.boardsize - 1][0] == .playedIncorrectly


    
    // Check if two corners on the same side are marked as played correctly
    let twoCorrectInCornersOnSameSide = (
        // Top-left and top-right corners
        (gs.cellstate[0][0] == .playedCorrectly && gs.cellstate[0][gs.boardsize - 1] == .playedCorrectly) ||
        // Bottom-left and bottom-right corners
        (gs.cellstate[gs.boardsize - 1][0] == .playedCorrectly && gs.cellstate[gs.boardsize - 1][gs.boardsize - 1] == .playedCorrectly) ||
        // Top-left and bottom-left corners
        (gs.cellstate[0][0] == .playedCorrectly && gs.cellstate[gs.boardsize - 1][0] == .playedCorrectly) ||
        // Top-right and bottom-right corners
        (gs.cellstate[0][gs.boardsize - 1] == .playedCorrectly && gs.cellstate[gs.boardsize - 1][gs.boardsize - 1] == .playedCorrectly)
    )
    //If you lose in both corners post a message to try the other diagonal Message should say "Go for the other diagonal!" showOtherDiagAlert
    if gs.gamestate == .playingNow {
      if incorrectInACorner {
        if !didshowOtherDiagAlert {
          showOtherDiagAlert = true
          didshowOtherDiagAlert = true
        }
      } else
  
    //When a player connects two corners that are on the same side the game board, post the message "Winning path connects corners on opposite sides of a diagonal!" with option to turn off this message.

      if twoCorrectInCornersOnSameSide {
        if !didshowSameSideAlert {
          showSameSideAlert = true
          didshowSameSideAlert = true
        }
      }
    }
  }
  
  
  
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
    showSameSideAlert = false
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
    TSLog("--->NEW GAME STARTED")
    return ok
  }
  func endGame(status:StateOfPlay){
    isTouching = false // turn off overlay
    chmgr.checkAllTopicConsistency("end game")
    gs.teardownAfterGame(state: status, chmgr: chmgr)
  }
}
