import SwiftUI

enum GameCellState: Codable {
    case playedCorrectly
    case playedIncorrectly
    case unplayed
    case blocked  // New state added

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

func isWinningPath(in matrix: [[GameCellState]]) -> Bool {
    // Check for immediate loss conditions
    if hasLosingCornerCondition(in: matrix) || !hasPotentialPath(in: matrix) {
        return false
    }
    
    // Proceed to find an actual winning path from one corner to the opposite
    let (_, pathExists) = winningPath(in: matrix)
    return pathExists
}

func isPossibleWinningPath(in matrix: [[GameCellState]]) -> Bool {
    // Check for immediate loss conditions
    if hasLosingCornerCondition(in: matrix) || !hasPotentialPath(in: matrix) {
        return false
    }
    
    // Check if there’s any theoretical path between opposite corners
    return true
}

func hasLosingCornerCondition(in matrix: [[GameCellState]]) -> Bool {
    let n = matrix.count
    guard n > 1 else { return false }

    // Check pairs of corners for incorrect answers on the same side
    let cornerPairs = [
        ((0, 0), (0, n - 1)), // Top side
        ((n - 1, 0), (n - 1, n - 1)), // Bottom side
        ((0, 0), (n - 1, 0)), // Left side
        ((0, n - 1), (n - 1, n - 1)) // Right side
    ]
    
    for (corner1, corner2) in cornerPairs {
        if matrix[corner1.0][corner1.1] == .playedIncorrectly && matrix[corner2.0][corner2.1] == .playedIncorrectly {
            return true
        }
    }
    
    return false
}

func hasPotentialPath(in matrix: [[GameCellState]]) -> Bool {
    let n = matrix.count
    guard n > 1 else { return false }

    // Define possible pairs of opposite corners that need a potential path
    let startPoints = [
        (0, 0, n - 1, n - 1),  // Diagonal 1: Top-left to Bottom-right
        (0, n - 1, n - 1, 0)   // Diagonal 2: Top-right to Bottom-left
    ]

    func dfs(_ row: Int, _ col: Int, _ endRow: Int, _ endCol: Int, _ visited: inout Set<String>) -> Bool {
        if (row, col) == (endRow, endCol), matrix[row][col] != .blocked, matrix[row][col] != .playedIncorrectly {
            return true
        }

        let key = "\(row),\(col)"
        if visited.contains(key) || matrix[row][col] == .blocked || matrix[row][col] == .playedIncorrectly {
            return false
        }
        
        visited.insert(key)

        let directions = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]
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

    // Check each pair of opposite corners for a potential path
    for (startRow, startCol, endRow, endCol) in startPoints {
        var visited = Set<String>()
        if dfs(startRow, startCol, endRow, endCol, &visited) {
            return true
        }
    }
    
    return false
}

func winningPath(in matrix: [[GameCellState]]) -> ([(Int, Int)], Bool) {
    let n = matrix.count
    guard n > 0 else { return ([], false) }

    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]
    let startPoints = [(0, 0), (0, n - 1)] // Only test from one corner on each diagonal

    func dfs(_ row: Int, _ col: Int, _ visited: inout Set<String>, _ path: inout [(Int, Int)], _ endRow: Int, _ endCol: Int) -> Bool {
        if (row, col) == (endRow, endCol) && matrix[row][col] == .playedCorrectly {
            path.append((row, col))
            return true
        }

        let key = "\(row),\(col)"
        if visited.contains(key) || matrix[row][col] != .playedCorrectly {
            return false
        }

        visited.insert(key)
        path.append((row, col))

        for direction in directions {
            let newRow = row + direction.0
            let newCol = col + direction.1
            if newRow >= 0, newRow < n, newCol >= 0, newCol < n, matrix[newRow][newCol] != .blocked {
                if dfs(newRow, newCol, &visited, &path, endRow, endCol) {
                    return true
                }
            }
        }

        path.removeLast()
        return false
    }

    for startPoint in startPoints {
        let endPoint = (n - 1 - startPoint.0, n - 1 - startPoint.1)
        var visited = Set<String>()
        var path: [(Int, Int)] = []
        if dfs(startPoint.0, startPoint.1, &visited, &path, endPoint.0, endPoint.1) {
            return (path, true)
        }
    }
    
    return ([], false)
}
func hasAdjacentNeighbor(withStates states: Set<GameCellState>, in matrix: [[GameCellState]], for cell: (Int, Int)) -> Bool {
    let n = matrix.count
    let (row, col) = cell

    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]

    for direction in directions {
        let newRow = row + direction.0
        let newCol = col + direction.1
        if newRow >= 0 && newRow < n && newCol >= 0 && newCol < n {
            // Check if the adjacent cell is in one of the desired states and is not blocked
            if states.contains(matrix[newRow][newCol]) && matrix[newRow][newCol] != .blocked {
                return true
            }
        }
    }
    return false
}
