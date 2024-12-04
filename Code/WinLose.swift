//
// This file is maintained in the mac app Winner, which has about 100 test cases for this vital code
// v 0.96

import Foundation

 
/// Represents a position in the matrix
struct Coordinate: Hashable {
  let row: Int
  let col: Int
}
/// Prints a matrix of `GameCellState` with winning path cells highlighted.
/// - Parameters:
///   - matrix: The game board represented as a 2D array of `GameCellState`.
///   - winningPath: A list of coordinates (row, col) that represent the winning path.
func printMatrix(_ matrix: [[GameCellState]], winningPath: [Coordinate]? = nil) {
    let winningSet = Set(winningPath ?? [])
    
    for (rowIndex, row) in matrix.enumerated() {
        let rowString = row.enumerated().map { colIndex, cell in
          if winningSet.contains(Coordinate(row: rowIndex, col: colIndex)) {
                return "W" // Highlight cells on the winning path
            }
            switch cell {
            case .unplayed:
                return "U"
            case .blocked:
                return "B"
            default:
                return " " // Unreachable in this context but kept for safety
            }
        }.joined(separator: " ")
        print(rowString)
    }
    print() // Add an empty line for spacing
}
func pm(s:String,m:[[GameCellState]])->String {
  printMatrix(m)
  return s
}
/// Determines if there is a valid winning path in the matrix and logs the path if it exists.
/// - Parameter matrix: The game board represented as a 2D array of `GameCellState`
/// - Returns: `true` if a winning path exists, otherwise `false`
func isWinningPath(in matrix: [[GameCellState]]) -> Bool {
    // Check if losing conditions are met
    if hasLosingCornerCondition(in: matrix) {
        return false
    }

    // Determine if there is a valid path
    let (path, pathExists) = winningPath(in: matrix)

    if pathExists {
        print("Winning path found: \(path)")
      printMatrix(matrix, winningPath: path.map {Coordinate (row: $0.row, col: $0.col) })
    } else {
        print("No winning path found.")
        printMatrix(matrix)
    }

    return pathExists
}

/// Determines if a theoretical winning path is possible
/// - Parameter matrix: The game board represented as a 2D array of `GameCellState`
/// - Returns: `true` if a possible path exists, otherwise `false`
func isPossibleWinningPath(in matrix: [[GameCellState]]) -> Bool {
  let n = matrix.count
  guard n > 0 else { return false }

  // Check for losing conditions
  if hasLosingCornerCondition(in: matrix) {
    return false
  }

  // Define start and end points for diagonals
  let startPoints = [(0, 0), (0, n - 1)]
  let endPoints = [(n - 1, n - 1), (n - 1, 0)]
  let directions = [
    (0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1),
  ]

  /// Breadth-first search to determine if a path exists
  func bfs(start: (Int, Int), end: (Int, Int)) -> Bool {
    var queue = [start]
    var visited = Set<String>()
    visited.insert("\(start.0),\(start.1)")

    while !queue.isEmpty {
      let (row, col) = queue.removeFirst()

      // Check if we've reached the end point
      if (row, col) == end {
        return true
      }

      // Explore neighbors
      for dir in directions {
        let newRow = row + dir.0
        let newCol = col + dir.1
        let key = "\(newRow),\(newCol)"

        if newRow >= 0, newRow < n, newCol >= 0, newCol < n,
          !visited.contains(key),
          matrix[newRow][newCol] != .blocked,
          matrix[newRow][newCol] != .playedIncorrectly
        {
          queue.append((newRow, newCol))
          visited.insert(key)
        }
      }
    }

    return false
  }

  // Check each diagonal separately
  for (start, end) in zip(startPoints, endPoints) {
    if bfs(start: start, end: end) {
      return true
    }
  }

  return false
}

/// Checks if there are conditions that would automatically result in a loss
/// - Parameter matrix: The game board represented as a 2D array of `GameCellState`
/// - Returns: `true` if losing conditions exist, otherwise `false`
func hasLosingCornerCondition(in matrix: [[GameCellState]]) -> Bool {
  let n = matrix.count
  guard n > 1 else { return false }

  // Check for incorrect corners on the same side
  let sameSideCorners = [
    (matrix[0][0], matrix[n - 1][0]),  // Left side
    (matrix[0][0], matrix[0][n - 1]),  // Top side
    (matrix[0][n - 1], matrix[n - 1][n - 1]),  // Right side
    (matrix[n - 1][0], matrix[n - 1][n - 1]),  // Bottom side
  ]

  for (corner1, corner2) in sameSideCorners {
    if corner1 == .playedIncorrectly && corner2 == .playedIncorrectly {
      return true
    }
  }

  return false
}

/// Determines if there is any potential path between diagonally opposite corners
/// - Parameter matrix: The game board represented as a 2D array of `GameCellState`
/// - Returns: `true` if a potential path exists, otherwise `false`
func hasPotentialPath(in matrix: [[GameCellState]]) -> Bool {
  let n = matrix.count
  guard n > 1 else { return false }

  let directions = [
    (0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1),
  ]
  let startPoints = [
    (Coordinate(row: 0, col: 0), Coordinate(row: n - 1, col: n - 1)),
    (Coordinate(row: 0, col: n - 1), Coordinate(row: n - 1, col: 0)),
  ]

  /// Depth-first search to check if a path exists
  func dfs(
    position: Coordinate, end: Coordinate, visited: inout Set<Coordinate>
  ) -> Bool {
    if position == end && matrix[position.row][position.col] == .playedCorrectly
    {
      return true
    }

    if visited.contains(position)
      || matrix[position.row][position.col] == .blocked
      || matrix[position.row][position.col] != .playedCorrectly
    {
      return false
    }

    visited.insert(position)

    for direction in directions {
      let newPosition = Coordinate(
        row: position.row + direction.0, col: position.col + direction.1)
      if newPosition.row >= 0, newPosition.row < n, newPosition.col >= 0,
        newPosition.col < n
      {
        if dfs(position: newPosition, end: end, visited: &visited) {
          return true
        }
      }
    }

    return false
  }

  for (start, end) in startPoints {
    var visited = Set<Coordinate>()
    if dfs(position: start, end: end, visited: &visited) {
      return true
    }
  }

  return false
}

/// Finds the actual winning path (if any) in the matrix
/// - Parameter matrix: The game board represented as a 2D array of `GameCellState`
/// - Returns: A tuple containing the winning path as a list of positions and a boolean indicating if a winning path exists
func winningPath(in matrix: [[GameCellState]]) -> ([Coordinate], Bool) {
  let n = matrix.count
  guard n > 0 else { return ([], false) }

  let startPoints = [
    Coordinate(row: 0, col: 0), Coordinate(row: 0, col: n - 1),
  ]
  let endPoints = [
    Coordinate(row: n - 1, col: n - 1), Coordinate(row: n - 1, col: 0),
  ]
  let directions = [
    (0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1),
  ]

  /// Breadth-first search to find the path
  func bfs(start: Coordinate, end: Coordinate) -> ([Coordinate], Bool) {
    var queue: [(Coordinate, [Coordinate])] = [(start, [start])]
    var visited = Set<Coordinate>()
    visited.insert(start)

    while !queue.isEmpty {
      let (current, path) = queue.removeFirst()

      if current == end && matrix[current.row][current.col] == .playedCorrectly
      {
        return (path, true)
      }

      for direction in directions {
        let newPosition = Coordinate(
          row: current.row + direction.0, col: current.col + direction.1)
        if newPosition.row >= 0, newPosition.row < n, newPosition.col >= 0,
          newPosition.col < n,
          !visited.contains(newPosition),
          matrix[newPosition.row][newPosition.col] == .playedCorrectly
        {

          visited.insert(newPosition)
          queue.append((newPosition, path + [newPosition]))
        }
      }
    }

    return ([], false)
  }

  for i in 0..<startPoints.count {
    let (path, found) = bfs(start: startPoints[i], end: endPoints[i])
    if found {
      return (path, true)
    }
  }

  return ([], false)
}

/// Checks if a specific cell has adjacent neighbors in specified states
/// - Parameters:
///   - states: A set of cell states to check for
///   - matrix: The game board represented as a 2D array of `GameCellState`
///   - cell: The position of the cell to check
/// - Returns: `true` if there is an adjacent neighbor in one of the specified states, otherwise `false`
func hasAdjacentNeighbor(
  withStates states: Set<GameCellState>, in matrix: [[GameCellState]],
  for cell: Coordinate
) -> Bool {
  let n = matrix.count
  let directions = [
    (0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1),
  ]

  for direction in directions {
    let newRow = cell.row + direction.0
    let newCol = cell.col + direction.1
    if newRow >= 0, newRow < n, newCol >= 0, newCol < n {
      if states.contains(matrix[newRow][newCol])
        && matrix[newRow][newCol] != .blocked
      {
        return true
      }
    }
  }

  return false
}

/// Counts the number of possible moves in the matrix
/// - Parameter matrix: The game board represented as a 2D array of `GameCellState`
/// - Returns: The number of possible moves
func numberOfPossibleMoves(in matrix: [[GameCellState]]) -> Int {
  let n = matrix.count
  guard n > 0 else { return 0 }

  let directions = [
    (0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1),
  ]
  var possibleMoves = 0

  for row in 0..<n {
    for col in 0..<n where matrix[row][col] == .unplayed {
      for direction in directions {
        let newRow = row + direction.0
        let newCol = col + direction.1
        if newRow >= 0, newRow < n, newCol >= 0, newCol < n,
          matrix[newRow][newCol] == .playedCorrectly
        {
          possibleMoves += 1
          break
        }
      }
    }
  }

  return possibleMoves
}


/// Generates a random game board matrix with only `unplayed` and `blocked` cells,
/// ensuring the corner cells are never blocked and have at least one adjacent `unplayed` cell.
/// - Parameters:
///   - size: The size of the square matrix (e.g., 4 for a 4x4 matrix).
///   - blockedPercentage: The percentage (0-100) of cells that should be `blocked`.
/// - Returns: A 2D array of `GameCellState`.
func generateRandomMatrix(size: Int, blockedPercentage: Int) -> [[GameCellState]] {
    guard size > 0 else { return [] }
    guard blockedPercentage >= 0 && blockedPercentage <= 100 else {
        fatalError("blockedPercentage must be between 0 and 100.")
    }

    let totalCells = size * size
    let cornerIndices = [
        0,                       // Top-left corner
        size - 1,                // Top-right corner
        totalCells - size,       // Bottom-left corner
        totalCells - 1           // Bottom-right corner
    ]

    // Calculate the exact number of blocked cells
    let blockedCellsTarget = Int(round(Double(totalCells * blockedPercentage) / 100.0))

    // Initialize a flat matrix with all cells as unplayed
    var flatMatrix: [GameCellState] = Array(repeating: .unplayed, count: totalCells)

    // Ensure corners are explicitly unplayed
    for corner in cornerIndices {
        flatMatrix[corner] = .unplayed
    }

    // Add blocked cells, excluding corners
    var blockedIndices = Set<Int>()
    while blockedIndices.count < blockedCellsTarget {
        let randomIndex = Int.random(in: 0..<totalCells)
        if !cornerIndices.contains(randomIndex) && !blockedIndices.contains(randomIndex) {
            blockedIndices.insert(randomIndex)
        }
    }

    // Apply blocked indices to the flat matrix
    for index in blockedIndices {
        flatMatrix[index] = .blocked
    }

    // Convert the flat matrix back into a 2D array
    var matrix: [[GameCellState]] = []
    for row in 0..<size {
        let start = row * size
        let end = start + size
        matrix.append(Array(flatMatrix[start..<end]))
    }

    // Ensure each corner has at least one adjacent unplayed cell
    //ensureAdjacentUnplayedCells(forCorners: cornerIndices, in: &flatMatrix, size: size)

    return matrix
}
/// Ensures that each corner cell has at least one adjacent `unplayed` cell.
/// - Parameters:
///   - corners: Indices of corner cells.
///   - flatMatrix: The flat matrix array of `GameCellState`.
///   - size: The size of the square matrix.
private func ensureAdjacentUnplayedCells(forCorners corners: [Int], in flatMatrix: inout [GameCellState], size: Int) {
    let totalCells = size * size

    for corner in corners {
        // Determine the adjacent cells based on the corner's position
        let adjacentIndices: [Int] = {
            switch corner {
            case 0: // Top-left corner
                return [1, size]
            case size - 1: // Top-right corner
                return [size - 2, 2 * size - 1]
            case totalCells - size: // Bottom-left corner
                return [totalCells - 2 * size, totalCells - size + 1]
            case totalCells - 1: // Bottom-right corner
                return [totalCells - size - 1, totalCells - 2]
            default:
                return []
            }
        }()

        // Ensure at least one adjacent cell is unplayed
        if !adjacentIndices.contains(where: { flatMatrix[$0] == .unplayed }) {
            // If all adjacent cells are blocked, unblock one randomly
            if let randomBlockedIndex = adjacentIndices.first(where: { flatMatrix[$0] == .blocked }) {
                flatMatrix[randomBlockedIndex] = .unplayed
            }
        }
    }
}
