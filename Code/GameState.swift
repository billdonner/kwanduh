//
//  GameState.swift
//  basic
//
//  Created by bill donner on 6/23/24.
//

import SwiftUI


struct GameMove : Codable,Hashable {
  let row:Int
  let col:Int
  let movenumber:Int 
}
//enum DifficultyLevel: Int,Codable {
//  case easy,normal,hard
//}
@Observable
class GameState : Codable {
  var board: [[Int]]  // Array of arrays to represent the game board with challenges
  var cellstate: [[GameCellState]]  // Array of arrays to represent the state of each cell 
  var moveindex: [[Int]] // -1 is unplayed
  var replaced:[[[Int]]] // list of replacements in this cell
  var boardsize: Int  // Size of the game board

  var gamestate: StateOfPlay = .initializingApp
  var totaltime: TimeInterval // aka Double
  
  var veryfirstgame:Bool
  var currentscheme: ColorSchemeName
  // in chaman we can fetch counts to make % from Tinfo
  //chmgr.tinfo[topic]
 // var tinfo: [String: TopicInfo]  // Dictionary indexed by topic
  //all topics is in chmgr.everyTopicName
 // @ObservationIgnored
  var topicsinplay: [String:FreeportColor] // a subset of allTopics (which is constant and maintained in ChaMan)
  var topicsinorder: [String]
 // @ObservationIgnored
  var onwinpath: [[Bool]] // only set after win detected
 // @ObservationIgnored
  var gimmees: Int  // Number of "gimmee" actions available

 // @ObservationIgnored
  var facedown:Bool
 // @ObservationIgnored
  var startincorners:Bool
 // @ObservationIgnored
  var doublediag:Bool
//  @ObservationIgnored
  var difficultylevel:Int
 // @ObservationIgnored
  var lastmove: GameMove?
 // @ObservationIgnored
  var gamestart:Date // when game started
//  @ObservationIgnored
  var swversion:String // if this changes we must delete all state
//  @ObservationIgnored
  var woncount:  Int
//  @ObservationIgnored
  var lostcount:  Int
 // @ObservationIgnored
  var rightcount: Int
 // @ObservationIgnored
  var wrongcount: Int
 // @ObservationIgnored
  var replacedcount: Int
 // @ObservationIgnored
  var gamenumber:  Int
//  @ObservationIgnored
  var movenumber:  Int
  
  
  
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
    case facedown
    case startincorners
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
  


  
  
  init(size: Int, topics: [String:FreeportColor], challenges: [Challenge]) {
    self.topicsinplay = topics //*****4
    self.topicsinorder = topics.keys.sorted()
    self.boardsize = size
    self.board = Array(repeating: Array(repeating: -1, count: size), count: size)
    self.cellstate = Array(repeating: Array(repeating: .unplayed, count: size), count: size)
    self.moveindex = Array(repeating: Array(repeating: -1, count: size), count: size) 
    self.onwinpath = Array(repeating: Array(repeating: false, count: size), count: size)
    self.replaced = Array(repeating: Array(repeating: [], count: size), count: size)
    self.gimmees = 0
    self.gamenumber = 0
    self.movenumber = 0
    self.woncount = 0
    self.lostcount = 0
    self.rightcount = 0
    self.wrongcount = 0
    self.replacedcount = 0
    self.totaltime = 0.0
    self.facedown = true
    self.currentscheme = 2//.summer
    self.veryfirstgame = true
    self.doublediag = false
    self.difficultylevel = 0//.easy
    self.startincorners = true
    self.gamestart = Date()
    self.swversion = AppVersionProvider.appVersion()
  }
  
  // Codable conformance: decode the properties
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.topicsinplay = try container.decode([String:FreeportColor].self,forKey:.topicsinplay)
    self.topicsinorder = try container.decode([String].self,forKey:.topicsinorder)
    self.boardsize = try container.decode(Int.self,forKey:.boardsize)
    self.board = try container.decode([[Int]].self,forKey:.board)
    self.cellstate = try container.decode([[GameCellState]].self,forKey:.cellstate)
    self.moveindex = try container.decode([[Int]].self,forKey:.moveindex)
    self.onwinpath = try container.decode([[Bool]].self,forKey:.onwinpath)
    self.replaced = try container.decode([[[Int]]].self,forKey:.replaced)
    self.gimmees = try container.decode(Int.self,forKey:.gimmees)
    self.gamenumber = try container.decode(Int.self,forKey:.gamenumber)
    self.movenumber = try container.decode(Int.self,forKey:.movenumber)
    self.woncount = try container.decode(Int.self,forKey:.woncount)
    self.lostcount = try container.decode(Int.self,forKey:.lostcount)
    self.rightcount = try container.decode(Int.self,forKey:.rightcount)
    self.wrongcount = try container.decode(Int.self,forKey:.wrongcount)
    self.replacedcount = try container.decode(Int.self,forKey:.replacedcount)
    self.totaltime = try container.decode(TimeInterval.self,forKey:.totaltime)
    self.facedown = try container.decode(Bool.self,forKey:.facedown)
    self.currentscheme = try container.decode(ColorSchemeName.self,forKey:.currentscheme)
    self.veryfirstgame = try container.decode(Bool.self,forKey:.veryfirstgame)
    self.doublediag = try container.decode(Bool.self,forKey:.doublediag)
    self.difficultylevel = try container.decode(Int.self,forKey:.difficultylevel) //0//.easy
    self.startincorners = try container.decode(Bool.self,forKey:.startincorners)
    self.gamestart = try container.decode(Date.self,forKey:.gamestart)
    self.swversion = try container.decode(String.self,forKey:.swversion)
    
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
    try container.encode(gamestate, forKey: .gamestate)
    try container.encode(totaltime, forKey: .totaltime)
    try container.encode(veryfirstgame, forKey: .veryfirstgame)
      // `nonObservedProperties`
    try container.encode(gimmees, forKey: .gimmees)
    try container.encode(currentscheme, forKey: .currentscheme)
    try container.encode(facedown, forKey: .facedown)
    try container.encode(startincorners, forKey: .startincorners)
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
  func setupForNewGame (boardsize:Int, chmgr:ChaMan) -> Bool {
    // assume all cleaned up, using size
    var allocatedChallengeIndices:[Int] = []
    self.gamenumber += 1
    self.gamestart = Date()
    self.movenumber = 0
    self.lastmove = nil
    self.boardsize = boardsize ///////////////
    self.board = Array(repeating: Array(repeating: -1, count:  boardsize), count:   boardsize)
    self.moveindex = Array(repeating: Array(repeating: -1, count:  boardsize), count:   boardsize) 
    self.onwinpath = Array(repeating: Array(repeating:false, count:  boardsize), count:   boardsize)
    self.cellstate = Array(repeating: Array(repeating:.unplayed, count: boardsize), count:  boardsize) 
    self.replaced  = Array(repeating: Array(repeating:[], count: boardsize), count:  boardsize)
    // give player a few gimmees depending on boardsize
    self.gimmees += boardsize - 1
    // use topicsinplay and allocated fresh challenges
    let result:AllocationResult = chmgr.allocateChallenges(forTopics: Array(topicsinplay.keys), count: boardsize * boardsize)
    switch result {
    case .success(let x):
      conditionalAssert(x.count == boardsize*boardsize)
     // print("Success:\(x.count)")
      allocatedChallengeIndices = x.shuffled()
      //continue after the error path
      
    case .error(let err):
      print("Allocation failed for topics \(topicsinplay),count :\(boardsize*boardsize)")
      print ("Error: \(err)")
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
    // set cellstate to unplayed
    //    allocatedChallengeIndices = x.shuffled()
    for row in 0..<boardsize {
      for col in 0..<boardsize {
        let idxs = allocatedChallengeIndices[row * boardsize + col]
       // let ch = chmgr.everyChallenge[idxs]
        //let topic = ch.topic
        // change this code so that if the topic at this row,col is the same as an adjacent cell , we pick a different one by altering the idxs
        board[row][col] = idxs
        cellstate[row][col] = .unplayed
      }
    }
    
 /** TODO: this ensures no adjacent cells are the same color
    // put these challenges into the board
    // set cellstate to unplayed
    // allocatedChallengeIndices = x.shuffled()
    var deallocatedIndices: [Int] = []

    for row in 0..<boardsize {
        for col in 0..<boardsize {
            var idxs = allocatedChallengeIndices[row * boardsize + col]
            var ch = chmgr.everyChallenge[idxs]
            var topic = ch.topic

            // Check adjacent cells and ensure no duplicate topics
            var adjacentTopics = Set<String>()
            
            if row > 0 { // Check cell above
                let aboveIdxs = board[row - 1][col]
                adjacentTopics.insert(chmgr.everyChallenge[aboveIdxs].topic)
            }
            
            if col > 0 { // Check cell to the left
                let leftIdxs = board[row][col - 1]
                adjacentTopics.insert(chmgr.everyChallenge[leftIdxs].topic)
            }
            
            // Ensure the topic is not the same as an adjacent cell
            var foundValid = false
            while adjacentTopics.contains(topic) {
                // Pick another index if the topic matches adjacent ones
                if let newIdx = allocatedChallengeIndices.shuffled().first(where: { !adjacentTopics.contains(chmgr.everyChallenge[$0].topic) }) {
                    deallocatedIndices.append(idxs)  // Add the old index to deallocation list
                    idxs = newIdx
                    ch = chmgr.everyChallenge[idxs]
                    topic = ch.topic
                    foundValid = true
                } else {
                    // If no valid index can be found, break the loop
                    foundValid = false
                    break
                }
            }
            
            // If we found a valid challenge, assign it to the board
            if foundValid || !adjacentTopics.contains(topic) {
                board[row][col] = idxs
                cellstate[row][col] = .unplayed
            } else {
                // If no valid challenge can be found, deallocate the challenge index
                deallocatedIndices.append(idxs)
            }
        }
    }

    // Call deallocateChallengeIndices with the array of deallocated items
    if !deallocatedIndices.isEmpty {
     let _ =  chmgr.deallocAt(deallocatedIndices)
    }
    */
    
    gamestate = .playingNow
    saveGameState() 
    return true
  }
  
  
  func teardownAfterGame (state:StateOfPlay,chmgr:ChaMan) {
    var challenge_indexes:[Int] = []
    gamestate = state
    // examine each board cell and recycle everything thats unplayed
    for row in 0..<boardsize {
      for col in 0..<boardsize {
        if cellstate[row][col] == .unplayed {
          let idx = board[row][col]
          if idx != -1 { // hack or not?
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
    // clear out last move
    lastmove = nil
    saveGameState()
  }
  
  
  func totalScore() -> Int {
    
    if gamenumber == 0 { return 0 }
    
    let part1 =   woncount * 10
    - lostcount * 2
     + rightcount * 3
    - wrongcount * 1
    
    let part2 = replacedcount * -2
    + (startincorners ? 10 : 0)
    + (facedown ? 5 : 0)
    
    let part3 = switch difficultylevel {
    case 0://.easy:
     0
    case 1://.normal:
      5
    case 2://.hard:
      10
    default: 0 
    }
    
    let total = part1 + part2 + part3
    
    if total < 0 { return 0}
    
    
    return total
      
  
  }
  
  func moveHistory() -> [GameMove] {
    var moves:[GameMove]=[]
    for row in 0 ..< boardsize{
      for col in 0 ..< boardsize{
        if  cellstate[row][col] != .unplayed {
          moves.append(GameMove(row:row,col:col,movenumber: moveindex[row][col]))
        }
      }
    }
   return moves.sorted(by: { $0.movenumber < $1.movenumber })
  }
  func looker(row:Int,col:Int,path:[(Int,Int)]) -> Int? {
    for (idx,p) in path.enumerated() {
      if p.0==row && p.1==col { return idx }
    }
    return nil
  }
  func winningPathOfGameMoves() -> [GameMove] { 
    
    let (path,found) =  winningPath(in:cellstate)
    if !found { return [] }
    
    var z:[GameMove]=[]
    for row in 0 ..< boardsize{
      for col in 0 ..< boardsize{
        if let x = looker(row:row,col:col,path:path) {
          z.append(GameMove(row:row,col:col,movenumber:x))
        }
      }
    }
    return z.sorted(by: { $0.movenumber < $1.movenumber })
  }
  func prettyPathOfGameMoves( ) -> String {
    let moves = winningPathOfGameMoves()
    var out = ""
    for move in moves {
      out.append("(\(move.row),\(move.col))")
    }
    return out
  }
  
  func isCornerCell(row:Int,col:Int ) -> Bool {
    return row==0&&col==0  ||
    row==0 && col == self.boardsize-1 ||
    row==self.boardsize-1 && col==0 ||
    row==self.boardsize-1 && col == self.boardsize - 1
  }
  
  func isAlreadyPlayed(row:Int,col:Int ) -> (Bool) {
    return ( self.cellstate[row][col] == .playedCorrectly ||
             self.cellstate[row][col] == .playedIncorrectly)
  }
  
  func cellBorderSize() -> CGFloat {
    return CGFloat(14-self.boardsize)*(isIpad ? 2.0:1.0) // sensitive
  }
  
  func checkVsChaMan(chmgr:ChaMan) -> Bool {
    let a=chmgr.correctChallengesCount()
    if a != rightcount {
      print("*** correct challenges count \(a) is wrong \(rightcount)")
      return false
    }
    let b = chmgr.incorrectChallengesCount()
    if b != wrongcount {
      print("*** incorrect challenges count \(b) is wrong \(wrongcount)")
      
      return false
    }
    if gamestate != .initializingApp {
      // check everything on the board is consistent
      
      for row in  0 ..< boardsize  {
        for col in 0 ..< boardsize  {
          
          let j = board[row][col]
          if j != -1 {
            let x:ChaMan.ChallengeStatus = chmgr.stati[j]
            switch cellstate[row][col] {
            case .playedCorrectly:
              if x  != ChaMan.ChallengeStatus.playedCorrectly {
                print("*** cellstate is wrong for \(row), \(col) playedCorrectly says \(x)")
                return false
              }
            case .playedIncorrectly:
              if x  != ChaMan.ChallengeStatus.playedIncorrectly{
                print("*** cellstate is wrong for \(row), \(col) playedIncorrectly says \(x)")
                return false
              }
            case .unplayed:
              if x != ChaMan.ChallengeStatus.allocated {
                print("*** cellstate is wrong for \(row), \(col) unplayed says \(x)")
                return false
              }
            }// switch
            if x == ChaMan.ChallengeStatus.abandoned {
              print("*** cellstate is wrong for \(row), \(col) abandoned says \(x)")
              return false
            }
            if x == ChaMan.ChallengeStatus.inReserve {
              print("*** cellstate is wrong for \(row), \(col) reserved says \(x)")
              return false
            }
          }
        }
      }
    }
    return true
  }
  
  func basicTopics()->[BasicTopic] {
    return topicsinplay.keys.map {BasicTopic(name: $0)}
  }

  private static func indexOfTopic(_ topic: String,within:[String]) -> Int? {
      return  within.firstIndex(where: { $0 == topic })
  }
  private func indexOfTopic(_ topic: String) -> Int? {
    Self.indexOfTopic(topic,within: Array(self.topicsinplay.keys))
  }

  
  func previewColorMatrix(size:Int,scheme:ColorSchemeName) -> [[Color]] {
    var cm     = Array(repeating: Array(repeating:Color.black, count: size), count: size)
    for row in 0..<size {
      for col in 0..<size {
        cm[row][col] = colorForSchemeAndTopic(scheme: scheme, index: (row*size+col) % 10).toColor()
      }
    }
    return cm
  }
  
  static  func minTopicsForBoardSize(_ size:Int) -> Int {
    switch size  {
    case 3: return 1
    case 4: return 1
    case 5: return 1
    case 6: return 1
    case 7: return 1
    case 8: return 1
    default: return 1 }
  }
  
  static  func maxTopicsForBoardSize(_ size:Int) -> Int {
    switch size  {
    case 3: return 10
    case 4: return 10
    case 5: return 10
    case 6: return 10
    case 7: return 10
    case 8: return 10
    default: return 10
    }
  }
  
  static  func preselectedTopicsForBoardSize(_ size:Int) -> Int {
 
    switch size  {
    case 3: return 3
    case 4: return 3
    case 5: return 3
    case 6: return 4
    case 7: return 5
    case 8: return 6
    default: return 7
    }
  }
  // this returns unplayed challenges and their indices in the challengestatus array
  func resetBoardReturningUnplayed() ->   [Int] {
    var unplayedInts: [Int] = []
    for row in 0..<boardsize {
      for col in 0..<boardsize {
        if cellstate[row][col]  == .unplayed {
          unplayedInts.append( (row * boardsize + col))
        }
      }
    }
    return unplayedInts
  }
  // Get the file path for storing challenge statuses
  static func getGameStateFilePath() -> URL {
    let fileManager = FileManager.default
    let urls = fileManager.urls(for:.documentDirectory, in: .userDomainMask)
    return urls[0].appendingPathComponent("gameBoard.json")
  }
  
  func saveGameState( ) {
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
      switch compareVersionStrings(gb.swversion, AppVersionProvider.appVersion()) {
        
      case .orderedAscending:
        TSLog("sw version changed from \(gb.swversion) to \(AppVersionProvider.appVersion())")
      case .orderedSame:
        TSLog("sw version is the same")
      case .orderedDescending:
        TSLog("yikes! sw version went backwards")
      }
      // Let's check right now to make sure the software version has not changed
      if haveMajorComponentsChanged(gb.swversion, AppVersionProvider.appVersion()) {
        print ("***major sw version change ")
        deleteAllState()
        return nil // version change
      }
      return gb
    } catch {
      print("Failed to load gs: \(error)")
      deleteAllState()
      return nil
    }
  }

}

