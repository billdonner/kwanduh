
import SwiftUI

// MatrixView displays a grid of cells and corresponding labels
struct MatrixView: View {
    let matrix: [[Move?]]
    let topLabel: String?
    let bottomLabel: String?
    let correctColor: Color
    let incorrectColor: Color
    @Binding var isPresented: Bool

    var body: some View {
        let rows = matrix.count
        let cols = matrix.first?.count ?? 0
        ZStack {
            WrappedDismissButton(isPresented: $isPresented)
            VStack {
                if let topLabel = topLabel {
                    Text("\(topLabel)")
                        .font(.title)
                        .padding(.horizontal)
                }

                VStack(spacing: 0) {
                    ForEach(0..<rows, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<cols, id: \.self) { column in
                                MatrixCellView(move: matrix[row][column], correctColor: correctColor, incorrectColor: incorrectColor)
                            }
                        }
                    }
                }
                .padding()

                if let bottomLabel = bottomLabel {
                    Text("\(bottomLabel)")
                        .font(.body)
                        .padding(.horizontal)
                }
            }
        }
    }
}

// Move model with optional text property and useSymbol flag
struct Move {
    internal init(_ outcome: Outcome, text: String? = nil, useSymbol: Bool = true) {
        self.outcome = outcome
        self.text = text ?? ""
        self.useSymbol = useSymbol
    }
    let outcome: Outcome
    let text: String
    let useSymbol: Bool
}

// CellView representing each cell in the grid with custom display logic
struct MatrixCellView: View {
    var move: Move?
    let correctColor: Color
    let incorrectColor: Color
    var body: some View {
        Group {
            if let move = move {
                if move.useSymbol {
                    Image(systemName: move.text)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                } else {
                    Text(move.text)
                }
            } else {
                Text("")
            }
        }
        .frame(width: 64, height: 64)
        .background(Color.black)
        .foregroundColor(.white)
        .border(move?.outcome == .correct ? correctColor : (move?.outcome == .incorrect ? incorrectColor : .blue), width: move != nil ? 3 : 1)
    }
}

// Enum for defining outcomes
enum Outcome {
    case correct
    case incorrect
}

// Data structure to hold position and corresponding move
struct PDM {
    let position: (row: Int, col: Int)
    let move: Move

    init(row: Int, col: Int, outcome: Outcome, text: String, useSymbol: Bool = true) {
        self.position = (row, col)
        self.move = Move(outcome, text: text, useSymbol: useSymbol)
    }
}

// Function to create matrix from predefined moves
func PDMatrix(rows: Int, cols: Int, pdms: [PDM], title: String? = "") -> [[Move?]] {
    var matrix: [[Move?]] = Array(repeating: Array(repeating: nil, count: cols), count: rows)
    for predefinedMove in pdms {
        let position = predefinedMove.position
        if position.row < rows && position.col < cols {
            matrix[position.row][position.col] = predefinedMove.move
        }
    }
    return matrix
}

func mkID() -> String {
    return UUID().uuidString
}

struct DismissButton: View {
    @Binding var isPresented: Bool
    var body: some View {
        Button(action: {
            isPresented = false
        }) {
            Image(systemName: "x.circle")
                .font(.title)
                .foregroundColor(.primary)
        }
    }
}

struct WrappedDismissButton: View {
    @Binding var isPresented: Bool
    var body: some View {
        VStack {
            HStack { Spacer(); DismissButton(isPresented: $isPresented).padding(.horizontal) }
            Spacer()
        }
    }
}

// Additional UI Components
struct HowToPlayScreen: View {
    let chmgr: ChaMan
    @Binding var isPresented: Bool
    var body: some View {
      TabView {
        FrontMatter(isPresented: $isPresented).tag(mkID())
        startInAnyCorner(isPresented: $isPresented).tag(mkID())
        move0(isPresented: $isPresented).tag(mkID())
        move00(isPresented: $isPresented).tag(mkID())
        nonAdjecntMove(isPresented: $isPresented).tag(mkID())
        move1(isPresented: $isPresented).tag(mkID())
        move2(isPresented: $isPresented).tag(mkID())
        interiorAdjacency(isPresented: $isPresented).tag(mkID())
        borderAdjacency(isPresented: $isPresented).tag(mkID())
        cornerAdjacency(isPresented: $isPresented).tag(mkID())
        //Intermission().tag(mkID())
        shortPathToSuccess(isPresented: $isPresented).tag(mkID())
        shortPathToFailure(isPresented: $isPresented).tag(mkID())
        longPathToSuccess(isPresented: $isPresented).tag(mkID())
        notA3x3Winner(isPresented: $isPresented).tag(mkID())
        longPathToFailure(isPresented: $isPresented).tag(mkID())
        allFilledButWinningPath(isPresented: $isPresented).tag(mkID())
        bottomsUp(isPresented: $isPresented).tag(mkID())
        niceWinner(isPresented: $isPresented).tag(mkID())
      }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct FrontMatter: View {
    @Binding var isPresented: Bool
    var body: some View {
        ZStack {
            Color.black
            VStack {
                VStack {
                    Button(action: { isPresented = false }) {
                        HStack { Spacer(); Image(systemName: "x.circle").font(.title).foregroundStyle(.white) }
                    }
                    .padding()
                }
                Spacer()
                Text("How to Play").font(.largeTitle).foregroundStyle(.white)
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

// Helper function for symbolic representations
func ntoSF(_ number: Int) -> String { "\(number).circle" }


///
///
 func notA3x3Winner(isPresented: Binding<Bool>) -> MatrixView {
return MatrixView(matrix: PDMatrix(rows: 3, cols: 3, pdms: [
    PDM(row: 0, col: 0, outcome: .correct, text: ntoSF(1)),
    PDM(row: 0, col: 1, outcome: .incorrect, text: ntoSF(6)),
    PDM(row: 0, col: 2, outcome: .correct, text: ntoSF(3)),
    PDM(row: 1, col: 1, outcome: .incorrect, text: ntoSF(2)),
    PDM(row: 1, col: 2, outcome: .correct, text: ntoSF(4)),
    PDM(row: 2, col: 1, outcome: .incorrect, text: ntoSF(7)),
    PDM(row: 2, col: 2, outcome: .correct, text: ntoSF(5)),
]), topLabel: "Tough Loss", bottomLabel: "Not a winner", correctColor: .green, incorrectColor: .red, isPresented: isPresented)
}

func cornerAdjacency(isPresented: Binding<Bool>) -> MatrixView {
return MatrixView(matrix: PDMatrix(rows: 3, cols: 3, pdms: [
    PDM(row: 0, col: 0, outcome: .incorrect, text: "1.circle"),
    PDM(row: 1, col: 1, outcome: .correct, text: "checkmark"),
    PDM(row: 1, col: 0, outcome: .correct, text: "checkmark"),
    PDM(row: 0, col: 1, outcome: .correct, text: "checkmark"),
]), topLabel: "Where's My Next Move?", bottomLabel: "The corner cells have only 3 adjacent cells", correctColor: .yellow, incorrectColor: .blue, isPresented: isPresented)
}

func interiorAdjacency(isPresented: Binding<Bool>) -> MatrixView {
return MatrixView(matrix: PDMatrix(rows: 3, cols: 3, pdms: [
    PDM(row: 1, col: 1, outcome: .incorrect, text: "1.circle"),
    PDM(row: 0, col: 0, outcome: .correct, text: "checkmark"),
    PDM(row: 0, col: 2, outcome: .correct, text: "checkmark"),
    PDM(row: 2, col: 0, outcome: .correct, text: "checkmark"),
    PDM(row: 1, col: 0, outcome: .correct, text: "checkmark"),
    PDM(row: 2, col: 2, outcome: .correct, text: "checkmark"),
    PDM(row: 1, col: 2, outcome: .correct, text: "checkmark"),
    PDM(row: 0, col: 1, outcome: .correct, text: "checkmark"),
    PDM(row: 2, col: 1, outcome: .correct, text: "checkmark"),
]), topLabel: "Where's My Next Move?", bottomLabel: "Each interior cell has up to 8 adjacent cells", correctColor: .yellow, incorrectColor: .blue, isPresented: isPresented)
}

func borderAdjacency(isPresented: Binding<Bool>) -> MatrixView {
return MatrixView(matrix: PDMatrix(rows: 3, cols: 3, pdms: [
    PDM(row: 1, col: 0, outcome: .incorrect, text: "1.circle"),
    PDM(row: 0, col: 0, outcome: .correct, text: "checkmark"),
    PDM(row: 1, col: 1, outcome: .correct, text: "checkmark"),
    PDM(row: 0, col: 1, outcome: .correct, text: "checkmark"),
    PDM(row: 2, col: 0, outcome: .correct, text: "checkmark"),
    PDM(row: 2, col: 1, outcome: .correct, text: "checkmark"),
]), topLabel: "Where's My Next Move?", bottomLabel: "The border cells have 5 adjacent cells", correctColor: .yellow, incorrectColor: .blue, isPresented: isPresented)
}

func allFilledButWinningPath(isPresented: Binding<Bool>) -> MatrixView {
return MatrixView(matrix: PDMatrix(rows: 4, cols: 4, pdms: [
    PDM(row: 0, col: 0, outcome: .incorrect, text: ntoSF(1)),
    PDM(row: 0, col: 1, outcome: .correct, text: ntoSF(2)),
    PDM(row: 0, col: 2, outcome: .incorrect, text: ntoSF(3)),
    PDM(row: 0, col: 3, outcome: .correct, text: ntoSF(4)),
    PDM(row: 1, col: 0, outcome: .correct, text: ntoSF(5)),
    PDM(row: 1, col: 1, outcome: .incorrect, text: ntoSF(6)),
    PDM(row: 1, col: 2, outcome: .correct, text: ntoSF(7)),
    PDM(row: 1, col: 3, outcome: .incorrect, text: ntoSF(8)),
    PDM(row: 2, col: 0, outcome: .correct, text: ntoSF(9)),
    PDM(row: 2, col: 1, outcome: .incorrect, text: ntoSF(10)),
    PDM(row: 2, col: 2, outcome: .correct, text: ntoSF(11)),
    PDM(row: 2, col: 3, outcome: .incorrect, text: ntoSF(12)),
    PDM(row: 3, col: 0, outcome: .correct, text: ntoSF(13)),
]), topLabel: "Almost All Filled But Success", bottomLabel: "4-7-2-5-9-13", correctColor: .green, incorrectColor: .red, isPresented: isPresented)
}

func longPathToSuccess(isPresented: Binding<Bool>) -> MatrixView {
return MatrixView(matrix: PDMatrix(rows: 3, cols: 3, pdms: [
    PDM(row: 0, col: 2, outcome: .correct, text: ntoSF(1)),
    PDM(row: 1, col: 1, outcome: .incorrect, text: ntoSF(2)),
    PDM(row: 1, col: 2, outcome: .correct, text: ntoSF(3)),
    PDM(row: 2, col: 2, outcome: .correct, text: ntoSF(4)),
    PDM(row: 2, col: 1, outcome: .correct, text: ntoSF(5)),
    PDM(row: 2, col: 0, outcome: .correct, text: ntoSF(6)),
]), topLabel: "Long Path to Success", bottomLabel: "Reached end successfully 1-3-4-5-6", correctColor: .green, incorrectColor: .red, isPresented: isPresented)
}

func shortPathToSuccess(isPresented: Binding<Bool>) -> MatrixView {
return MatrixView(matrix: PDMatrix(rows: 3, cols: 3, pdms: [
    PDM(row: 0, col: 2, outcome: .correct, text: ntoSF(1)),
    PDM(row: 1, col: 1, outcome: .correct, text: ntoSF(2)),
    PDM(row: 2, col: 0, outcome: .correct, text: ntoSF(3)),
]), topLabel: "Short Path to Success", bottomLabel: "Can't do better on 3x3 board", correctColor: .green, incorrectColor: .red, isPresented: isPresented)
}

func longPathToFailure(isPresented: Binding<Bool>) -> MatrixView {
return MatrixView(matrix: PDMatrix(rows: 3, cols: 3, pdms: [
    PDM(row: 0, col: 0, outcome: .correct, text: ntoSF(1)),
    PDM(row: 0, col: 1, outcome: .incorrect, text: ntoSF(2)),
    PDM(row: 0, col: 2, outcome: .correct, text: ntoSF(3)),
    PDM(row: 1, col: 2, outcome: .correct, text: ntoSF(4)),
    PDM(row: 2, col: 2, outcome: .incorrect, text: ntoSF(5)),
    PDM(row: 2, col: 1, outcome: .correct, text: ntoSF(6)),
    PDM(row: 2, col: 0, outcome: .incorrect, text: ntoSF(7)),
]), topLabel: "Long Path to Failure", bottomLabel: "There was hope until move 7 failed", correctColor: .green, incorrectColor: .red, isPresented: isPresented)
}

func shortPathToFailure(isPresented: Binding<Bool>) -> MatrixView {
return MatrixView(matrix: PDMatrix(rows: 3, cols: 3, pdms: [
    PDM(row: 0, col: 0, outcome: .incorrect, text: ntoSF(1)),
    PDM(row: 2, col: 0, outcome: .incorrect, text: ntoSF(2)),
]), topLabel: "Short Path to Failure", bottomLabel: "Can't Ever Get Either Diagonal", correctColor: .green, incorrectColor: .red, isPresented: isPresented)
}

func sixBySixExample1(isPresented: Binding<Bool>) -> MatrixView {
return MatrixView(matrix: PDMatrix(rows: 6, cols: 6, pdms: [
    PDM(row: 0, col: 0, outcome: .correct, text: ntoSF(1)),
    PDM(row: 1, col: 1, outcome: .correct, text: ntoSF(2)),
    PDM(row: 2, col: 2, outcome: .correct, text: ntoSF(3)),
    PDM(row: 3, col: 3, outcome: .correct, text: ntoSF(4)),
    PDM(row: 4, col: 4, outcome: .correct, text: ntoSF(5)),
    PDM(row: 5, col: 5, outcome: .correct, text: ntoSF(6)),
]), topLabel: "6x6 Path 1", bottomLabel: "Filled upper diagonal correctly", correctColor: .green, incorrectColor: .red, isPresented: isPresented)
}

func bottomsUp(isPresented: Binding<Bool>) -> MatrixView {
return MatrixView(matrix: PDMatrix(rows: 6, cols: 6, pdms: [
    PDM(row: 0, col: 5, outcome: .correct, text: ntoSF(6)),
    PDM(row: 1, col: 4, outcome: .correct, text: ntoSF(5)),
    PDM(row: 2, col: 3, outcome: .correct, text: ntoSF(4)),
    PDM(row: 3, col: 2, outcome: .correct, text: ntoSF(3)),
    PDM(row: 4, col: 1, outcome: .correct, text: ntoSF(2)),
    PDM(row: 5, col: 0, outcome: .correct, text: ntoSF(1)),
]), topLabel: "Bottoms Up", bottomLabel: "Filled lower diagonal correctly", correctColor: .green, incorrectColor: .red, isPresented: isPresented)
}

func niceWinner(isPresented: Binding<Bool>) -> MatrixView {
return MatrixView(matrix: PDMatrix(rows: 6, cols: 6, pdms: [
    PDM(row: 0, col: 0, outcome: .correct, text: ntoSF(1)),
    PDM(row: 1, col: 1, outcome: .incorrect, text: ntoSF(2)),
    PDM(row: 0, col: 1, outcome: .correct, text: ntoSF(3)),
    PDM(row: 1, col: 2, outcome: .correct, text: ntoSF(4)),
    PDM(row: 2, col: 2, outcome: .correct, text: ntoSF(5)),
    PDM(row: 3, col: 3, outcome: .correct, text: ntoSF(6)),
    PDM(row: 4, col: 4, outcome: .incorrect, text: ntoSF(7)),
    PDM(row: 4, col: 3, outcome: .correct, text: ntoSF(8)),
    PDM(row: 5, col: 4, outcome: .correct, text: ntoSF(9)),
    PDM(row: 5, col: 5, outcome: .correct, text: ntoSF(10)),
]), topLabel: "Nice Winner", bottomLabel: "Despite two key diagonal losers, the game was won in 10 moves!", correctColor: .green, incorrectColor: .red, isPresented: isPresented)
}

func startInAnyCorner(isPresented: Binding<Bool>) -> MatrixView {
return MatrixView(matrix: PDMatrix(rows: 3, cols: 3, pdms: [
    PDM(row: 0, col: 0, outcome: .correct, text: "checkmark"),
    PDM(row: 0, col: 2, outcome: .correct, text: "checkmark"),
    PDM(row: 2, col: 0, outcome: .correct, text: "checkmark"),
    PDM(row: 2, col: 2, outcome: .correct, text: "checkmark"),
]), topLabel: "Start In Any Corner", bottomLabel: "Or just start anywhere you like", correctColor: .yellow, incorrectColor: .blue, isPresented: isPresented)
}

func move0(isPresented: Binding<Bool>) -> MatrixView {
return MatrixView(matrix: PDMatrix(rows: 3, cols: 3, pdms: [
    PDM(row: 2, col: 0, outcome: .correct, text: "1.circle"),
]), topLabel: "Let's Start Here", bottomLabel: "Picking A Friendly Topic and Question", correctColor: .yellow, incorrectColor: .blue, isPresented: isPresented)
}

func move00(isPresented: Binding<Bool>) -> MatrixView {
return MatrixView(matrix: PDMatrix(rows: 3, cols: 3, pdms: [
    PDM(row: 2, col: 0, outcome: .correct, text: "1.circle"),
    PDM(row: 0, col: 2, outcome: .correct, text: "star.fill"),
]), topLabel: "Try to End Here", bottomLabel: "Any Path Will Do", correctColor: .yellow, incorrectColor: .blue, isPresented: isPresented)
}

func move1(isPresented: Binding<Bool>) -> MatrixView {
return MatrixView(matrix: PDMatrix(rows: 3, cols: 3, pdms: [
    PDM(row: 1, col: 1, outcome: .correct, text: "2.circle"),
    PDM(row: 2, col: 0, outcome: .correct, text: "1.circle"),
]), topLabel: "Try the Center", bottomLabel: "The center is often a good choice", correctColor: .yellow, incorrectColor: .blue, isPresented: isPresented)
}

func nonAdjecntMove(isPresented: Binding<Bool>) -> MatrixView {
return MatrixView(matrix: PDMatrix(rows: 3, cols: 3, pdms: [
    PDM(row: 2, col: 2, outcome: .incorrect, text: "xmark.circle"),
    PDM(row: 2, col: 0, outcome: .correct, text: "1.circle"),
]), topLabel: "You Can't Move Here", bottomLabel: "At least not at first - It's not adjacent!", correctColor: .yellow, incorrectColor: .red, isPresented: isPresented)
}

func move2(isPresented: Binding<Bool>) -> MatrixView {
return MatrixView(matrix: PDMatrix(rows: 3, cols: 3, pdms: [
    PDM(row: 1, col: 1, outcome: .correct, text: "2.circle"),
    PDM(row: 2, col: 0, outcome: .correct, text: "1.circle"),
    PDM(row: 0, col: 2, outcome: .correct, text: "3.circle"),
]), topLabel: "Good Job, Now Finish Up", bottomLabel: "If you answer the associated questions correctly, you win!", correctColor: .yellow, incorrectColor: .blue, isPresented: isPresented)
}
