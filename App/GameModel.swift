import SwiftUI

final class GameModel: ObservableObject {
    @Published var board: [[Int]]
    @Published var score: Int = 0

    init() {
        board = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        spawnTile()
        spawnTile()
    }

    func reset() {
        board = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        score = 0
        spawnTile()
        spawnTile()
    }

    func handleSwipe(delta: CGSize) {
        let absX = abs(delta.width)
        let absY = abs(delta.height)
        if max(absX, absY) < 15 { return }
        if absX > absY {
            if delta.width > 0 { move(.right) } else { move(.left) }
        } else {
            if delta.height > 0 { move(.down) } else { move(.up) }
        }
    }

    enum Direction { case up, down, left, right }

    func move(_ direction: Direction) {
        var moved = false
        switch direction {
        case .left:
            for row in 0..<4 {
                let (line, didMove) = collapse(board[row])
                board[row] = line
                moved = moved || didMove
            }
        case .right:
            for row in 0..<4 {
                let reversed = Array(board[row].reversed())
                let (line, didMove) = collapse(reversed)
                board[row] = Array(line.reversed())
                moved = moved || didMove
            }
        case .up:
            for col in 0..<4 {
                var column = (0..<4).map { board[$0][col] }
                let (line, didMove) = collapse(column)
                for i in 0..<4 { board[i][col] = line[i] }
                moved = moved || didMove
            }
        case .down:
            for col in 0..<4 {
            let column = (0..<4).map { board[$0][col] }.reversed()
            let (line, didMove) = collapse(Array(column))
            for (i, v) in line.enumerated() { board[3 - i][col] = v }
                moved = moved || didMove
            }
        }
        if moved {
            spawnTile()
        }
    }

    private func collapse(_ line: [Int]) -> ([Int], Bool) {
        let filtered = line.filter { $0 != 0 }
        var newLine = filtered
        var moved = filtered.count != line.count
        var i = 0
        while i < newLine.count - 1 {
            if newLine[i] == newLine[i + 1] {
                newLine[i] *= 2
                score += newLine[i]
                newLine.remove(at: i + 1)
                moved = true
            }
            i += 1
        }
        while newLine.count < 4 { newLine.append(0) }
        return (newLine, moved)
    }

    private func spawnTile() {
        var empty: [(Int, Int)] = []
        for r in 0..<4 {
            for c in 0..<4 {
                if board[r][c] == 0 { empty.append((r, c)) }
            }
        }
        guard let spot = empty.randomElement() else { return }
        board[spot.0][spot.1] = Bool.random() ? 2 : 4
    }
}
