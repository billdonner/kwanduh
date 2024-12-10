import SwiftUI

struct QandAScreen: View {

  @Bindable var chmgr: ChaMan  //
  @Bindable var gs: GameState
  let row: Int
  let col: Int
  @Binding var isPresentingDetailView: Bool
  @Binding var qarb: QARBOp?
  @Environment(\.dismiss) var dismiss  // Environment value for dismissing the view

  @Environment(\.colorScheme) var colorScheme

  @State var showInfo = false
  @State var gimmeeAlert = false
  @State var showThumbsUp: Challenge? = nil
  @State var showThumbsDown: Challenge? = nil

  @State var answerCorrect: Bool = false  // State to track if the selected answer is correct
  @State var showHint: Bool = false  // State to show/hide hint 
  @State var dismissToRootFlag = false  // take all the way to GameScreen if set
  @State var answerGiven: String? = nil  // prevent further interactions after an answer is given
  @State var killTimer: Bool = false  // set true to get the timer to stop
  @State var elapsedTime: TimeInterval = 0
  @State var questionedWasAnswered: Bool = false

  var body: some View {
    GeometryReader { geometry in
      let ch = chmgr.everyChallenge[gs.board[row][col]]
      ZStack {
        VStack {
          QandATopBarView(
            gs: gs,
            topic: ch.topic,
            hint: ch.hint,
            handlePass: {
              qarb = noAnswerGiven(row: row, col: col, elapsed: elapsedTime)
              dismiss()
            },
            handleGimmee: {
              qarb = gimmeeRequested(row: row, col: col, elapsed: elapsedTime)
              dismiss()
            },
            toggleHint: toggleHint,
            elapsedTime: $elapsedTime,
            killTimer: $killTimer
          )
          .disabled(questionedWasAnswered)
          .debugBorder()

          // pass in the answers explicitly to eliminate flip flopsy behavior
          questionAndAnswersSectionVue(
            ch: ch, geometry: geometry, colorScheme: colorScheme,
            answerGiven: $answerGiven, answerCorrect: $answerCorrect
          )
          .disabled(questionedWasAnswered)
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
        //.padding(.horizontal, 10)
        .padding(.bottom, 30)

        .hintAlert(
          isPresented: $showHint, title: "Here's Your Hint: ", message: ch.hint,
          buttonTitle: "Dismiss",
          onButtonTapped: {
            answerGiven = nil  //showAnsweredAlert = false
            showHint = false  //  showHintAlert = false
          }, animation: .spring()
        )

        .timeoutAlert(
          item: $answerGiven,
          title: (answerCorrect
            ? "You Got It!\nThe answer is:\n " : "Sorry...\nThe answer is:\n")
            + ch.correct,
          message: ch.explanation ?? "xxx",
          buttonTitle: nil,
          timeout: 2.0,
          fadeOutDuration: 0.1,
          onButtonTapped: {
            //handleDismissal(toRoot:true)
            isPresentingDetailView = false

            // Delay execution of the next steps
            // DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { // Adjust delay duration

            if let answerGiven = answerGiven {
              switch answerCorrect {
              case true:
                qarb = answeredCorrectly(
                  ch, row: row, col: col, answered: answerGiven,
                  elapsed: elapsedTime)
              case false:
                qarb = answeredIncorrectly(
                  ch, row: row, col: col, answered: answerGiven,
                  elapsed: elapsedTime)
              }
              questionedWasAnswered = false  // to guard against tapping toomany times
            }
            dismiss()
          }
        )

        .sheet(isPresented: $showInfo) {
          ChallengeInfoScreen(challenge: ch)
        }
        .sheet(item: $showThumbsDown) { ch in
          NegativeSentimentView(id: ch.id)
            .dismissable {
              print("exit from negative sentiment")
            }
        }
        .sheet(item: $showThumbsUp) { ch in
          PositiveSentimentView(id: ch.id)
            .dismissable {
              print("exit from positive sentiment")
            }
        }

        .gimmeeAlert(
          isPresented: $gimmeeAlert,
          title:
            "I will replace this Question \nwith another from the same topic, \nif possible",
          message: "I will charge you one gimmee",
          button1Title: "OK",
          button2Title: "Cancel",
          onButton1Tapped: {
            qarb = gimmeeRequested(row: row, col: col, elapsed: elapsedTime)
            dismiss()
          },
          onButton2Tapped: { print("Gimmee cancelled") },
          animation: .spring())
      }
    }
  }
}

#Preview {
  QandAScreen(
    chmgr: ChaMan.mock, gs: GameState.mock,
    row: 0, col: 0,
    isPresentingDetailView: .constant(true), qarb: .constant(nil))

}
#Preview {
  QandAScreen(
    chmgr: ChaMan.mock, gs: GameState.mock,
    row: 0, col: 0,
    isPresentingDetailView: .constant(true), qarb: .constant(nil))

}
