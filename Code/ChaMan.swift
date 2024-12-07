//
//  ChaMan.swift
//  basic
//
//  Created by bill donner on 6/23/24.
//

import Foundation

enum ChallengeStatus : Int, Codable  {
  case inReserve         // 0
  case allocated         // 1
  case playedCorrectly   // 2
  case playedIncorrectly // 3
  case abandoned         // 4
}

// The manager class to handle Challenge-related operations and state
@Observable
class ChaMan {
  internal init(playData: PlayData) {
    self.playData = playData
    self.stati = []
    self.tinfo = [:]
    self.ansinfo = [:]
  }
  
  // TopicInfo is built from PlayData and is used to improve performance by simplifying searching and
  // eliminating lots of scanning to get counts
  

  
  // tinfo and stati must be maintained in sync
  // tinfo["topicname"].ch[123] and stati[123] are in sync with everychallenge[123]
  
  var tinfo: [String: TopicInfo]  // Dictionary indexed by topic
  var stati: [ChallengeStatus]  // Using array instead of dictionary
  var ansinfo: [String:AnsweredInfo] // Dictionary indexed by challenge UUID
  
 var playData: PlayData {
    didSet {
      // Invalidate the cache when playData changes
      invalidateAllTopicsCache()
      invalidateAllChallengesCache()
    }
  }
  
  // Cache for allChallenges
  private var _allChallenges: [Challenge]?
  var everyChallenge: [Challenge] {
    get {
      // If _allChallenges is nil, compute the value and cache it
      if _allChallenges == nil {
        _allChallenges = playData.gameDatum.flatMap { $0.challenges }
      }
      // Return the cached value
      return _allChallenges!
    }
    set {
      // Update the cache with the new value
      _allChallenges = newValue
    }
  }
  
  // Cache for allTopics
  private var _allTopics: [String]?
  var everyTopicName: [String] {
    // If _allTopics is nil, compute the value and cache it
    if _allTopics == nil {
      _allTopics = playData.topicData.topics.map { $0.name }
    }
    // Return the cached value
    return _allTopics!
  }
  
  // Method to invalidate the allChallenges cache
  func invalidateAllChallengesCache() {
    _allChallenges = nil
  }
  
  // Method to invalidate the cache
  func invalidateAllTopicsCache() {
    _allTopics = nil
  }
  
  func checkTinfoConsistency(message:String) {
    for (topic, info) in tinfo {
      let allocatedCount = info.challengeIndices.filter { stati[$0] == .allocated }.count
      assert(info.alloccount == allocatedCount, "\(message) --Mismatch \(info.alloccount ) in alloccount \(allocatedCount) for topic \(topic)")
    }
  }
  
  func allocateChallenges(forTopics topics: [String], count n: Int) -> AllocationResult {
    print("Allocating \(n) challenges for \(topics.count) topics")
    checkAllTopicConsistency("allocateChallenges start")
    var allocatedChallengeIndices: [Int] = []
    var topicIndexes: [String: [Int]] = [:]
    var tinfobuffer: [String: TopicInfo] = tinfo
    
    func fixup(_ topic: String, _ topicIndexes: inout [String : [Int]], _ allocatedIndexes: Array<Int>.SubSequence) {
      // Update tinfo to keep it in sync
      if var topicInfo = tinfo[topic] {
        topicInfo.freecount -= allocatedIndexes.count
        topicInfo.alloccount += allocatedIndexes.count
        tinfobuffer[topic] = topicInfo
        topicInfo.checkConsistency()
      }
    }
    // dumpStati("allocateChallenges start")
    checkAllTopicConsistency("allocateChallenges start")
    // Defensive check for empty topics array
    guard !topics.isEmpty else {
      return .error(.emptyTopics)
    }
    
    // Populate the dictionary with indexes inReserve for each specified topic
    for topic in topics {
      if let topicInfo = tinfo[topic] {
        let idxs:[Int]=topicInfo.challengeIndices.compactMap{stati[$0] == .inReserve ? $0 : nil}
        topicIndexes[topic] = idxs
      } else {
        checkAllTopicConsistency("allocateChallenges invalidTopics")
        return .error(.invalidTopics([topic]))
      }
    }
    
    // Calculate the total number of available challenges in the specified topics
    let totalFreeChallenges = topics.reduce(0) { $0 + (tinfo[$1]?.freecount ?? 0) }
    
    // Check if total available challenges are less than required
    if totalFreeChallenges < n {
      
        checkAllTopicConsistency("allocateChallenges insufficientChallenges")
      return .error(.insufficientChallenges(totalFreeChallenges))
    }
    
    // First pass: Allocate challenges nearly evenly from the specified topics
    let challengesPerTopic = n / topics.count
    var remainingChallenges = n % topics.count
    
    for topic in topics {
      if let nindexes = topicIndexes[topic], !nindexes.isEmpty {
        let indexes = nindexes.shuffled()
        let countToAllocate = min(indexes.count, challengesPerTopic + (remainingChallenges > 0 ? 1 : 0))
        let allocatedIndexes = indexes.prefix(countToAllocate)
        allocatedChallengeIndices.append(contentsOf: allocatedIndexes)
        remainingChallenges -= 1
        // Update topicIndexes
        topicIndexes[topic] = Array(indexes.dropFirst(countToAllocate))
        fixup(topic, &topicIndexes, allocatedIndexes)
        checkSingleTopicConsistency(topic,"First pass")
      }
    }
    
    // Second pass: Allocate remaining challenges from the specified topics even if imbalanced
    for topic in topics {
      if allocatedChallengeIndices.count >= n {
        break
      }
      
      if let nindexes = topicIndexes[topic], !nindexes.isEmpty {
        let indexes = nindexes.shuffled()
        let remainingToAllocate = n - allocatedChallengeIndices.count
        let countToAllocate = min(indexes.count, remainingToAllocate)
        let allocatedIndexes = indexes.prefix(countToAllocate)
        allocatedChallengeIndices.append(contentsOf: allocatedIndexes)
        
        // Update topicIndexes
        topicIndexes[topic] = Array(indexes.dropFirst(countToAllocate))
        fixup(topic, &topicIndexes, allocatedIndexes)
        checkSingleTopicConsistency(topic,"Second pass")
      }
    }
    
    // Third pass: If still not enough challenges, take from any available topic
    if allocatedChallengeIndices.count < n {
      for (topic, info) in tinfo {
        if !topics.contains(topic) { // Skip specified topics since they have already been considered
          let nindexes = info.challengeIndices
          if !nindexes.isEmpty {
            let indexes = nindexes.shuffled()
            let remainingToAllocate = n - allocatedChallengeIndices.count
            let countToAllocate = min(indexes.count, remainingToAllocate)
            let allocatedIndexes = indexes.prefix(countToAllocate)
            allocatedChallengeIndices.append(contentsOf: allocatedIndexes)
            
            // Update topicIndexes
            var updatedIndexes = indexes
            updatedIndexes.removeFirst(countToAllocate)
            topicIndexes[topic] = updatedIndexes
            fixup(topic, &topicIndexes, allocatedIndexes)
            checkSingleTopicConsistency(topic,"Third pass")
            // Check if we have allocated enough challenges
            if allocatedChallengeIndices.count >= n {
              break
            }
          }
        }
      }
    }
    
    // Update stati to reflect allocation
    for index in allocatedChallengeIndices {
      stati[index] = .allocated
    }
    //if we got this far
    tinfo = tinfobuffer
    //dumpStati("allocateChallenges end")
    checkAllTopicConsistency("allocateChallenges end")
    save()
    print("Allocated \(allocatedChallengeIndices.count) challenges for \(topics.count) topics indices: \(allocatedChallengeIndices.sorted())")
    return .success(allocatedChallengeIndices)//.shuffled()) // see if this works
  }
  
  
  func deallocAt(_ indexes: [Int]) -> AllocationResult {
    print("Deallocating \(indexes.count) challenges at indices \(indexes.sorted())")
    checkAllTopicConsistency("deallocAt start")
    var topicIndexes: [String: [Int]] = [:]
    var invalidIndexes: [Int] = []
    var tinfobuffer: [String: TopicInfo] = tinfo
    checkAllTopicConsistency("dealloc  start")
    // Collect the indexes of the challenges to deallocate and group by topic
    for index in indexes {
      if index >= everyChallenge.count {
        invalidIndexes.append(index)
        continue
      }
      let challenge = everyChallenge[index]
      let topic = challenge.topic // Assuming `Challenge` has a `topic` property
      assert(index < stati.count, "deallocAt Index out of bounds in stati")
      assert(index < everyChallenge.count, "deallocAt Index out of bounds in everyChallenge")
      if stati[index] == .inReserve {
        invalidIndexes.append(index)
        continue
      }
      if topicIndexes[topic] == nil {
        topicIndexes[topic] = []
      }
      topicIndexes[topic]?.append(index)
    }
    
    // Check for invalid indexes
    if !invalidIndexes.isEmpty {
      checkAllTopicConsistency("deallocAt invalidDeallocIndices")
      return .error(.invalidDeallocIndices(invalidIndexes.sorted()))
    }
    
    // Update tinfo to deallocate challenges
    for (topic, indexes) in topicIndexes {
      if var topicInfo = tinfo[topic] {
        // Remove indexes from topicInfo.ch and move them to the end
        for index in indexes {
          if let pos = topicInfo.challengeIndices.firstIndex(of: index) {
            topicInfo.challengeIndices.remove(at: pos)
            topicInfo.challengeIndices.append(index) // Move to the end
          }
        }
        topicInfo.freecount += indexes.count
        topicInfo.alloccount -= indexes.count
        // Update tinfo to keep it in sync
        //tinfo[topic] = topicInfo
        tinfobuffer[topic] = topicInfo
        topicInfo.checkConsistency()
      } else {
        
          checkAllTopicConsistency("deallocAt invalidTopics")
        return .error(.invalidTopics([topic]))
      }
    }
    
    // Update stati to reflect deallocation
    for index in indexes {
      if index < stati.count {
        stati[index] = .inReserve // Set the status to inReserve
      }
    }
    tinfo = tinfobuffer
    save()
    checkAllTopicConsistency("deallc end")
    return .success([])
  }
  // find another challenge index for same topic and allocate it
  func replaceChallenge(at index: Int) -> AllocationResult {
    guard index < everyChallenge.count else {
      return .error(.invalidTopics(["Invalid index: \(index)"]))
    }
    
    let challenge = everyChallenge[index]
    let topic = challenge.topic // Assuming `Challenge` has a `topic` property
    
    
    // Find a new challenge to replace the old one
    if var topicInfo = tinfo[topic] {
      // for now just try within topic
      guard let newChallengeIndex = topicInfo.challengeIndices.last(where: { stati[$0] == .inReserve }) else {
        return .error(.insufficientChallenges(1))
      }
      
      print("replacing Challenge at \(index) with challenge at \(newChallengeIndex)")
      stati[index] = .abandoned
      print("marking \(index) as abandoned")
      stati[newChallengeIndex] = .allocated
      print("marking \(newChallengeIndex) is \(stati[newChallengeIndex])")
      topicInfo.replacedcount += 1
      topicInfo.freecount -= 1
      tinfo[topic] = topicInfo
      save()
      // Return the index of the we supplied
      checkAllTopicConsistency("replaceChallenge end")
      return .success([newChallengeIndex])
    }
    return .error(.invalidTopics([topic]))
  }
}
