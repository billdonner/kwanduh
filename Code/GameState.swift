//
//  GameState.swift
//  basic
//
//  Created by bill donner on 6/23/24.
//

import SwiftUI
struct GameMove: Codable, Hashable {
  let row: Int
  let col: Int
  let movenumber: Int
}
//enum DifficultyLevel: Int,Codable {
//  case easy,normal,hard
//}
@Observable
class GameState: Codable {
  var board: [[Int]]  // Array of arrays to represent the game board with challenges
  var cellstate: [[GameCellState]]  // Array of arrays to represent the state of each cell
  var moveindex: [[Int]]  // -1 is unplayed
  var replaced: [[[Int]]]  // list of replacements in this cell
  var boardsize: Int  // Size of the game board
  var playstate: StateOfPlay
  var totaltime: TimeInterval  // aka Double
  var veryfirstgame: Bool
  var currentscheme: ColorSchemeName
  var topicsinplay: [String: FreeportColor]  // a subset of allTopics (which is constant and maintained in ChaMan)
  var topicsinorder: [String]
  var onwinpath: [[Bool]]  // only set after win detected
  var gimmees: Int  // Number of "gimmee" actions available
  var doublediag: Bool
  //  @ObservationIgnored
  var difficultylevel: Int
  // @ObservationIgnored
  var lastmove: GameMove?
  // @ObservationIgnored
  var gamestart: Date  // when game started
  //  @ObservationIgnored
  var swversion: String  // if this changes we must delete all state
  //  @ObservationIgnored
  var woncount: Int
  //  @ObservationIgnored
  var lostcount: Int
  // @ObservationIgnored
  var rightcount: Int
  // @ObservationIgnored
  var wrongcount: Int
  // @ObservationIgnored
  var replacedcount: Int
  // @ObservationIgnored
  var gamenumber: Int
  //  @ObservationIgnored
  var movenumber: Int
  
  
  // in chaman we can fetch counts to make % from Tinfo
  //chmgr.tinfo[topic]
  // var tinfo: [String: TopicInfo]  // Dictionary indexed by topic
  //all topics is in chmgr.everyTopicName

  //
  enum CodingKeys: String, CodingKey {
    case board
    case cellstate
    case moveindex
    case onwinpath
    case replaced
    case boardsize
    case topicsinplay
    case topicsinorder
    case gamestate
    case totaltime
    case veryfirstgame

    case gimmees
    case currentscheme
    case doublediag
    case difficultylevel
    case lastmove
    case gamestart
    case swversion
    case woncount
    case lostcount
    case rightcount
    case wrongcount
    case replacedcount
    case gamenumber
    case movenumber
  }

  func totalScore() -> Int {

    if gamenumber == 0 { return 0 }

    let baseScore =
      switch difficultylevel {
      case 0:  //.easy:
        0
      case 1:  //.normal:
        5
      case 2:  //.hard:
        10
      default: 0
      }

    let incremental =
      woncount * bonusPerWin
      - lostcount * penaltyPerLoss
      + rightcount * bonusPerRight
      - wrongcount * penaltyPerLoss
      - replacedcount * penaltyPerReplaced

    let total = baseScore + incremental
    if total < 0 { return 0 }
    return total

  }


  func cellsToBlock() -> Set<Coordinate> {
      let totalCells = boardsize * boardsize
      let blockedCellsCount = Int(Double(totalCells) * 0.25)
      var blockedCells: Set<Coordinate> = []
      
      while blockedCells.count < blockedCellsCount {
          let row = Int.random(in: 0..<boardsize)
          let col = Int.random(in: 0..<boardsize)
          let coordinate = Coordinate(row: row, col: col)

          // Skip if it's a corner cell or already blocked
          if isCornerCell(row: row, col: col) || blockedCells.contains(coordinate) {
              continue
          }

          // Temporarily add the cell to the blocked list
          blockedCells.insert(coordinate)
          
          // Create a temporary cell state with the blocked cells
          var tempCellState = cellstate
          for blockedCell in blockedCells {
              tempCellState[blockedCell.row][blockedCell.col] = .blocked
          }
          
          // Check if a winning path is still possible
        if !isPossibleWinningPath(in: tempCellState) {
              // If not, revert the block
              blockedCells.remove(coordinate)
              TSLog("cellstoBlock did not find a winning path, retrying!")
          }
      }

      return blockedCells
  }
  func setupForNewGame(boardsize: Int, chmgr: ChaMan) -> Bool {
    // assume all cleaned up, using size
    var allocatedChallengeIndices: [Int] = []

    self.gamestart = Date()
    self.movenumber = 0
    self.lastmove = nil
    self.boardsize = boardsize
    ///////////////
    self.board = Array(
      repeating: Array(repeating: -1, count: boardsize), count: boardsize)
    self.moveindex = Array(
      repeating: Array(repeating: -1, count: boardsize), count: boardsize)
    self.onwinpath = Array(
      repeating: Array(repeating: false, count: boardsize), count: boardsize)
    self.cellstate = Array(
      repeating: Array(repeating: .unplayed, count: boardsize), count: boardsize
    )
    self.replaced = Array(
      repeating: Array(repeating: [], count: boardsize), count: boardsize)
    // give player a few gimmees depending on boardsize - moved until after
    if self.veryfirstgame { self.gimmees += boardsize - 1 }
    // new **** - figure how many to blank out
    // put these challenges into the board
    // set cellstate to unplayed or blocked

    let blockedCells = cellsToBlock()

    let blankout = blockedCells.count

    // use topicsinplay and allocated fresh challenges
    let result: AllocationResult = chmgr.allocateChallenges(
      forTopics: Array(topicsinplay.keys),
      count: boardsize * boardsize - blankout)
    switch result {
    case .success(let x):
      conditionalAssert(x.count == boardsize * boardsize - blankout)
      // print("Success:\(x.count)")
      allocatedChallengeIndices = x.shuffled()
    //continue after the error path

    case .error(let err):
      print(
        "Allocation failed for topics \(topicsinplay),count :\(boardsize*boardsize-blankout)"
      )
      print("Error: \(err)")
      switch err {
      case .emptyTopics:
        print("EmptyTopics")
      case .invalidTopics(let names):
        print("Invalid Topics \(names)")
      case .insufficientChallenges(let avail):
        print("Insufficient Challenges - only have \(avail) available")
      case .invalidDeallocIndices(let indices):
        print("Indices cant be deallocated \(indices)")
      }
      return false
    }
    // put these challenges into the board
    // set cellstate to unplayed or blocked
    //    allocatedChallengeIndices = x.shuffled()

    var allocIdx = 0
    //deliberately in transposed order
    for col in 0..<boardsize {
      for row in 0..<boardsize {
        let coordinate = Coordinate(row: row, col: col)
        if blockedCells.contains(coordinate) {
          // Mark as blocked cell
          board[row][col] = -1
          cellstate[row][col] = .blocked
        } else {
          // Assign a challenge from allocatedChallengeIndices
          board[row][col] = allocatedChallengeIndices[allocIdx]
          cellstate[row][col] = .unplayed
          allocIdx += 1
        }
      }
    }

    playstate = .playingNow
    saveGameState()
    return true
  }

  func teardownAfterGame(state: StateOfPlay, chmgr: ChaMan) {
    var challenge_indexes: [Int] = []
    playstate = state
    // examine each board cell and recycle everything thats unplayed
    for row in 0..<boardsize {
      for col in 0..<boardsize {
        if cellstate[row][col] == .unplayed {
          let idx = board[row][col]
          if idx != -1 {  // hack or not?
            challenge_indexes.append(idx)
          }
        }
      }
    }
    // dealloc at indices first before resetting
    let allocationResult = chmgr.deallocAt(challenge_indexes)
    switch allocationResult {
    case .success(_): break
    // print("dealloc succeeded")
    case .error(let err):
      print("dealloc failed \(err)")
    }
    chmgr.resetChallengeStatuses(at: challenge_indexes)

    // if we actually did anything then bump the game number
    if challenge_indexes.count != boardsize * boardsize {
      self.gamenumber += 1
    }

    // clear out last move
    lastmove = nil
    saveGameState()
  }

  func checkVsChaMan(chmgr: ChaMan, message: String) -> Bool {
    let a = chmgr.correctChallengesCount()
    if a != rightcount {
      print(
        "*** \(message) -  correct challenges count \(a) is wrong \(rightcount)"
      )
      return false
    }
    let b = chmgr.incorrectChallengesCount()
    if b != wrongcount {
      print(
        "*** \(message) - incorrect challenges count \(b) is wrong \(wrongcount)"
      )
      return false
    }
    if playstate != .initializingApp {
      // check everything on the board is consistent
      for row in 0..<boardsize {
        for col in 0..<boardsize {
          let j = board[row][col]
          if j != -1 {
            let x: ChallengeStatus = chmgr.stati[j]
            switch cellstate[row][col] {
            case .playedCorrectly:
              if x != ChallengeStatus.playedCorrectly {
                print(
                  "*** \(message) - cellstate is wrong for \(row), \(col) playedCorrectly says \(x)"
                )
                return false
              }
            case .playedIncorrectly:
              if x != ChallengeStatus.playedIncorrectly {
                print(
                  "*** \(message) - cellstate is wrong for \(row), \(col) playedIncorrectly says \(x)"
                )
                return false
              }
            case .unplayed:
              if x != ChallengeStatus.allocated {
                print(
                  "*** \(message) -cellstate is wrong for \(row), \(col) unplayed says \(x)"
                )
                return false
              }
            case .blocked:
              return true  // for now there's nothing there to check
            }  // switch
            if x == ChallengeStatus.abandoned {
              print(
                "*** \(message) -cellstate is wrong for \(row), \(col) abandoned says \(x)"
              )
              return false
            }
            if x == ChallengeStatus.inReserve {
              print(
                "*** \(message) -cellstate is wrong for \(row), \(col) reserved says \(x)"
              )
              return false
            }
          }
        }
      }
    }
    return true
  }

  func previewColorMatrix(size: Int, scheme: ColorSchemeName) -> [[Color]] {
    var cm = Array(
      repeating: Array(repeating: Color.black, count: size), count: size)
    for row in 0..<size {
      for col in 0..<size {
        cm[row][col] = colorForSchemeAndTopic(
          scheme: scheme, index: (row * size + col) % 10
        ).toColor()
      }
    }
    return cm
  }
  // this returns unplayed challenges and their indices in the challengestatus array
  func resetBoardReturningUnplayed() -> [Int] {
    var unplayedInts: [Int] = []
    for row in 0..<boardsize {
      for col in 0..<boardsize {
        if cellstate[row][col] == .unplayed {
          unplayedInts.append((row * boardsize + col))
        }
      }
    }
    return unplayedInts
  }


  /*******/

  // Codable conformance: decode the properties
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.topicsinplay = try container.decode(
      [String: FreeportColor].self, forKey: .topicsinplay)
    self.topicsinorder = try container.decode(
      [String].self, forKey: .topicsinorder)
    self.boardsize = try container.decode(Int.self, forKey: .boardsize)
    self.board = try container.decode([[Int]].self, forKey: .board)
    self.cellstate = try container.decode(
      [[GameCellState]].self, forKey: .cellstate)
    self.moveindex = try container.decode([[Int]].self, forKey: .moveindex)
    self.onwinpath = try container.decode([[Bool]].self, forKey: .onwinpath)
    self.replaced = try container.decode([[[Int]]].self, forKey: .replaced)
    self.gimmees = try container.decode(Int.self, forKey: .gimmees)
    self.gamenumber = try container.decode(Int.self, forKey: .gamenumber)
    self.movenumber = try container.decode(Int.self, forKey: .movenumber)
    self.woncount = try container.decode(Int.self, forKey: .woncount)
    self.lostcount = try container.decode(Int.self, forKey: .lostcount)
    self.rightcount = try container.decode(Int.self, forKey: .rightcount)
    self.wrongcount = try container.decode(Int.self, forKey: .wrongcount)
    self.replacedcount = try container.decode(Int.self, forKey: .replacedcount)
    self.totaltime = try container.decode(TimeInterval.self, forKey: .totaltime)
    self.currentscheme = try container.decode(
      ColorSchemeName.self, forKey: .currentscheme)
    self.veryfirstgame = try container.decode(Bool.self, forKey: .veryfirstgame)
    self.doublediag = try container.decode(Bool.self, forKey: .doublediag)
    self.difficultylevel = try container.decode(
      Int.self, forKey: .difficultylevel)  //0//.easy
    self.gamestart = try container.decode(Date.self, forKey: .gamestart)
    self.swversion = try container.decode(String.self, forKey: .swversion)
    self.playstate = try container.decode(StateOfPlay.self, forKey: .gamestate)

  }

  init(size: Int, topics: [String: FreeportColor], challenges: [Challenge]) {
    self.topicsinplay = topics  //*****4
    self.topicsinorder = topics.keys.sorted()
    self.boardsize = size
    self.board = Array(
      repeating: Array(repeating: -1, count: size), count: size)
    self.cellstate = Array(
      repeating: Array(repeating: .unplayed, count: size), count: size)
    self.moveindex = Array(
      repeating: Array(repeating: -1, count: size), count: size)
    self.onwinpath = Array(
      repeating: Array(repeating: false, count: size), count: size)
    self.replaced = Array(
      repeating: Array(repeating: [], count: size), count: size)
    self.gimmees = 0
    self.gamenumber = 0
    self.movenumber = 0
    self.woncount = 0
    self.lostcount = 0
    self.rightcount = 0
    self.wrongcount = 0
    self.replacedcount = 0
    self.totaltime = 0.0
    // self.facedown = true
    self.currentscheme = 2  //.summer
    self.veryfirstgame = true
    self.doublediag = false
    self.difficultylevel = 0  //.easy
    //  self.startincorners = true
    self.gamestart = Date()
    self.swversion = AppVersionProvider.appVersion()
    self.playstate = .initializingApp
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(board, forKey: .board)
    try container.encode(cellstate, forKey: .cellstate)
    try container.encode(moveindex, forKey: .moveindex)
    try container.encode(onwinpath, forKey: .onwinpath)
    try container.encode(replaced, forKey: .replaced)
    try container.encode(boardsize, forKey: .boardsize)
    try container.encode(topicsinplay, forKey: .topicsinplay)
    try container.encode(topicsinorder, forKey: .topicsinorder)
    try container.encode(playstate, forKey: .gamestate)
    try container.encode(totaltime, forKey: .totaltime)
    try container.encode(veryfirstgame, forKey: .veryfirstgame)
    // `nonObservedProperties`
    try container.encode(gimmees, forKey: .gimmees)
    try container.encode(currentscheme, forKey: .currentscheme)
    try container.encode(doublediag, forKey: .doublediag)
    try container.encode(difficultylevel, forKey: .difficultylevel)
    try container.encode(lastmove, forKey: .lastmove)
    try container.encode(gamestart, forKey: .gamestart)
    try container.encode(swversion, forKey: .swversion)
    try container.encode(woncount, forKey: .woncount)
    try container.encode(lostcount, forKey: .lostcount)
    try container.encode(rightcount, forKey: .rightcount)
    try container.encode(wrongcount, forKey: .wrongcount)
    try container.encode(replacedcount, forKey: .replacedcount)
    try container.encode(gamenumber, forKey: .gamenumber)
    try container.encode(movenumber, forKey: .movenumber)

  }

}
