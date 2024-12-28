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
}
