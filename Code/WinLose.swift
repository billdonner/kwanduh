import SwiftUI

// Represents the state of a game cell
enum GameCellState: Codable {
    case playedCorrectly
    case playedIncorrectly
    case unplayed
    case blocked

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

// Checks if there's a valid winning path in the matrix
func isWinningPath(in matrix: [[GameCellState]]) -> Bool {
    if hasLosingCornerCondition(in: matrix) || !hasPotentialPath(in: matrix, validStates: [.playedCorrectly]) {
        return false
    }
    let (_, pathExists) = winningPath(in: matrix)
    return pathExists
}

// Checks if a theoretical winning path is possible
func isPossibleWinningPath(in matrix: [[GameCellState]]) -> Bool {
    // Check corner loss condition
    if hasLosingCornerCondition(in: matrix) {
        return false
    }

    // Check for a potential path including unplayed cells
    return hasPotentialPath(in: matrix, validStates: [.playedCorrectly, .unplayed])
}
// Checks if any pair of corners creates a losing condition
func hasLosingCornerCondition(in matrix: [[GameCellState]]) -> Bool {
    let n = matrix.count
    guard n > 1 else { return false }

    let cornerPairs = [
        ((0, 0), (0, n - 1)),
        ((n - 1, 0), (n - 1, n - 1)),
        ((0, 0), (n - 1, 0)),
        ((0, n - 1), (n - 1, n - 1))
    ]

    for (corner1, corner2) in cornerPairs {
        if matrix[corner1.0][corner1.1] == .playedIncorrectly &&
           matrix[corner2.0][corner2.1] == .playedIncorrectly {
            return true
        }
    }

    return false
}

// Determines if a potential path exists between corners
func hasPotentialPath(in matrix: [[GameCellState]], validStates: Set<GameCellState>) -> Bool {
    let n = matrix.count
    guard n > 1 else { return false }

    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]
    let startPoints = [
        (0, 0, n - 1, n - 1), // Top-left to bottom-right
        (0, n - 1, n - 1, 0)  // Top-right to bottom-left
    ]

    func dfs(_ row: Int, _ col: Int, _ endRow: Int, _ endCol: Int, _ visited: inout Set<String>) -> Bool {
        // Check if we've reached the endpoint
        if (row, col) == (endRow, endCol) && validStates.contains(matrix[row][col]) {
            return true
        }

        // Exclude visited or invalid cells
        let key = "\(row),\(col)"
        if visited.contains(key) || !validStates.contains(matrix[row][col]) {
            return false
        }

        visited.insert(key)

        // Explore neighbors
        for direction in directions {
            let newRow = row + direction.0
            let newCol = col + direction.1
            if newRow >= 0, newRow < n, newCol >= 0, newCol < n {
                if dfs(newRow, newCol, endRow, endCol, &visited) {
                    return true
                }
            }
        }

        return false
    }

    // Check both diagonal paths
    for (startRow, startCol, endRow, endCol) in startPoints {
        var visited = Set<String>()
        if dfs(startRow, startCol, endRow, endCol, &visited) {
            return true
        }
    }

    return false
}
// Finds the actual winning path (if any) in the matrix
func winningPath(in matrix: [[GameCellState]]) -> ([(Int, Int)], Bool) {
    let n = matrix.count
    guard n > 0 else { return ([], false) }

    let startPoints = [(0, 0), (0, n - 1)]
    let endPoints = [(n - 1, n - 1), (n - 1, 0)]
    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]

    func bfs(startRow: Int, startCol: Int, endRow: Int, endCol: Int) -> ([(Int, Int)], Bool) {
        var queue = [(startRow, startCol, [(startRow, startCol)])]
        var visited = Set<String>()
        visited.insert("\(startRow),\(startCol)")

        while !queue.isEmpty {
            let (row, col, path) = queue.removeFirst()

            if (row, col) == (endRow, endCol) && matrix[row][col] == .playedCorrectly {
                return (path, true)
            }

            for direction in directions {
                let newRow = row + direction.0
                let newCol = col + direction.1
                let newKey = "\(newRow),\(newCol)"

                if newRow >= 0, newRow < n, newCol >= 0, newCol < n,
                   !visited.contains(newKey),
                   matrix[newRow][newCol] == .playedCorrectly {
                    
                    visited.insert(newKey)
                    queue.append((newRow, newCol, path + [(newRow, newCol)]))
                }
            }
        }

        return ([], false)
    }

    for i in 0..<startPoints.count {
        let (startRow, startCol) = startPoints[i]
        let (endRow, endCol) = endPoints[i]
        let (path, found) = bfs(startRow: startRow, startCol: startCol, endRow: endRow, endCol: endCol)
        if found {
            return (path, true)
        }
    }

    return ([], false)
}

// Helper to check for adjacent neighbors
func hasAdjacentNeighbor(withStates states: Set<GameCellState>, in matrix: [[GameCellState]], for cell: (Int, Int)) -> Bool {
    let n = matrix.count
    let (row, col) = cell

    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]

    for direction in directions {
        let newRow = row + direction.0
        let newCol = col + direction.1
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
