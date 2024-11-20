// copied in from winlose.com

import SwiftUI

// Represents the state of a game cell
enum GameCellState: Codable {
    case playedCorrectly
    case playedIncorrectly
    case unplayed
    case blocked


}

// Represents a position in the matrix
struct Position: Hashable {
    let row: Int
    let col: Int
}

// Checks if there's a valid winning path in the matrix
func isWinningPath(in matrix: [[GameCellState]]) -> Bool {
    if hasLosingCornerCondition(in: matrix) || !hasPotentialPath(in: matrix) {
        return false
    }
    let (_, pathExists) = winningPath(in: matrix)
    return pathExists
}

// Checks if a theoretical winning path is possible
func isPossibleWinningPath(in matrix: [[GameCellState]]) -> Bool {
    let size = matrix.count
    guard size > 0 else { return false }

    // Helper to validate path continuity
    func traverse(position: Position, visited: inout Set<Position>) -> Bool {
        // Check bounds
        guard position.row >= 0, position.row < size, position.col >= 0, position.col < size else {
            return false
        }

        // Check cell state
        if matrix[position.row][position.col] == .blocked || visited.contains(position) {
            return false
        }

        // Mark cell as visited
        visited.insert(position)

        // If we reach the bottom-right corner, a path exists
        if position.row == size - 1 && position.col == size - 1 {
            return true
        }

        // Explore neighbors: right, down, left, up
        return traverse(position: Position(row: position.row, col: position.col + 1), visited: &visited) ||
               traverse(position: Position(row: position.row + 1, col: position.col), visited: &visited) ||
               traverse(position: Position(row: position.row, col: position.col - 1), visited: &visited) ||
               traverse(position: Position(row: position.row - 1, col: position.col), visited: &visited)
    }

    // Start traversal from the top-left corner
    var visited: Set<Position> = []
    return traverse(position: Position(row: 0, col: 0), visited: &visited)
}

// Checks if any pair of corners creates a losing condition
func hasLosingCornerCondition(in matrix: [[GameCellState]]) -> Bool {
    let n = matrix.count
    guard n > 1 else { return false }

    let cornerPairs = [
        (Position(row: 0, col: 0), Position(row: 0, col: n - 1)),
        (Position(row: n - 1, col: 0), Position(row: n - 1, col: n - 1)),
        (Position(row: 0, col: 0), Position(row: n - 1, col: 0)),
        (Position(row: 0, col: n - 1), Position(row: n - 1, col: n - 1))
    ]

    for (corner1, corner2) in cornerPairs {
        if matrix[corner1.row][corner1.col] == .playedIncorrectly &&
           matrix[corner2.row][corner2.col] == .playedIncorrectly {
            return true
        }
    }

    return false
}

// Determines if a potential path exists between corners
func hasPotentialPath(in matrix: [[GameCellState]]) -> Bool {
    let n = matrix.count
    guard n > 1 else { return false }

    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]
    let startPoints = [
        (Position(row: 0, col: 0), Position(row: n - 1, col: n - 1)),
        (Position(row: 0, col: n - 1), Position(row: n - 1, col: 0))
    ]

    func dfs(position: Position, end: Position, visited: inout Set<Position>) -> Bool {
        if position == end && matrix[position.row][position.col] == .playedCorrectly {
            return true
        }

        if visited.contains(position) || matrix[position.row][position.col] == .blocked || matrix[position.row][position.col] != .playedCorrectly {
            return false
        }

        visited.insert(position)

        for direction in directions {
            let newPosition = Position(row: position.row + direction.0, col: position.col + direction.1)
            if newPosition.row >= 0, newPosition.row < n, newPosition.col >= 0, newPosition.col < n {
                if dfs(position: newPosition, end: end, visited: &visited) {
                    return true
                }
            }
        }

        return false
    }

    for (start, end) in startPoints {
        var visited = Set<Position>()
        if dfs(position: start, end: end, visited: &visited) {
            return true
        }
    }

    return false
}

// Finds the actual winning path (if any) in the matrix
func winningPath(in matrix: [[GameCellState]]) -> ([Position], Bool) {
    let n = matrix.count
    guard n > 0 else { return ([], false) }

    let startPoints = [Position(row: 0, col: 0), Position(row: 0, col: n - 1)]
    let endPoints = [Position(row: n - 1, col: n - 1), Position(row: n - 1, col: 0)]
    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]

    func bfs(start: Position, end: Position) -> ([Position], Bool) {
        var queue: [(Position, [Position])] = [(start, [start])]
        var visited = Set<Position>()
        visited.insert(start)

        while !queue.isEmpty {
            let (current, path) = queue.removeFirst()

            if current == end && matrix[current.row][current.col] == .playedCorrectly {
                return (path, true)
            }

            for direction in directions {
                let newPosition = Position(row: current.row + direction.0, col: current.col + direction.1)
                if newPosition.row >= 0, newPosition.row < n, newPosition.col >= 0, newPosition.col < n,
                   !visited.contains(newPosition),
                   matrix[newPosition.row][newPosition.col] == .playedCorrectly {
                    
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

// Helper to check for adjacent neighbors
func hasAdjacentNeighbor(withStates states: Set<GameCellState>, in matrix: [[GameCellState]], for cell: Position) -> Bool {
    let n = matrix.count

    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]

    for direction in directions {
        let newRow = cell.row + direction.0
        let newCol = cell.col + direction.1
        if newRow >= 0, newRow < n, newCol >= 0, newCol < n {
            if states.contains(matrix[newRow][newCol]) && matrix[newRow][newCol] != .blocked {
                return true
            }
        }
    }

    return false
}

// Counts the number of possible moves in the matrix
func numberOfPossibleMoves(in matrix: [[GameCellState]]) -> Int {
    let n = matrix.count
    guard n > 0 else { return 0 }

    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]
    var possibleMoves = 0

    for row in 0..<n {
        for col in 0..<n where matrix[row][col] == .unplayed {
            for direction in directions {
                let newRow = row + direction.0
                let newCol = col + direction.1
                if newRow >= 0, newRow < n, newCol >= 0, newCol < n,
                   matrix[newRow][newCol] == .playedCorrectly {
                    possibleMoves += 1
                    break
                }
            }
        }
    }

    return possibleMoves
}
