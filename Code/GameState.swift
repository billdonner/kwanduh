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
@Observable
class GameState: Codable {
  var board: [[Int]]  // Array of arrays to represent the game board with challenges
  var cellstate: [[GameCellState]]  // Array of arrays to represent the state of each cell
  var moveindex: [[Int]]  // -1 is unplayed
  var savedGamePaths: [String]
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
  @ObservationIgnored
  var chmgr: ChaMan? = nil
  var difficultylevel: Int
  var lastmove: GameMove?
  var gamestart: Date  // when game started
  var swversion: String  // if this changes we must delete all state
  var woncount: Int
  var lostcount: Int
  var rightcount: Int
  var wrongcount: Int
  var replacedcount: Int
  var gamenumber: Int
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
    case savedgamepaths
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
    self.savedGamePaths = try container.decode([String].self, forKey: .savedgamepaths)
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

  init(chmgr:ChaMan, size: Int, topics: [String: FreeportColor], challenges: [Challenge]) {
    self.topicsinplay = topics  //*****4
    self.topicsinorder = topics.keys.sorted()
    self.boardsize = size
    self.chmgr = chmgr 
    self.board = Array(
      repeating: Array(repeating: -1, count: size), count: size)
    self.cellstate = Array(
      repeating: Array(repeating: .unplayed, count: size), count: size)
    self.moveindex = Array(
      repeating: Array(repeating: -1, count: size), count: size)
    self.savedGamePaths = []
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
    try container.encode(savedGamePaths, forKey: .savedgamepaths)
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

