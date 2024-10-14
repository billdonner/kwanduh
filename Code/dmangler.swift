//
//  dmangler.swift
//  dmangler
//
//  Created by bill donner on 10/5/24.
//

import SwiftUI



@Observable
class Dmangler  {
 init(currentScheme: Int = 1, allCounts: [Int] = [],
                allTopics: [String] = [],
                selectedTopics: [String : FreeportColor] = [:]
  ) {
    self.currentScheme = currentScheme
    self.allCounts = allCounts
    self.allTopics = allTopics
    self.selectedTopics = selectedTopics 
  }
  
  var allCounts: [Int] = []  // Count for each topic
  var allTopics: [String] = []  // All possible topics
  var selectedTopics: [String: FreeportColor] = [:]  // Selected topics with color
  var currentScheme :Int

  func changeScheme(from older: Int, to newer: Int){
    selectedTopics = reworkColors(topics:  selectedTopics,fromscheme: older,toscheme: newer)
    currentScheme = newer
  }
  func load_data(scheme:Int, topics: [String], counts: [Int], selected: [String:FreeportColor])->Self{
    currentScheme = scheme
    allCounts = counts
    allTopics = topics
    selectedTopics = selected// Mapping topics to TopicColor enum
    return self
     
  }
}
