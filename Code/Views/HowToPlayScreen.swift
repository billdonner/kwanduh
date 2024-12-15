import SwiftUI

// MARK: - Models and Data Structures

enum Outcome {
    case correct
    case incorrect
}

struct Move {
    let outcome: Outcome
    let text: String
    let useSymbol: Bool

    init(_ outcome: Outcome, text: String? = nil, useSymbol: Bool = true) {
        self.outcome = outcome
        self.text = text ?? ""
        self.useSymbol = useSymbol
    }
}

struct PDM {
    let position: (row: Int, col: Int)
    let move: Move

    init(row: Int, col: Int, outcome: Outcome, text: String, useSymbol: Bool = true) {
        self.position = (row, col)
        self.move = Move(outcome, text: text, useSymbol: useSymbol)
    }
}

func PDMatrix(rows: Int, cols: Int, pdms: [PDM]) -> [[Move?]] {
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
    UUID().uuidString
}

// Represent one step in the how-to-play tutorial
struct TutorialStep: Identifiable {
    let id = mkID()
    let title: String
    let description: String
    let matrix: [[Move?]]?
    let topLabel: String?
    let bottomLabel: String?
    let correctColor: Color
    let incorrectColor: Color
}

// MARK: - Views

// Dismiss button to close the tutorial
struct DismissButton: View {
    @Binding var isPresented: Bool
    var body: some View {
        Button(action: {
            isPresented = false
        }) {
            Image(systemName: "xmark.circle.fill")
                .font(.title2)
                .foregroundColor(.primary) // Adapts to light/dark mode
                .padding()
        }
        .accessibilityLabel("Close tutorial")
    }
}

// A matrix cell view with improved styling
struct MatrixCellView: View {
    var move: Move?
    let correctColor: Color
    let incorrectColor: Color

    var borderColor: Color {
        guard let m = move else { return .primary.opacity(0.5) }
        switch m.outcome {
        case .correct:
            return correctColor
        case .incorrect:
            return incorrectColor
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(uiColor: .secondarySystemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: 3)
                )
            if let move = move {
                if move.useSymbol {
                    Image(systemName: move.text)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.primary)
                        .accessibilityLabel(move.text)
                } else {
                    Text(move.text)
                        .foregroundColor(.primary)
                        .accessibilityLabel(move.text)
                }
            }
        }
        .frame(width: 48, height: 48)
        .padding(4)
    }
}

// A view displaying a matrix of moves with optional labels
struct MatrixView: View {
    let matrix: [[Move?]]
    let topLabel: String?
    let bottomLabel: String?
    let correctColor: Color
    let incorrectColor: Color

    var body: some View {
        VStack(spacing: 16) {
            if let top = topLabel {
                Text(top)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                    .accessibilityLabel(top)
            }

            VStack(spacing: 0) {
                ForEach(0..<matrix.count, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<(matrix.first?.count ?? 0), id: \.self) { col in
                            MatrixCellView(move: matrix[row][col], correctColor: correctColor, incorrectColor: incorrectColor)
                        }
                    }
                }
            }

            if let bottom = bottomLabel {
                Text(bottom)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                    .accessibilityLabel(bottom)
            }
        }
        .padding()
        .background(Color(uiColor: .systemBackground).opacity(0.7))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

// A single tutorial step view
struct TutorialStepView: View {
    let step: TutorialStep

    var body: some View {
        VStack(spacing: 24) {
            Text(step.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .accessibilityLabel(step.title)

            if let matrix = step.matrix {
                MatrixView(matrix: matrix,
                           topLabel: step.topLabel,
                           bottomLabel: step.bottomLabel,
                           correctColor: step.correctColor,
                           incorrectColor: step.incorrectColor)
            }

            Text(step.description)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .accessibilityLabel(step.description)
        }
        .padding()
    }
}

// The main HowToPlayScreen showing a series of TutorialSteps
struct HowToPlayScreen: View {
    @Binding var isPresented: Bool
    @State private var currentStepIndex: Int = 0

    // Make ntoSF a static function to avoid issues with initializer
    static func ntoSF(_ number: Int) -> String { "\(number).circle" }

    let steps: [TutorialStep]

    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented

        // Example steps (Update or adjust them to reflect your actual game logic)
        steps = [
            TutorialStep(
                title: "How to Play",
                description: "Learn the basics of the game. Swipe right or tap Next to continue.",
                matrix: nil,
                topLabel: nil,
                bottomLabel: nil,
                correctColor: .green,
                incorrectColor: .red
            ),
            TutorialStep(
                title: "Start in Any Corner",
                description: "You can begin your path from any corner cell. Just pick a corner and start answering questions!",
                matrix: PDMatrix(rows: 3, cols: 3, pdms: [
                    PDM(row: 0, col: 0, outcome: .correct, text: "checkmark"),
                    PDM(row: 0, col: 2, outcome: .correct, text: "checkmark"),
                    PDM(row: 2, col: 0, outcome: .correct, text: "checkmark"),
                    PDM(row: 2, col: 2, outcome: .correct, text: "checkmark"),
                ]),
                topLabel: "Start In Any Corner",
                bottomLabel: "Or just start anywhere you like",
                correctColor: .yellow,
                incorrectColor: .blue
            ),
            TutorialStep(
                title: "Adjacent Moves Only",
                description: "You must move to a cell adjacent to your current cell. Diagonals count, but you can't skip over cells!",
                matrix: PDMatrix(rows: 3, cols: 3, pdms: [
                    PDM(row: 2, col: 0, outcome: .correct, text: "1.circle"),
                    PDM(row: 2, col: 2, outcome: .incorrect, text: "xmark.circle")
                ]),
                topLabel: "You Can't Move Here",
                bottomLabel: "Not adjacent yet!",
                correctColor: .yellow,
                incorrectColor: .red
            ),
            TutorialStep(
                title: "Finishing the Path",
                description: "Answer the questions correctly along a path that leads to your goal. Good luck!",
                matrix: PDMatrix(rows: 3, cols: 3, pdms: [
                    PDM(row: 0, col: 2, outcome: .correct, text: "1.circle"),
                    PDM(row: 1, col: 1, outcome: .correct, text: "2.circle"),
                    PDM(row: 2, col: 0, outcome: .correct, text: "3.circle"),
                ]),
                topLabel: "Good Job, Now Finish Up",
                bottomLabel: "If you answer correctly, you win!",
                correctColor: .green,
                incorrectColor: .red
            ),
            TutorialStep(
                title: "Interior vs. Border Cells",
                description: "Interior cells have up to 8 adjacent cells, while border cells have fewer. Plan your moves accordingly!",
                matrix: PDMatrix(rows: 3, cols: 3, pdms: [
                    PDM(row: 1, col: 1, outcome: .incorrect, text: "xmark.circle"),
                    PDM(row: 0, col: 0, outcome: .correct, text: "checkmark"),
                    PDM(row: 0, col: 2, outcome: .correct, text: "checkmark"),
                    PDM(row: 2, col: 0, outcome: .correct, text: "checkmark"),
                    PDM(row: 2, col: 2, outcome: .correct, text: "checkmark"),
                ]),
                topLabel: "Different Adjacencies",
                bottomLabel: "Interior cells = more choices!",
                correctColor: .green,
                incorrectColor: .red
            ),
            TutorialStep(
                title: "Larger Boards, More Possibilities",
                description: "Larger boards give you more complex paths. Adapt your strategy!",
                matrix: PDMatrix(rows: 4, cols: 4, pdms: [
                    PDM(row: 0, col: 0, outcome: .correct, text: HowToPlayScreen.ntoSF(1)),
                    PDM(row: 0, col: 3, outcome: .correct, text: HowToPlayScreen.ntoSF(4)),
                    PDM(row: 3, col: 0, outcome: .correct, text: HowToPlayScreen.ntoSF(13)),
                    PDM(row: 3, col: 3, outcome: .correct, text: HowToPlayScreen.ntoSF(16)),
                ]),
                topLabel: "4x4 Board Example",
                bottomLabel: "More routes to explore!",
                correctColor: .green,
                incorrectColor: .red
            ),
            TutorialStep(
                title: "Master the Diagonal",
                description: "Diagonals can help you reach distant cells. Use them wisely!",
                matrix: PDMatrix(rows: 3, cols: 3, pdms: [
                    PDM(row: 0, col: 0, outcome: .correct, text: HowToPlayScreen.ntoSF(1)),
                    PDM(row: 1, col: 1, outcome: .correct, text: HowToPlayScreen.ntoSF(2)),
                    PDM(row: 2, col: 2, outcome: .correct, text: HowToPlayScreen.ntoSF(3)),
                ]),
                topLabel: "Diagonal Path",
                bottomLabel: "A straight shot!",
                correctColor: .green,
                incorrectColor: .red
            ),
            // Introducing blocked cells
            TutorialStep(
                title: "Blocked Cells",
                description: "Some cells are blocked and cannot be entered. They are indicated by a lock icon. You'll need to plan around these obstacles!",
                matrix: PDMatrix(rows: 3, cols: 3, pdms: [
                    PDM(row: 0, col: 1, outcome: .incorrect, text: "lock.fill"),
                    PDM(row: 1, col: 1, outcome: .incorrect, text: "lock.fill"),
                    PDM(row: 2, col: 1, outcome: .incorrect, text: "lock.fill"),
                    PDM(row: 0, col: 0, outcome: .correct, text: "checkmark"),
                    PDM(row: 2, col: 2, outcome: .correct, text: "checkmark")
                ]),
                topLabel: "Can't Pass Through Locked Cells",
                bottomLabel: "Find a path around them!",
                correctColor: .green,
                incorrectColor: .red
            ),
            // A more interesting scenario with blocked cells
            TutorialStep(
                title: "A Complex Scenario",
                description: "Here’s a larger board with blocked cells. Your goal is to reach from the top-left corner (1) to the bottom-right corner (6) by selecting adjacent cells. Think carefully about which path to take!",
                matrix: PDMatrix(rows: 5, cols: 5, pdms: [
                    // Start and goal
                    PDM(row: 0, col: 0, outcome: .correct, text: HowToPlayScreen.ntoSF(1)),
                    PDM(row: 4, col: 4, outcome: .correct, text: HowToPlayScreen.ntoSF(6)),

                    // Intermediate steps (just placeholders)
                    PDM(row: 1, col: 1, outcome: .correct, text: HowToPlayScreen.ntoSF(2)),
                    PDM(row: 2, col: 2, outcome: .correct, text: HowToPlayScreen.ntoSF(3)),
                    PDM(row: 3, col: 3, outcome: .correct, text: HowToPlayScreen.ntoSF(4)),
                    PDM(row: 4, col: 3, outcome: .correct, text: HowToPlayScreen.ntoSF(5)),

                    // Blocked cells (using lock icon)
                    PDM(row: 0, col: 2, outcome: .incorrect, text: "lock.fill"),
                    PDM(row: 1, col: 3, outcome: .incorrect, text: "lock.fill"),
                    PDM(row: 2, col: 1, outcome: .incorrect, text: "lock.fill"),
                    PDM(row: 3, col: 0, outcome: .incorrect, text: "lock.fill"),
                    PDM(row: 3, col: 2, outcome: .incorrect, text: "lock.fill")
                ]),
                topLabel: "Plan Your Route",
                bottomLabel: "Blocked cells force you to find an alternate path!",
                correctColor: .green,
                incorrectColor: .red
            )
        ]
    }

    var body: some View {
        ZStack {
            // A nice background gradient
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    DismissButton(isPresented: $isPresented)
                }
                .padding(.top)

                Spacer()

                TabView(selection: $currentStepIndex) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        TutorialStepView(step: steps[index])
                            .tag(index)
                            .padding(.horizontal)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                Spacer()

                // Custom navigation controls
                HStack {
                    if currentStepIndex > 0 {
                        Button("Back") {
                            withAnimation {
                                currentStepIndex -= 1
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.primary)
                    }

                    Spacer()

                    if currentStepIndex < steps.count - 1 {
                        Button("Next") {
                            withAnimation {
                                currentStepIndex += 1
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.primary)
                    } else {
                        Button("Done") {
                            isPresented = false
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.primary)
                    }
                }
                .padding()
            }
        }
    }
}

// MARK: - Preview

struct HowToPlayScreen_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayScreen(isPresented: .constant(true))
            .preferredColorScheme(.dark) // Test in dark mode
        HowToPlayScreen(isPresented: .constant(true))
            .preferredColorScheme(.light) // Test in light mode
    }
}
