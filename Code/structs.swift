import SwiftUI


typealias ColorSchemeName = Int

/// Represents the state of a game cell
enum GameCellState: Codable {
  case playedCorrectly
  case playedIncorrectly
  case unplayed
  case blocked
}
/// Represents a position in the matrix
struct Coordinate: Hashable {
  let row: Int
  let col: Int
}

extension GameCellState {
  var borderColor: Color {
      switch self {
      case .playedCorrectly:
          return Color.green
      case .playedIncorrectly:
          return Color.red
      case .unplayed:
          return .gray
      case .blocked:
          return Color.gray.opacity(0.5)
      }
  }
}


enum CornerPosition: CaseIterable {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}


enum StateOfPlay : Int, Codable {
  case initializingApp
  case playingNow
  case justLost
  case justWon
  case justAbandoned
}

struct IdentifiablePoint: Identifiable {
  internal init(row: Int, col: Int, status: ChallengeStatus? = nil) {
    self.row = row
    self.col = col
    self.status = status
  }
  
  let id = UUID()
  let row: Int
  let col: Int
  let status: ChallengeStatus?
}
// Mark: - Colors
struct RGB: Codable {
  let red: Double
  let green: Double
  let blue: Double
}

// MARK: - Data Models


struct BasicTopic: Codable {
    public init(name: String, subject: String="", pic: String="", notes: String="", subtopics: [String]=[]) {
        self.name = name
        self.subject = subject
        self.pic = pic
        self.notes = notes
        self.subtopics = subtopics
    }
    
    public var name: String
    public var subject: String
    public var pic: String
    public var notes: String
    public var subtopics: [String]
}
// MARK: - TopicInfo Struct
struct TopicInfo: Codable {
  let name: String
  var alloccount: Int
  var freecount: Int
  var replacedcount: Int
  var rightcount: Int
  var wrongcount: Int
  var challengeIndices: [Int] // Indexes into stati
}
struct TopicGroup: Codable {
    public init(description: String, version: String, author: String, date: String, topics: [BasicTopic]) {
        self.description = description
        self.version = version
        self.author = author
        self.date = date
        self.topics = topics
    }
    
    public var description: String
    public var version: String
    public var author: String
    public var date: String
    public var topics: [BasicTopic]
}

struct GameData: Codable, Hashable, Identifiable, Equatable {
    public init(topic: String, challenges: [Challenge], pic: String? = "leaf", shuffle: Bool = false, commentary: String? = nil) {
        self.topic = topic
        self.challenges = shuffle ? challenges.shuffled() : challenges
        self.id = UUID().uuidString
        self.generated = Date()
        self.pic = pic
        self.commentary = commentary
    }
    
    public let id: String
    public let topic: String
    public let challenges: [Challenge]
    public let generated: Date
    public let pic: String?
    public let commentary: String?
}

struct PlayData: Codable {
    public init(topicData: TopicGroup, gameDatum: [GameData], playDataId: String, blendDate: Date, pic: String? = nil) {
        self.topicData = topicData
        self.gameDatum = gameDatum
        self.playDataId = playDataId
        self.blendDate = blendDate
        self.pic = pic
    }
    
    public let topicData: TopicGroup
    public let gameDatum: [GameData]
    public let playDataId: String
    public let blendDate: Date
    public let pic: String?
  
  var allTopics : [String] {
    self.topicData.topics.map {$0.name}
  }
}
extension Color {
    static let neonGreen = Color(red: 57/255, green: 255/255, blue: 20/255)
    static let neonRed = Color(red: 255/255, green: 16/255, blue: 16/255)
}

struct Challenge: Codable, Equatable, Hashable, Identifiable {
  public let question: String
  public let topic: String
  public let hint: String
  public let answers: [String]
  public let correct: String
  public let explanation: String?
  public let id: String
  public let date: Date
  public let aisource: String
  public let notes: String?
  
  public init(question: String, topic: String, hint: String, answers: [String], correct: String, explanation: String? = nil, id: String, date: Date, aisource: String, notes: String? = nil) {
    self.question = question
    self.topic = topic
    self.hint = hint
    self.answers = answers
    self.correct = correct
    self.explanation = explanation
    self.id = id
    self.date = date
    self.aisource = aisource
    self.notes = notes
  }
}


enum ChallengeError: Error {
  case notfound
}

// these will be ungainly
// Result enum to handle allocation and deallocation outcomes
enum AllocationResult: Equatable {
  case success([Int])
  case error(AllocationError)
  
  enum AllocationError: Equatable, Error {
//    static func ==(lhs: AllocationError, rhs: AllocationError) -> Bool {
//      switch (lhs, rhs) {
//      case (.emptyTopics, .emptyTopics):
//        return true
//      case (.invalidTopics(let lhsTopics), .invalidTopics(let rhsTopics)):
//        return lhsTopics == rhsTopics
//      case (.insufficientChallenges, .insufficientChallenges):
//        return true
//      default:
//        return false
//      }
//    }
    
    
    
    static func == (lhs: AllocationError, rhs: AllocationError) -> Bool {
        switch (lhs, rhs) {
        case (.insufficientChallenges(let l), .insufficientChallenges(let r)):
            return l == r
        case (.invalidDeallocIndices(let l), .invalidDeallocIndices(let r)):
            return l == r
        default:
            return false
        }
    }
    
    case emptyTopics
    case invalidTopics([String])
    case invalidDeallocIndices([Int])
    case insufficientChallenges(Int)
  }
}
enum FreeportColor: Int, CaseIterable, Comparable, Codable {
    case myLightYellow, myDeepPink, myLightBlue, myRoyalBlue, myPeach, myOrange, myLavender, myMint, myLightCoral, myAqua, myLemon, mySkyBlue, mySunshineYellow, myOceanBlue, mySeafoam, myPalmGreen, myCoral, myLagoon, myShell, mySienna, myCoconut, myPineapple, myBurntOrange, myGoldenYellow, myCrimsonRed, myPumpkin, myChestnut, myHarvestGold, myAmber, myMaroon, myRusset, myMossGreen, myIceBlue, myMidnightBlue, myFrost, mySlate, mySilver, myPine, myBerry, myEvergreen, myStorm, myHolly, myOffWhite, myOffBlack, myGold, myHotPink, myDarkOrange, myDarkViolet, myDarkGreen, myCrimson, myTeal, myNavy, myGoldenrod, myForestGreen, myDeepTeal, myChocolate, myBrown, myDarkGoldenrod, myDarkRed, myOrangeRed, mySaddleBrown, myDarkOliveGreen, myPrussianBlue, myAliceBlue, mySteelBlue, myDarkSlateGray, myDarkGray, myWhite
}
