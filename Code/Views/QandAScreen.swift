import SwiftUI

struct QandAScreen: View {

  @Bindable var chmgr: ChaMan  //
  @Bindable var gs: GameState
  let row: Int
  let col: Int
  @Binding var isPresentingDetailView: Bool
  // @Binding var useOtherDiagonalAlert : Bool
  @Environment(\.dismiss) var dismiss  // Environment value for dismissing the view

  @Environment(\.colorScheme) var colorScheme

  @State var showInfo = false
  @State var gimmeeAlert = false
  @State var youwinAlert = false
  @State var youloseAlert = false
  @State var showThumbsUp: Challenge? = nil
  @State var showThumbsDown: Challenge? = nil

  @State var answerCorrect: Bool = false  // State to track if the selected answer is correct
  @State var showCorrectAnswer: Bool = false  // State to show correct answer temporarily
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
            handlePass: {killTimer=true
              dismiss()},
            handleGimmee: handleGimmee,
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
            answerGiven = nil  
            showHint=false
          }, animation: .spring()
        )

        .timeoutAlert(
          item: $answerGiven,
          title: (answerCorrect
            ? "You Got It!\nThe answer is:\n " : "Sorry...\nThe answer is:\n")
            + ch.correct,
          message: ch.explanation ?? "xxx",
          buttonTitle: nil,
          timeout: 5.0,
          fadeOutDuration: 0.5,
          onButtonTapped: {
            //withAnimation(.easeInOut(duration: 0.75)) { // Slower dismissal
              isPresentingDetailView = false
              dismiss()
           // }
////****** THIS CODE SHOULD RUN AFTER DISMISS() *******//////
            if let answerGiven = answerGiven {
              switch answerCorrect {
              case true:
                answeredCorrectly(ch, row: row, col: col, answered: answerGiven)
              case false:
                answeredIncorrectly(
                  ch, row: row, col: col, answered: answerGiven)
              }
            }
            questionedWasAnswered = false  // to guard against tapping toomany times

          }// onbuttontapped
        )
      }

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
        onButton1Tapped: handleGimmee,
        onButton2Tapped: { print("Gimmee cancelled") },
        animation: .spring())
    }
  }
}
#Preview {
  QandAScreen(
    chmgr: ChaMan.mock, gs: GameState.mock,
    row: 0, col: 0,
    isPresentingDetailView: .constant(true))  //qactiveAlert: .constant(nil))//,
}
#Preview {
  QandAScreen(
    chmgr: ChaMan.mock, gs: GameState.mock,
    row: 0, col: 0,
    isPresentingDetailView: .constant(false))  //qactiveAlert: .constant(nil))//,
}
extension QandAScreen {
  func toggleHint() {
    if chmgr.everyChallenge[gs.board[row][col]]
      .hint.count > 1  { // guard against short hints
      showHint.toggle()
    }
  }
  
  func handleGimmee() {
    killTimer = true
    let idx = gs.board[row][col]
    let result = chmgr.replaceChallenge(at:idx)
    switch result {
    case .success(let index):
      gs.gimmees -= 1
      gs.board[row][col] = index[0]
      gs.cellstate[row][col] = .unplayed
      gs.replaced[row][col] += [idx] // keep track of what we are replacing
      gs.replacedcount += 1
      print("Gimmee realloation successful \(index)")
    case .error(let error):
      print("Couldn't handle gimmee reallocation \(error)")
    }
    gs.saveGameState()
    dismiss()
  }
  
  func answeredCorrectly(_ ch:Challenge,row:Int,col:Int,answered:String) {
    chmgr.checkAllTopicConsistency("mark correct before")
    conditionalAssert(gs.checkVsChaMan(chmgr: chmgr,message:"answeredCorrectly"))
    answerCorrect = true
    gs.movenumber += 1
    gs.moveindex[row][col] = gs.movenumber
    gs.cellstate[row][col] = .playedCorrectly
    gs.rightcount += 1
    chmgr.bumpRightcount(topic: ch.topic)
    chmgr.stati[gs.board[row][col]] = .playedCorrectly  // ****
    chmgr.ansinfo[ch.id]  =
    AnsweredInfo(id: ch.id, answer: answered, outcome:.playedCorrectly,
                 timestamp: Date(), timetoanswer:elapsedTime, gamenumber: gs.gamenumber, movenumber: gs.movenumber,row:row,col:col)
    killTimer=true
    let j = gs.moveindex[row][col]
    TSLog("Challenge \(ch.id) index: \(j) answered correctly")
    gs.saveGameState()
    chmgr.save()
    chmgr.checkAllTopicConsistency("mark correct after")
  }
  func answeredIncorrectly(_ ch:Challenge,row:Int,col:Int,answered:String) {
    chmgr.checkAllTopicConsistency("mark incorrect before")
    conditionalAssert(gs.checkVsChaMan(chmgr: chmgr,message:"answeredCorrectly"))
    answerCorrect = false
    showCorrectAnswer = false
    gs.movenumber += 1
    gs.moveindex[row][col] = gs.movenumber
    gs.cellstate[row][col] = .playedIncorrectly
    gs.wrongcount += 1
    chmgr.bumpWrongcount(topic: ch.topic)
    chmgr.stati[gs.board[row][col]] = .playedIncorrectly  // ****
    chmgr.ansinfo[ch.id]  =
    AnsweredInfo(id: ch.id, answer: answered, outcome:.playedIncorrectly,
                 timestamp: Date(), timetoanswer: elapsedTime, gamenumber: gs.gamenumber, movenumber: gs.movenumber,row:row,col:col)
    killTimer=true
    let j = gs.moveindex[row][col]
    TSLog("Challenge \(ch.id) index: \(j) answered incorrectly")
    gs.saveGameState()
    chmgr.save()
    chmgr.checkAllTopicConsistency("mark incorrect after")
  }

}
