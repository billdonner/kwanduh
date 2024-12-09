//
//  ChaManExt.swift
//  basic
//
//  Created by bill donner on 8/1/24.
//

import Foundation
extension ChaMan {
  func loadPlayData( ) throws {
    let starttime = Date.now
    guard let url = playDataURL  else {
      throw URLError(.fileDoesNotExist)
    }
    let data = try Data(contentsOf: url)
    let pd = try JSONDecoder().decode(PlayData.self, from: data)
    self.playData = pd
    if let loadedStatuses = loadChallengeStatuses() {
      self.stati = loadedStatuses
    } else {
      let challenges = pd.gameDatum.flatMap { $0.challenges}
      var cs:[ChallengeStatus] = []
      for _ in 0..<challenges.count {
        cs.append(.inReserve)
      }
      self.stati = cs
    }
    
    if let loadedTinfo = TopicInfo.loadTopicInfo() {
      self.tinfo = loadedTinfo
    } else {
      setupTopicInfo() // build from scratch
    }
    
    if let loadedAnswers = AnsweredInfo.loadAnsweredInfo() {
      self.ansinfo = loadedAnswers
    } else {
      setupAnsweredInfo()
    }
    TSLog("Loaded \(self.stati.count) challenges from mainBundle PlayData in \(formatTimeInterval(Date.now.timeIntervalSince(starttime))) secs")
    saveChallengeStatuses(stati)
  }
  
  
  func resetChallengeStatuses(at challengeIndices: [Int]) {
    defer {
      saveChallengeStatuses(stati)
    }
    for index in challengeIndices {
      stati[index]  = ChallengeStatus.inReserve
    }
  }
  
  func totalresetofAllChallengeStatuses(gs:GameState) {
    defer {
      saveChallengeStatuses(stati)
    }
    //if let playData = playData {
    self.stati = [ChallengeStatus](repeating:ChallengeStatus.inReserve, count: playData.gameDatum.flatMap { $0.challenges }.count)
  }

  // Get the file path for storing challenge statuses
 static  func getChallengeStatusesFilePath() -> URL {
    let fileManager = FileManager.default
    let urls = fileManager.urls(for:.documentDirectory, in: .userDomainMask)
    return urls[0].appendingPathComponent("challengeStatuses.json")
  }
  
  func save() {
    AnsweredInfo.saveAnsweredInfo(ansinfo)
      TopicInfo.saveTopicInfo(tinfo)
      saveChallengeStatuses(stati)
    }
  // Save the challenge statuses to a file
  func saveChallengeStatuses(_ statuses: [ChallengeStatus]) {
    //TSLog("SAVE CHALLENGE STATUSES")
    let filePath = Self.getChallengeStatusesFilePath()
    do {
      let data = try JSONEncoder().encode(statuses)
      try data.write(to: filePath)
    } catch {
      print("Failed to save challenge statuses: \(error)")
    }
  }
  
  // Load the challenge statuses from a file
  func loadChallengeStatuses() -> [ChallengeStatus]? {
    let filePath = Self.getChallengeStatusesFilePath()
    do {
      let data = try Data(contentsOf: filePath)
      let statuses = try JSONDecoder().decode([ChallengeStatus].self, from: data)
      return statuses
    } catch {
      print("Failed to load challenge statuses: \(error)")
      return nil
    }
  }
  
  
  func loadAllData  (gs:GameState) {
    do {
      if  let gb =  GameState.loadGameState() {
        
        gs.board = gb.board
        gs.cellstate = gb.cellstate
        gs.boardsize = gb.boardsize
        gs.topicsinplay = gb.topicsinplay
        gs.topicsinorder = gb.topicsinorder
        gs.playstate = gb.playstate
        gs.totaltime = gb.totaltime
        gs.gamenumber = gb.gamenumber
        gs.rightcount = gb.rightcount
        gs.wrongcount = gb.wrongcount
        gs.lostcount = gb.lostcount
        gs.woncount = gb.woncount
        gs.replacedcount = gb.replacedcount 
        gs.gimmees = gb.gimmees
        gs.currentscheme = gb.currentscheme
        gs.veryfirstgame = gb.veryfirstgame 
        gs.doublediag = gb.doublediag
        gs.difficultylevel = gb.difficultylevel
        gs.movenumber = gb.movenumber
        gs.moveindex = gb.moveindex
        gs.savedGamePaths = gb.savedGamePaths
        gs.onwinpath = gb.onwinpath
        gs.replaced = gb.replaced
      }
      try self.loadPlayData()
      
    } catch {
      print("Failed to load PlayData: \(error)")
    }
    checkAllTopicConsistency("chaman loaddata")
  }

  // Helper functions to get counts
  func allocatedChallengesCount() -> Int {
    return  stati.filter { $0 == .allocated }.count
  }
  
  func freeChallengesCount() -> Int {
    return  stati.filter { $0   == .inReserve }.count
  }
  
  func abandonedChallengesCount() -> Int {
    return  stati.filter { $0   == .abandoned }.count
  }
  func correctChallengesCount() -> Int {
    return  stati.filter { $0   == .playedCorrectly }.count
  }
  func incorrectChallengesCount() -> Int {
    return  stati.filter { $0   == .playedIncorrectly }.count
  }
  
  func abandonedChallengesCount(for topicName: String) -> Int {
    guard let topicInfo = tinfo[topicName] else {
      return -1
    }
    return topicInfo.replacedcount
  }
  func correctChallengesCount(for topicName: String) -> Int {
    guard let topicInfo = tinfo[topicName] else {
      return -1
    }
    return topicInfo.rightcount
  }
  func incorrectChallengesCount(for topicName: String )-> Int {
    guard let topicInfo = tinfo[topicName] else {
      return -1
    }
    return topicInfo.wrongcount
  }
  
  func freeChallengesCount(for topicName: String) -> Int {
    guard let topicInfo = tinfo[topicName] else {
      return -1
    }
    return topicInfo.freecount
  }
  
  // Get the count of allocated challenges for a specific topic name
  func allocatedChallengesCount(for topicName: String) -> Int {
    guard let topicInfo = tinfo[topicName] else {
      print("Warning: Topic \(topicName) not found in tinfo.")
      return 0
    }
    return topicInfo.alloccount
  }
  
}

extension ChaMan { 
  
  // Verify that tinfo and stati arrays are in sync
  func verifySync() -> Bool {
    for (topicName, topicInfo) in tinfo {
      var calculatedFreeCount = 0
      for index in topicInfo.challengeIndices {
        if index >= stati.count || index >= everyChallenge.count {
          print("Index out of bounds in topic \(topicName)")
          return false
        }
        if stati[index] == .inReserve {
          calculatedFreeCount += 1
        }
      }
      if calculatedFreeCount != topicInfo.freecount {
        print("Free count mismatch in topic \(topicName): calculated \(calculatedFreeCount), expected \(topicInfo.freecount)")
        return false
      }
    }
    return true
  }
  func checkSingleTopicConsistency(_ topic:String,_ message:String) {
    
    let ti = tinfo[topic]
    conditionalAssert(ti != nil)
    let t = ti!
    let free = freeChallengesCount(for:topic)
    let alloc = allocatedChallengesCount(for:topic)
    let abandon = abandonedChallengesCount(for:topic)
    let correct = correctChallengesCount(for:topic)
    let incorrect = incorrectChallengesCount(for:topic)
    conditionalAssert(free == t.freecount,"\(message) \(topic) free \(free) != \(t.freecount)")
    conditionalAssert(alloc == t.alloccount,"\(message) \(topic) alloc \(alloc) != \(t.alloccount)")
    conditionalAssert(abandon == t.replacedcount,"\(message) \(topic) abandon \(abandon) != \(t.replacedcount)")
    conditionalAssert(correct == t.rightcount,"\(message) \(topic) correct \(correct) != \(t.rightcount)")
    conditionalAssert(incorrect == t.wrongcount,"\(message) \(topic) incorrect \(incorrect) != \(t.wrongcount)")
  }
  func checkAllTopicConsistency(_ message:String) {
    conditionalAssert( verifySync(),"\(message) sync")
   // checkTinfoConsistency(message: message)
    var freecount = 0
    let freeFromStati = freeChallengesCount()
    var alloccount = 0
    let allocFromStati = allocatedChallengesCount()
    var abandoncount = 0
    let abandonFromStati = abandonedChallengesCount()
    var correctcount =  0
    let correctFromStati = correctChallengesCount()
    var incorrectcount = 0
    let incorrectFromStati = incorrectChallengesCount()
    
    for t in  playData.topicData.topics {
      checkSingleTopicConsistency(t.name,message)
      freecount += freeChallengesCount(for:t.name)
      alloccount += allocatedChallengesCount(for:t.name)
      abandoncount += abandonedChallengesCount(for:t.name)
      correctcount += correctChallengesCount(for:t.name)
      incorrectcount +=  incorrectChallengesCount(for:t.name)
    }
    conditionalAssert(abandoncount == abandonFromStati,"\(message) abandoncount \(abandoncount) not \(abandonFromStati)")
    conditionalAssert(correctcount == correctFromStati,"\(message) correctcount \(correctcount) not \(correctFromStati)")
    conditionalAssert(incorrectcount == incorrectFromStati,"\(message) incorrectcount \(incorrectcount) not \(incorrectFromStati)")
    conditionalAssert(freecount ==  freeFromStati,"\(message) freecount \(freecount) not \(freeFromStati)")
    conditionalAssert(alloccount == allocFromStati ,"\(message) alloccount \(alloccount) not \(allocFromStati)")
  }
  
  func dumpTopics () {
    print("Dump of Challenges By Topic")
    print("=============================")
    print("Allocated: \( allocatedChallengesCount()) Free: \( freeChallengesCount())")
    for topic in playData.topicData.topics {
      let pp = """
\(topic.name.paddedOrTruncated(toLength: 50, withPadCharacter: ".")) \(allocatedChallengesCount(for:topic.name)) \(freeChallengesCount(for:topic.name)) \(abandonedChallengesCount(for: topic.name)) \(correctChallengesCount(for: topic.name)) \(incorrectChallengesCount(for: topic.name))
"""
      print(pp )
    }
    print("=============================")
  }
    func dumpStati(_ mess:String){
      var counter = 0
      print("Dump status \(mess)")
      print("==========================")
      for (idx,sta) in stati.enumerated() {
        if sta != .inReserve {
          print (" \(idx) \(sta)")
          counter += 1
        }
      }
      print("\(counter) allocated or played out of \(stati.count)")
    }
}


