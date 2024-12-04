//
//  GameLogicTests.swift
//  kwanduh
//
//  Created by bill donner on 11/17/24.
//

import XCTest
@testable import kwanduh

final class GameLogicTests: XCTestCase {

    func testBlockedCellsPreventWinningPath() {
        let matrix: [[GameCellState]] = [
            [.unplayed, .unplayed, .unplayed],
            [.blocked, .playedCorrectly, .unplayed],
            [.unplayed, .playedIncorrectly, .unplayed]
        ]
        let result = isWinningPath(in: matrix)
        XCTAssertFalse(result, "Winning path should not be found when blocked cells prevent traversal.")
    }

    func testUnblockedWinningPath() {
        let matrix: [[GameCellState]] = [
            [.playedCorrectly, .unplayed, .unplayed],
            [.playedCorrectly, .playedCorrectly, .unplayed],
            [.playedCorrectly, .unplayed, .playedCorrectly]
        ]
        let result = isWinningPath(in: matrix)
        XCTAssertTrue(result, "Winning path should be found when no blocked cells prevent traversal.")
    }

    func testCornerConditionLoss() {
        let matrix: [[GameCellState]] = [
            [.playedIncorrectly, .unplayed, .playedIncorrectly],
            [.unplayed, .blocked, .unplayed],
            [.unplayed, .unplayed, .unplayed]
        ]
        let result = hasLosingCornerCondition(in: matrix)
        XCTAssertTrue(result, "Should detect losing corner condition.")
    }

    func testSimpleCircuitousPath() {
        let matrix: [[GameCellState]] = [
            [.playedCorrectly, .blocked, .unplayed],
            [.unplayed, .playedCorrectly, .blocked],
            [.unplayed, .playedCorrectly, .playedCorrectly]
        ]
        let result = isWinningPath(in: matrix)
        XCTAssertTrue(result, "Circuitous path should be valid despite detours.")
    }

    func testCircuitousPathWithLoops() {
        let matrix: [[GameCellState]] = [
            [.playedCorrectly, .playedCorrectly, .blocked],
            [.unplayed, .playedCorrectly, .unplayed],
            [.playedCorrectly, .blocked, .playedCorrectly]
        ]
        let result = isWinningPath(in: matrix)
        XCTAssertTrue(result, "Path looping around blocked cells should still be valid.")
    }

    func testCircuitousPathAroundObstacles() {
        let matrix: [[GameCellState]] = [
            [.playedCorrectly, .blocked, .blocked],
            [.playedCorrectly, .playedCorrectly, .blocked],
            [.blocked, .playedCorrectly, .playedCorrectly]
        ]
        let result = isWinningPath(in: matrix)
        XCTAssertTrue(result, "Path avoiding obstacles and going around should be valid.")
    }

    func testInvalidCircuitousPathWithBlockedEnds() {
        let matrix: [[GameCellState]] = [
            [.playedCorrectly, .playedCorrectly, .blocked],
            [.playedCorrectly, .blocked, .playedCorrectly],
            [.blocked, .playedCorrectly, .blocked]
        ]
        let result = isWinningPath(in: matrix)
        XCTAssertFalse(result, "Circuitous path with blocked endpoints should fail.")
    }

    func testCircuitousPathTraversingMultipleDiagonals() {
        let matrix: [[GameCellState]] = [
            [.playedCorrectly, .unplayed, .playedCorrectly],
            [.blocked, .playedCorrectly, .blocked],
            [.playedCorrectly, .unplayed, .playedCorrectly]
        ]
        let result = isWinningPath(in: matrix)
        XCTAssertTrue(result, "Complex diagonal path with valid cells should succeed.")
    }

  func testPathFailsIfCircuitousRouteHitsBlockedCells() {
      let matrix: [[GameCellState]] = [
          [.playedCorrectly, .blocked, .unplayed],
          [.blocked, .playedCorrectly, .blocked],
          [.playedCorrectly, .blocked, .playedCorrectly]
      ]
      let result = isWinningPath(in: matrix)
//      print("Matrix state: \(matrix)")
//      print("Result from isWinningPath: \(result)")
    XCTAssertTrue(result, "Path on the main diagonal should be valid despite blocked cells elsewhere.")
  }
  func testCircuitousPathAroundMultipleObstacles() {
      let matrix: [[GameCellState]] = [
          [.playedCorrectly, .blocked, .unplayed, .unplayed],
          [.unplayed, .playedCorrectly, .blocked, .unplayed],
          [.unplayed, .blocked, .playedCorrectly, .unplayed],
          [.unplayed, .unplayed, .blocked, .playedCorrectly]
      ]
      let result = isWinningPath(in: matrix)
      XCTAssertTrue(result, "Path should navigate around multiple blocked cells to reach a valid diagonal.")
  }
  
  func testPossiblePathWithUnplayedCells() {
        let matrix: [[GameCellState]] = [
            [.playedCorrectly, .unplayed, .unplayed],
            [.unplayed, .playedCorrectly, .unplayed],
            [.playedCorrectly, .unplayed, .unplayed]
        ]
        let result = isPossibleWinningPath(in: matrix)
        XCTAssertTrue(result, "A potential path exists with unplayed cells.")
    }

    func testImpossiblePathWithFullyBlockedRows() {
        let matrix: [[GameCellState]] = [
            [.blocked, .blocked, .blocked],
            [.unplayed, .playedCorrectly, .unplayed],
            [.blocked, .blocked, .blocked]
        ]
        let result = isPossibleWinningPath(in: matrix)
        XCTAssertFalse(result, "No possible path should exist with fully blocked rows.")
    }

    func testPossiblePathAvoidingBlocks() {
        let matrix: [[GameCellState]] = [
            [.playedCorrectly, .blocked, .unplayed],
            [.unplayed, .playedCorrectly, .unplayed],
            [.playedCorrectly, .unplayed, .playedCorrectly]
        ]
        let result = isPossibleWinningPath(in: matrix)
        XCTAssertTrue(result, "A potential path exists around blocked cells.")
    }

    func testNoPathDueToCornerConditions() {
        let matrix: [[GameCellState]] = [
            [.playedIncorrectly, .unplayed, .playedIncorrectly],
            [.unplayed, .blocked, .unplayed],
            [.unplayed, .unplayed, .unplayed]
        ]
        let result = isPossibleWinningPath(in: matrix)
        XCTAssertFalse(result, "No possible path should exist with losing corner conditions.")
    }

    func testPotentialPathTraversingDiagonals() {
        let matrix: [[GameCellState]] = [
            [.playedCorrectly, .unplayed, .playedCorrectly],
            [.unplayed, .playedCorrectly, .unplayed],
            [.playedCorrectly, .unplayed, .playedCorrectly]
        ]
        let result = isPossibleWinningPath(in: matrix)
        XCTAssertTrue(result, "Potential diagonal paths should be identified.")
    }
  func test4x4FalseWinPath() {
         let matrix: [[GameCellState]] = [
             [.unplayed, .blocked, .blocked, .unplayed],
             [.unplayed, .unplayed, .playedCorrectly, .unplayed],
             [.blocked, .playedCorrectly, .unplayed, .unplayed],
             [.playedCorrectly, .unplayed, .unplayed, .unplayed]
         ]
         let result = isWinningPath(in: matrix)
         XCTAssertFalse(result, "Premature short win path.")
     }
  func test4x4PossibleWhenRoadblocked() {
         let matrix: [[GameCellState]] = [
             [.unplayed, .unplayed, .blocked, .unplayed],
             
                 [.unplayed, .unplayed, .blocked, .unplayed],
             
                 [.unplayed, .unplayed, .blocked, .unplayed],
             
                 [.unplayed, .unplayed, .blocked, .unplayed]
         ]
         let result = isWinningPath(in: matrix)
         XCTAssertFalse(result, "No Winning Path Should Be Possible When Column Roadblocked")
     }
  func test4x4ClearDiagonalPath() {
         let matrix: [[GameCellState]] = [
             [.playedCorrectly, .unplayed, .unplayed, .unplayed],
             [.unplayed, .playedCorrectly, .unplayed, .unplayed],
             [.unplayed, .unplayed, .playedCorrectly, .unplayed],
             [.unplayed, .unplayed, .unplayed, .playedCorrectly]
         ]
         let result = isWinningPath(in: matrix)
         XCTAssertTrue(result, "The main diagonal forms a clear winning path.")
     }

     // Test Case 2: 6x6 Matrix with a Circuitous Path
     func test6x6CircuitousPath() {
         let matrix: [[GameCellState]] = [
             [.playedCorrectly, .blocked, .unplayed, .unplayed, .unplayed, .unplayed],
             [.unplayed, .playedCorrectly, .blocked, .unplayed, .unplayed, .unplayed],
             [.unplayed, .blocked, .playedCorrectly, .blocked, .unplayed, .unplayed],
             [.unplayed, .unplayed, .blocked, .playedCorrectly, .unplayed, .unplayed],
             [.unplayed, .unplayed, .unplayed, .blocked, .playedCorrectly, .unplayed],
             [.unplayed, .unplayed, .unplayed, .unplayed, .blocked, .playedCorrectly]
         ]
         let result = isWinningPath(in: matrix)
         XCTAssertTrue(result, "A valid winning path navigates around the blocked cells.")
     }

     // Test Case 3: 8x8 Matrix with a Complex Circuitous Path
     func test8x8ComplexPath() {
         let matrix: [[GameCellState]] = [
             [.playedCorrectly, .blocked, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed],
             [.blocked, .playedCorrectly, .blocked, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed],
             [.unplayed, .blocked, .playedCorrectly, .blocked, .unplayed, .unplayed, .unplayed, .unplayed],
             [.unplayed, .unplayed, .blocked, .playedCorrectly, .blocked, .unplayed, .unplayed, .unplayed],
             [.unplayed, .unplayed, .unplayed, .blocked, .playedCorrectly, .blocked, .unplayed, .unplayed],
             [.unplayed, .unplayed, .unplayed, .unplayed, .blocked, .playedCorrectly, .blocked, .unplayed],
             [.unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .blocked, .playedCorrectly, .blocked],
             [.unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .blocked, .playedCorrectly]
         ]
         let result = isWinningPath(in: matrix)
         XCTAssertTrue(result, "A valid winning path weaves through the blocked cells.")
     }

     // Test Case 4: 8x8 Matrix with an Impossible Path
     func test8x8ImpossiblePath() {
         let matrix: [[GameCellState]] = [
             [.playedCorrectly, .blocked, .blocked, .blocked, .blocked, .blocked, .blocked, .blocked],
             [.blocked, .blocked, .blocked, .blocked, .blocked, .blocked, .blocked, .blocked],
             [.blocked, .blocked, .blocked, .blocked, .blocked, .blocked, .blocked, .blocked],
             [.blocked, .blocked, .blocked, .blocked, .blocked, .blocked, .blocked, .blocked],
             [.blocked, .blocked, .blocked, .blocked, .blocked, .blocked, .blocked, .blocked],
             [.blocked, .blocked, .blocked, .blocked, .blocked, .blocked, .blocked, .blocked],
             [.blocked, .blocked, .blocked, .blocked, .blocked, .blocked, .blocked, .blocked],
             [.blocked, .blocked, .blocked, .blocked, .blocked, .blocked, .blocked, .playedCorrectly]
         ]
         let result = isWinningPath(in: matrix)
         XCTAssertFalse(result, "Blocked cells prevent any valid path.")
     }

     // Test Case 5: 8x8 Matrix with Unplayed Cells and a Winning Path
     func test8x8PathWithUnplayedCells() {
         let matrix: [[GameCellState]] = [
             [.playedCorrectly, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed],
             [.unplayed, .playedCorrectly, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed],
             [.unplayed, .unplayed, .playedCorrectly, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed],
             [.unplayed, .unplayed, .unplayed, .playedCorrectly, .unplayed, .unplayed, .unplayed, .unplayed],
             [.unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly, .unplayed, .unplayed, .unplayed],
             [.unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly, .unplayed, .unplayed],
             [.unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly, .unplayed],
             [.unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly]
         ]
         let result = isPossibleWinningPath(in: matrix)
         XCTAssertTrue(result, "Unplayed cells do not block a potential path.")
     }
  
  // Test Case 1: Clear Path with 25% Blocked Cells
     func test8x8ClearPath25Blocked() {
         let matrix: [[GameCellState]] = [
             [.playedCorrectly, .unplayed, .blocked, .unplayed, .blocked, .unplayed, .unplayed, .unplayed],
             [.unplayed, .playedCorrectly, .unplayed, .blocked, .unplayed, .blocked, .unplayed, .unplayed],
             [.unplayed, .unplayed, .playedCorrectly, .unplayed, .blocked, .unplayed, .blocked, .unplayed],
             [.unplayed, .blocked, .unplayed, .playedCorrectly, .unplayed, .unplayed, .unplayed, .unplayed],
             [.unplayed, .unplayed, .blocked, .unplayed, .playedCorrectly, .unplayed, .blocked, .unplayed],
             [.unplayed, .blocked, .unplayed, .unplayed, .unplayed, .playedCorrectly, .unplayed, .blocked],
             [.blocked, .unplayed, .unplayed, .blocked, .unplayed, .unplayed, .playedCorrectly, .unplayed],
             [.unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly]
         ]
         let result = isWinningPath(in: matrix)
         XCTAssertTrue(result, "There is a clear diagonal path through the matrix with 25% blocked cells.")
     }

     // Test Case 2: Circuitous Path with 25% Blocked Cells
     func test8x8CircuitousPath25Blocked() {
         let matrix: [[GameCellState]] = [
             [.playedCorrectly, .blocked, .unplayed, .unplayed, .unplayed, .blocked, .unplayed, .unplayed],
             [.unplayed, .playedCorrectly, .blocked, .unplayed, .unplayed, .unplayed, .blocked, .unplayed],
             [.blocked, .unplayed, .playedCorrectly, .blocked, .unplayed, .unplayed, .unplayed, .blocked],
             [.unplayed, .blocked, .unplayed, .playedCorrectly, .unplayed, .blocked, .unplayed, .unplayed],
             [.unplayed, .unplayed, .blocked, .unplayed, .playedCorrectly, .unplayed, .blocked, .unplayed],
             [.unplayed, .unplayed, .unplayed, .blocked, .unplayed, .playedCorrectly, .unplayed, .unplayed],
             [.unplayed, .blocked, .unplayed, .unplayed, .blocked, .unplayed, .playedCorrectly, .unplayed],
             [.unplayed, .unplayed, .blocked, .unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly]
         ]
         let result = isWinningPath(in: matrix)
         XCTAssertTrue(result, "A valid path navigates around blocked cells to reach the diagonal.")
     }

     // Test Case 3: No Winning Path with 25% Blocked Cells
     func test8x8NoPath25Blocked() {
         let matrix: [[GameCellState]] = [
             [.playedCorrectly, .blocked, .blocked, .unplayed, .blocked, .blocked, .blocked, .unplayed],
             [.unplayed, .blocked, .blocked, .blocked, .blocked, .unplayed, .blocked, .unplayed],
             [.blocked, .blocked, .unplayed, .blocked, .unplayed, .blocked, .unplayed, .blocked],
             [.unplayed, .blocked, .blocked, .blocked, .blocked, .unplayed, .blocked, .unplayed],
             [.unplayed, .blocked, .unplayed, .blocked, .blocked, .blocked, .blocked, .unplayed],
             [.blocked, .blocked, .blocked, .blocked, .unplayed, .blocked, .blocked, .blocked],
             [.blocked, .unplayed, .blocked, .blocked, .blocked, .blocked, .blocked, .unplayed],
             [.unplayed, .unplayed, .unplayed, .blocked, .blocked, .blocked, .blocked, .playedCorrectly]
         ]
         let result = isWinningPath(in: matrix)
         XCTAssertFalse(result, "Blocked cells prevent any valid winning path.")
     }

     // Test Case 4: Possible Path (Unplayed Cells) with 25% Blocked Cells
     func test8x8PossiblePathUnplayed25Blocked() {
         let matrix: [[GameCellState]] = [
             [.playedCorrectly, .unplayed, .unplayed, .unplayed, .blocked, .unplayed, .unplayed, .unplayed],
             [.unplayed, .playedCorrectly, .unplayed, .blocked, .unplayed, .unplayed, .unplayed, .unplayed],
             [.unplayed, .unplayed, .playedCorrectly, .blocked, .blocked, .unplayed, .unplayed, .blocked],
             [.unplayed, .unplayed, .unplayed, .playedCorrectly, .blocked, .unplayed, .unplayed, .unplayed],
             [.unplayed, .blocked, .blocked, .unplayed, .playedCorrectly, .unplayed, .unplayed, .unplayed],
             [.unplayed, .unplayed, .blocked, .unplayed, .unplayed, .playedCorrectly, .blocked, .unplayed],
             [.blocked, .unplayed, .unplayed, .unplayed, .unplayed, .blocked, .playedCorrectly, .unplayed],
             [.unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly]
         ]
         let result = isPossibleWinningPath(in: matrix)
         XCTAssertTrue(result, "A potential path exists through unplayed cells.")
     }
  
}
