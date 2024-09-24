import SwiftUI


struct QandAScreen: View {
  let row: Int
  let col: Int 
  @Binding var isPresentingDetailView: Bool
  @Bindable  var chmgr:ChaMan //
  @Bindable var gs: GameState  //
  @Environment(\.dismiss) var dismiss  // Environment value for dismissing the view
  
  @Environment(\.colorScheme) var colorScheme
  
  @State  var showInfo = false
  @State   var gimmeeAlert = false
  @State   var showThumbsUp: Challenge? = nil
  @State   var showThumbsDown: Challenge? = nil
  @State   var selectedAnswer: String? = nil  // State to track selected answer
  @State   var answerCorrect: Bool = false   // State to track if the selected answer is correct
  @State   var showCorrectAnswer: Bool = false  // State to show correct answer temporarily
  @State   var showBorders: Bool = false  // State to show borders after animation
  @State   var showHint: Bool = false  // State to show/hide hint
  @State   var animateBackToBlue: Bool = false  // State to animate answers back to blue
  @State   var dismissToRootFlag = false // take all the way to GameScreen if set
  @State   var answerGiven: Bool = false  // prevent further interactions after an answer is given
  @State   var killTimer:Bool = false // set true to get the timer to stop
  @State   var elapsedTime: TimeInterval = 0
  @State   var questionedWasAnswered: Bool = false
  
  var body: some View {
    GeometryReader { geometry in
      let ch = chmgr.everyChallenge[gs.board[row][col]]
      ZStack {
        VStack {
          QandATopBarView(
            gs: gs,
            topic: ch.topic,
            hint: ch.hint,
            handlePass:handlePass,
            handleGimmee: handleGimmee,
            toggleHint:  toggleHint,
            elapsedTime: $elapsedTime,
            killTimer: $killTimer)
          .disabled(questionedWasAnswered)
          .debugBorder()
          
          
          // pass in the answers explicitly to eliminate flip flopsy behavior
          questionAndAnswersSectionVue(ch:ch, geometry: geometry,colorScheme: colorScheme,answerGiven: $answerGiven,answerCorrect: $answerCorrect)
            .disabled(questionedWasAnswered)
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
        //.padding(.horizontal, 10)
        .padding(.bottom, 30)
        
        .hintAlert(isPresented: $showHint, title: "Here's Your Hint: ", message: ch.hint,
                   buttonTitle: "Dismiss", onButtonTapped: {
          handleDismissal(toRoot:false)
        }, animation: .spring())
        
        .answeredAlert(isPresented: $answerGiven,
                       title: (answerCorrect ? "You Got It!\nThe answer is:\n " :"Sorry...\nThe answer is:\n") + ch.correct, 
                       message: ch.explanation ?? "xxx",
                       buttonTitle: "OK",
                       onButtonTapped: {
                            handleDismissal(toRoot:true)
                            questionedWasAnswered = false // to guard against tapping toomany times
        })
        .sheet(isPresented: $showInfo){
          ChallengeInfoScreen(challenge: ch)
        }
        .sheet(item:$showThumbsDown) { ch in
          NegativeSentimentView(id: ch.id)
            .dismissable {
              print("exit from negative sentiment")
            }
        }
        .sheet(item:$showThumbsUp) { ch in
          PositiveSentimentView(id: ch.id)
            .dismissable {
              print("exit from positive sentiment")
            }
        }
        .gimmeeAlert(isPresented: $gimmeeAlert,
                     title: "I will replace this Question \nwith another from the same topic, \nif possible",
                     message: "I will charge you one gimmee",
                     button1Title: "OK",
                     button2Title: "Cancel",
                     onButton1Tapped: handleGimmee,
                     onButton2Tapped: { print("Gimmee cancelled")  },
                     animation: .spring())
      }
    }
  }
  
  
}


#Preview {
  QandAScreen(row: 0, col: 0,   isPresentingDetailView: .constant(true), chmgr: ChaMan.mock, gs: GameState.mock)
  
}
#Preview {
  QandAScreen(row: 0, col: 0,  isPresentingDetailView: .constant(true), chmgr: ChaMan.mock, gs: GameState.mock )
  
}
