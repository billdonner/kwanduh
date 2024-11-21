//
// This file is maintained in the mac app Winner, which has about 100 test cases for this vital code
// v 0.94

import Foundation

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

/// Determines if there is a valid winning path in the matrix
/// - Parameter matrix: The game board represented as a 2D array of `GameCellState`
/// - Returns: `true` if a winning path exists, otherwise `false`
func isWinningPath(in matrix: [[GameCellState]]) -> Bool {
  // Check if losing conditions are met
  if hasLosingCornerCondition(in: matrix) {
    return false
  }
  // Determine if there is a valid path
  let (_, pathExists) = winningPath(in: matrix)
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
