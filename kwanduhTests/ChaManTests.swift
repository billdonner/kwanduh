import XCTest
@testable import kwanduh
// Extend the existing ChaManTests class
final class ChaManTests: XCTestCase {

    var playData: PlayData!
    var chaMan: ChaMan!

    override func setUp() {
        super.setUp()
        // Initialize PlayData with mock data
        let geoChallenges = [
          
          Challenge(
          question: "What is the capital of France?",
          topic: "Geography",
          hint: "It's also known as the City of Light",
          answers: ["Berlin", "Paris", "Rome", "Madrid"],
          correct: "Paris",
          id: UUID().uuidString,
          date: Date(),
          aisource: "Manual",
          notes: "Capital question"
      ),
            Challenge(
                question: "What is the capital of Russia?",
                topic: "Geography",
                hint: "It's also known as the City of Light",
                answers: ["Berlin", "Paris", "Rome", "Madrid"],
                correct: "Paris",
                id: UUID().uuidString,
                date: Date(),
                aisource: "Manual",
                notes: "Capital question"
            )
        ]
      let mathChallenges = [
          Challenge(
              question: "What is 2+2?",
              topic: "Math",
              hint: "Simple addition",
              answers: ["3", "4", "5", "6"],
              correct: "4",
              id: UUID().uuidString,
              date: Date(),
              aisource: "Manual",
              notes: "Basic math question"
          ),
          Challenge(
              question: "What is 4+4?",
              topic: "Math",
              hint: "Simple addition",
              answers: ["3", "4", "5", "6"],
              correct: "4",
              id: UUID().uuidString,
              date: Date(),
              aisource: "Manual",
              notes: "Basic math question"
          ),
      ]
        let mockTopicGroup = TopicGroup(
            description: "Sample Topics",
            version: "1.0",
            author: "Test Author",
            date: "2024-11-15",
            topics: [
                BasicTopic(name: "Math"),
                BasicTopic(name: "Geography")
            ]
        )

        playData = PlayData(
            topicData: mockTopicGroup,
            gameDatum: [
              GameData(topic: "Math", challenges: mathChallenges),
                GameData(topic: "Geography", challenges: geoChallenges)
            ],
            playDataId: UUID().uuidString,
            blendDate: Date()
        )

        // Initialize ChaMan with PlayData
        chaMan = ChaMan(playData: playData)

      chaMan.tinfo = [
          "Math": TopicInfo(
              name: "Math",                // Name of the topic
              alloccount: 0,
              freecount: 2,               // Challenges currently allocated
              replacedcount: 0,            // Challenges replaced due to some condition
              rightcount: 0,               // Challenges answered correctly
              wrongcount: 0,               // Challenges answered incorrectly
              challengeIndices: [0, 1]     // Indices of challenges associated with Math
          ),
          "Geography": TopicInfo(
              name: "Geography",           // Name of the topic
              alloccount: 0,
              freecount: 2,               // Challenges currently allocated
              replacedcount: 0,            // Challenges replaced due to some condition
              rightcount: 0,               // Challenges answered correctly
              wrongcount: 0,               // Challenges answered incorrectly
              challengeIndices: [2, 3]     // Indices of challenges associated with Geography
          )
      ]
        chaMan.stati = Array(repeating: .inReserve, count: 4)
    }

    override func tearDown() {
        playData = nil
        chaMan = nil
        super.tearDown()
    }

    // MARK: - Test: Allocate Challenges
    func testAllocateChallengesSuccess() {
        // Given
        let topics = ["Math", "Geography"]
        let count = 3

        // When
        let result = chaMan.allocateChallenges(forTopics: topics, count: count)

        // Then
        switch result {
        case .success(let allocatedIndices):
            XCTAssertEqual(allocatedIndices.count, count, "Should allocate exactly \(count) challenges.")
            for index in allocatedIndices {
                XCTAssertEqual(chaMan.stati[index], .allocated, "Challenge at index \(index) should be 'allocated'.")
            }
            XCTAssertEqual(chaMan.tinfo["Math"]?.alloccount, 2, "Math should have 1 allocated challenge.")
            XCTAssertEqual(chaMan.tinfo["Geography"]?.alloccount,1, "Geography should have 2 allocated challenges.")
        case .error(let error):
            XCTFail("Allocation failed with error: \(error)")
        }
    }

    func testAllocateChallengesInsufficientChallenges() {
        // Given
        let topics = ["Math", "Geography"]
        let count = 5 // More than available challenges

        // When
        let result = chaMan.allocateChallenges(forTopics: topics, count: count)

        // Then
        switch result {
        case .success:
            XCTFail("Allocation should fail due to insufficient challenges.")
        case .error(let error):
            XCTAssertEqual(error, .insufficientChallenges(4), "Should report insufficient challenges.")
        }
    }

    // MARK: - Test: Deallocate Challenges
    func testDeallocAtSuccess() {
        // Allocate first
        _ = chaMan.allocateChallenges(forTopics: ["Math"], count: 2)

        // Given
        let indicesToDeallocate = [0, 1] // Indices of allocated challenges

        // When
        let result = chaMan.deallocAt(indicesToDeallocate)

        // Then
        switch result {
        case .success:
            for index in indicesToDeallocate {
                XCTAssertEqual(chaMan.stati[index], .inReserve, "Challenge at index \(index) should be 'inReserve' after deallocation.")
            }
            XCTAssertEqual(chaMan.tinfo["Math"]?.alloccount, 0, "Math should have no allocated challenges after deallocation.")
        case .error(let error):
            XCTFail("Deallocation failed with error: \(error)")
        }
    }

    func testDeallocAtInvalidIndices() {
        // Allocate first
        _ = chaMan.allocateChallenges(forTopics: ["Math"], count: 2)

        // Given
        let invalidIndices = [10, 11] // Out-of-bounds indices

        // When
        let result = chaMan.deallocAt(invalidIndices)

        // Then
        switch result {
        case .success:
            XCTFail("Deallocation should fail for invalid indices.")
        case .error(let error):
            XCTAssertEqual(error, .invalidDeallocIndices(invalidIndices), "Should report invalid deallocation indices.")
        }
    }
}
