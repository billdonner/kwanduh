//
//  GameStateExt.swift
//  kwanduh
//
//  Created by bill donner on 10/27/24.
//

import Foundation
extension GameState {
  
  
  func moveHistory() -> [GameMove] {
    var moves: [GameMove] = []
    for row in 0..<boardsize {
      for col in 0..<boardsize {
        //yikes
        if cellstate[row][col] != .unplayed && cellstate[row][col] != .blocked {
          moves.append(
            GameMove(row: row, col: col, movenumber: moveindex[row][col]))
        }
      }
    }
    return moves.sorted(by: { $0.movenumber < $1.movenumber })
  }
  func indexInPath(row: Int, col: Int, path: [Coordinate]) -> Int? {
    for (idx, p) in path.enumerated() {
      if p.row == row && p.col == col { return idx }
    }
    return nil
  }
  func winningPathOfGameMoves() -> [GameMove] {
    
    let (path, found) = winningPath(in: cellstate)
    if !found { return [] }
    
    var z: [GameMove] = []
    for row in 0..<boardsize {
      for col in 0..<boardsize {
        if let x = indexInPath(row: row, col: col, path: path) {
          z.append(GameMove(row: row, col: col, movenumber: x))
        }
      }
    }
    return z.sorted(by: { $0.movenumber < $1.movenumber })
  }
  func prettyPathOfGameMoves() -> String {
    let moves = winningPathOfGameMoves()
    var out = ""
    for move in moves {
      out.append("(\(move.row),\(move.col))")
    }
    return out
  }
  
  func isCornerCell(row: Int, col: Int) -> Bool {
    return (row == 0 && col == 0) || (row == 0 && col == boardsize - 1)
    || (row == boardsize - 1 && col == 0)
    || (row == boardsize - 1 && col == boardsize - 1)
  }
  func isAdjacentToCornerCell(row: Int, col: Int) -> Bool {
    // Define the coordinates of the four corners
    let corners = [
      (0, 0),
      (0, boardsize - 1),
      (boardsize - 1, 0),
      (boardsize - 1, boardsize - 1),
    ]
    
    // Define directions for all 8 possible adjacent cells
    let directions = [
      (-1, -1), (-1, 0), (-1, 1),
      (0, -1), (0, 1),
      (1, -1), (1, 0), (1, 1),
    ]
    
    // Check if the cell is adjacent to any of the corners
    for corner in corners {
      for direction in directions {
        let adjacentRow = corner.0 + direction.0
        let adjacentCol = corner.1 + direction.1
        if adjacentRow == row && adjacentCol == col {
          return true
        }
      }
    }
    
    return false
  }
  func oppositeCornerCell(row: Int, col: Int) -> (Int, Int)? {
    switch (row, col) {
      
    case (0, 0): return (self.boardsize - 1, self.boardsize - 1)
    case (self.boardsize - 1, self.boardsize - 1): return (0, 0)
    case (0, self.boardsize - 1): return (self.boardsize - 1, 0)
    case (self.boardsize - 1, 0): return (0, self.boardsize - 1)
    default: return nil
    }
  }
  func rhCornerCell(row: Int, col: Int) -> (Int, Int)? {
    switch (row, col) {
      
    case (0, 0): return (0, self.boardsize - 1)
    case (self.boardsize - 1, self.boardsize - 1):
      return (self.boardsize - 1, 0)
    case (0, self.boardsize - 1):
      return (self.boardsize - 1, self.boardsize - 1)
    case (self.boardsize - 1, 0): return (0, 0)
    default: return nil
    }
  }
  func lhCornerCell(row: Int, col: Int) -> (Int, Int)? {
    switch (row, col) {
    case (0, 0): return (self.boardsize - 1, 0)
    case (self.boardsize - 1, self.boardsize - 1):
      return (0, self.boardsize - 1)
    case (0, self.boardsize - 1): return (0, 0)
    case (self.boardsize - 1, 0):
      return (self.boardsize - 1, self.boardsize - 1)
    default: return nil
    }
  }
  func isAlreadyPlayed(row: Int, col: Int) -> (Bool) {
 (self.cellstate[row][col] == .playedCorrectly
              || self.cellstate[row][col] == .playedIncorrectly) 
   
  }
  func hasAtLeastTwoNonBlockedNeighbors(_ row: Int, _ col: Int) -> Bool {
    var nonBlockedNeighborCount = 0
    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    for direction in directions {
      let newRow = row + direction.0
      let newCol = col + direction.1
      if newRow >= 0, newRow < boardsize, newCol >= 0, newCol < boardsize {
        if cellstate[newRow][newCol] != .blocked {
          nonBlockedNeighborCount += 1
        }
      }
    }
    return nonBlockedNeighborCount >= 2
  }
  func hasAtLeastOneNonBlockedNeighbors(_ row: Int, _ col: Int) -> Bool {
    var nonBlockedNeighborCount = 0
    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    for direction in directions {
      let newRow = row + direction.0
      let newCol = col + direction.1
      if newRow >= 0, newRow < boardsize, newCol >= 0, newCol < boardsize {
        if cellstate[newRow][newCol] != .blocked {
          nonBlockedNeighborCount += 1
        }
      }
    }
    return nonBlockedNeighborCount >= 1
  }
  
}
extension GameState {
  func basicTopics() -> [BasicTopic] {
    return topicsinplay.keys.map { BasicTopic(name: $0) }
  }

  private static func indexOfTopic(_ topic: String, within: [String]) -> Int? {
    return within.firstIndex(where: { $0 == topic })
  }
  private func indexOfTopic(_ topic: String) -> Int? {
    Self.indexOfTopic(topic, within: Array(self.topicsinplay.keys))
  }



  static func minTopicsForBoardSize(_ size: Int) -> Int {
    switch size {
    case 3: return 1
    case 4: return 1
    case 5: return 1
    case 6: return 1
    case 7: return 1
    case 8: return 1
    default: return 1
    }
  }

  static func maxTopicsForBoardSize(_ size: Int) -> Int {
    switch size {
    case 3: return 6
    case 4: return 6
    case 5: return 6
    case 6: return 6
    case 7: return 6
    case 8: return 6
    default: return 6
    }
  }

  static func preselectedTopicsForBoardSize(_ size: Int) -> Int {

    switch size {
    case 3: return 3
    case 4: return 3
    case 5: return 3
    case 6: return 4
    case 7: return 5
    case 8: return 6
    default: return 3
    }
  }
  
  // Get the file path for storing challenge statuses
  static func getGameStateFilePath() -> URL {
    let fileManager = FileManager.default
    let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[0].appendingPathComponent("gameBoard.json")
  }

  func saveGameState() {
    //TSLog("SAVE GAMESTATE")
    let filePath = Self.getGameStateFilePath()
    do {
      let data = try JSONEncoder().encode(self)
      try data.write(to: filePath)
    } catch {
      print("Failed to save gs: \(error)")
    }
  }
  // Load the GameBoard
  static func loadGameState() -> GameState? {
    let filePath = getGameStateFilePath()
    do {
      let data = try Data(contentsOf: filePath)
      let gb = try JSONDecoder().decode(GameState.self, from: data)
      switch compareVersionStrings(
        gb.swversion, AppVersionProvider.appVersion())
      {

      case .orderedAscending:
        TSLog(
          "sw version changed from \(gb.swversion) to \(AppVersionProvider.appVersion())"
        )
      case .orderedSame:
        break  //TSLog("sw version is the same")
      case .orderedDescending:
        TSLog("yikes! sw version went backwards")
      }
      // Let's check right now to make sure the software version has not changed
      if haveMajorComponentsChanged(
        gb.swversion, AppVersionProvider.appVersion())
      {
        print("***major sw version change ")
        deleteAllState()
        return nil  // version change
      }
      return gb
    } catch {
      print("Failed to load gs: \(error)")
      deleteAllState()
      return nil
    }
  }
  
}
