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

    let startPoints = [
        (0, 0, n - 1, n - 1),
        (0, n - 1, n - 1, 0)
    ]

    func dfs(_ row: Int, _ col: Int, _ endRow: Int, _ endCol: Int, _ visited: inout Set<String>) -> Bool {
        if (row, col) == (endRow, endCol) && matrix[row][col] != .blocked && matrix[row][col] != .playedIncorrectly {
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

    for (startRow, startCol, endRow, endCol) in startPoints {
        var visited = Set<String>()
        if dfs(startRow, startCol, endRow, endCol, &visited) {
            return true
        }
    }
    
    return false
}
func hasAdjacentNeighbor(withStates states: Set<GameCellState>, in matrix: [[GameCellState]], for cell: (Int, Int)) -> Bool {
    let n = matrix.count
    let (row, col) = cell

    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]

    for direction in directions {
        let newRow = row + direction.0
        let newCol = col + direction.1
        if newRow >= 0 && newRow < n && newCol >= 0 && newCol < n {
            if states.contains(matrix[newRow][newCol]) && matrix[newRow][newCol] != .blocked {
                return true
            }
        }
    }
    return false
}
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
                    break  // Count this unplayed cell only once
                }
            }
        }
    }
    return possibleMoves
}
func winningPath(in matrix: [[GameCellState]]) -> ([(Int, Int)], Bool) {
    let n = matrix.count
    guard n > 0 else { return ([], false) }

    // Define both diagonals' start and end points
    let startPoints = [(0, 0), (0, n - 1)]
    let endPoints = [(n - 1, n - 1), (n - 1, 0)]

    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]

    func bfs(startRow: Int, startCol: Int, endRow: Int, endCol: Int) -> ([(Int, Int)], Bool) {
        var queue = [(startRow, startCol, [(startRow, startCol)])]
        var visited = Set<String>()
        visited.insert("\(startRow),\(startCol)")

        while !queue.isEmpty {
            let (row, col, path) = queue.removeFirst()

            // Debug output to help trace the pathfinding process
          //  print("Visiting cell: (\(row), \(col)) - Path length: \(path.count)")

            // Check if we've reached the end
            if (row, col) == (endRow, endCol) && matrix[row][col] == .playedCorrectly {
               // print("Found winning path: \(path)")
                return (path, true)
            }

            // Explore neighbors
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

    // Check each diagonal independently
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
func aaawinningPath(in matrix: [[GameCellState]]) -> ([(Int, Int)], Bool) {
    let n = matrix.count
    guard n > 0 else { return ([], false) }

    // Define start and end points for both diagonals
    let startPoints = [(0, 0), (0, n - 1)]
    let endPoints = [(n - 1, n - 1), (n - 1, 0)]

    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]

    func bfs(startRow: Int, startCol: Int, endRow: Int, endCol: Int) -> ([(Int, Int)], Bool) {
        var queue = [(startRow, startCol, [(startRow, startCol)])]
        var visited = Set<String>()
        visited.insert("\(startRow),\(startCol)")

        while !queue.isEmpty {
            let (row, col, path) = queue.removeFirst()

            // Check if we've reached the end
            if (row, col) == (endRow, endCol) && matrix[row][col] == .playedCorrectly {
                return (path, true)
            }

            // Explore neighbors
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

    // Check each diagonal independently
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
func xxxwinningPath(in matrix: [[GameCellState]]) -> ([(Int, Int)], Bool) {
    let n = matrix.count
    guard n > 0 else { return ([], false) }

    // Define both diagonals' start and end points
    let startPoints = [(0, 0), (0, n - 1)]
    let endPoints = [(n - 1, n - 1), (n - 1, 0)]

    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]

    func bfs(startRow: Int, startCol: Int, endRow: Int, endCol: Int) -> ([(Int, Int)], Bool) {
        var queue = [(startRow, startCol, [(startRow, startCol)])]  // (current position, path to that position)
        var visited = Set<String>()
        visited.insert("\(startRow),\(startCol)")

        while !queue.isEmpty {
            let (row, col, path) = queue.removeFirst()
            
            // Check if we've reached the end
            if (row, col) == (endRow, endCol) && matrix[row][col] == .playedCorrectly {
                return (path, true)
            }

            // Explore neighbors
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

    // Check both diagonals independently
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
func OLDwinningPath(in matrix: [[GameCellState]]) -> ([(Int, Int)], Bool) {
    let n = matrix.count
    guard n > 0 else { return ([], false) }

    // Define both diagonals' start and end points
    let startPoints = [(0, 0), (0, n - 1)]
    let endPoints = [(n - 1, n - 1), (n - 1, 0)]

    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]

    func bfs(startRow: Int, startCol: Int, endRow: Int, endCol: Int) -> ([(Int, Int)], Bool) {
        var queue = [(startRow, startCol, [(startRow, startCol)])]  // (current position, path to that position)
        var visited = Set<String>()
        visited.insert("\(startRow),\(startCol)")

        while !queue.isEmpty {
            let (row, col, path) = queue.removeFirst()
            
            // Check if we've reached the end
            if (row, col) == (endRow, endCol) && matrix[row][col] == .playedCorrectly {
                return (path, true)
            }

            // Explore neighbors
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

    // Check both diagonals independently
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
func DfSwinningPath(in matrix: [[GameCellState]]) -> ([(Int, Int)], Bool) {
    let n = matrix.count
    guard n > 0 else { return ([], false) }

    // Define both diagonals' start and end points
    let startPoints = [(0, 0), (0, n - 1)]
    let endPoints = [(n - 1, n - 1), (n - 1, 0)]
    
    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]

    func dfs(_ row: Int, _ col: Int, _ endRow: Int, _ endCol: Int, _ visited: inout Set<String>, _ path: inout [(Int, Int)]) -> Bool {
        if (row, col) == (endRow, endCol) && matrix[row][col] == .playedCorrectly {
            path.append((row, col))
            return true
        }

        let key = "\(row),\(col)"
        if visited.contains(key) || matrix[row][col] == .blocked || matrix[row][col] != .playedCorrectly {
            return false
        }

        visited.insert(key)
        path.append((row, col))

        for direction in directions {
            let newRow = row + direction.0
            let newCol = col + direction.1
            if newRow >= 0, newRow < n, newCol >= 0, newCol < n {
                if dfs(newRow, newCol, endRow, endCol, &visited, &path) {
                    return true
                }
            }
        }

        path.removeLast()
        return false
    }

    // Check each diagonal path individually
    for i in 0..<startPoints.count {
        let (startRow, startCol) = startPoints[i]
        let (endRow, endCol) = endPoints[i]
        var visited = Set<String>()
        var path: [(Int, Int)] = []
        
        if dfs(startRow, startCol, endRow, endCol, &visited, &path) {
            return (path, true)
        }
    }
    
    return ([], false)
}
