//
//  QandAScreenExt.swift
//  basic
//
//  Created by bill donner on 8/3/24.
//

import SwiftUI


extension QandAScreen {
  func questionAndAnswersSectionVue(ch:Challenge,geometry: GeometryProxy,colorScheme: ColorScheme,answerGiven:Binding<String?>,answerCorrect:Binding<Bool> ) -> some View {

    VStack(spacing: 10) {
      questionSectionVue(geometry: geometry)
        .frame(maxWidth: max(0, geometry.size.width), maxHeight: max(0, geometry.size.height * 0.4))//make bigger when bottom buttons gone
      //shuffle the questions
      AnswerButtonsView(row: row,col: col,answers: ch.answers.shuffled(), geometry: geometry, colorScheme: colorScheme,disabled:questionedWasAnswered,answerGiven: answerGiven,answerCorrect: answerCorrect)
      { answer,row,col in
        handleAnswerSelection(answer: answer,row:row,col:col)
      }
    }
    .padding(.horizontal)
    .padding(.bottom)
    
    // Invalid frame dimension (negative or non-finite).?
    .frame(maxWidth: max(0, geometry.size.width), maxHeight: max(0, geometry.size.height * 0.8))//make bigger when bottom buttons gone
  }
  
  func questionSectionVue(geometry: GeometryProxy) -> some View {
   let paddingWidth = geometry.size.width * 0.1
   let contentWidth = geometry.size.width - paddingWidth
    let ch = chmgr.everyChallenge[gs.board[row][col]]
    let topicColor =   gs.topicsinplay[ch.topic]?.toColor() ?? .red
    
    return ZStack {
      RoundedRectangle(cornerRadius: 10).fill(topicColor.opacity(1.0))
      // Invalid frame dimension (negative or non-finite).?
      
      VStack(spacing:0) {
        buttonRow
          .foregroundColor(foregroundColorFrom( backgroundColor: topicColor ))
          .padding([.top,.horizontal])
          .debugBorder()
        Spacer()
        Text(ch.question)
          .font(isIpad ? .largeTitle:.title3)
          .padding(.horizontal)//([.top,.horizontal])
          .lineLimit(8)
        .foregroundColor(foregroundColorFrom( backgroundColor: topicColor ))
           .frame(width: max(0,contentWidth), height:max(0,  geometry.size.height * 0.25))//0.2
          .fixedSize(horizontal: false, vertical: true)
          .debugBorder()
        Spacer()
      }
    }.debugBorder()
   // .frame(width: max(0,contentWidth), height:max(0,  geometry.size.height * 0.33))
  }
  
  var buttonRow: some View {
    HStack(spacing:10) {
      HStack(spacing:isIpad ? 25:15){
        gimmeeButton
        thumbsUpButton
        thumbsDownButton
      }
      Spacer()
      if freeportButtons {
        markCorrectButton
        markIncorrectButton
        infoButton
      }
      hintButton
    }
  }

}


extension QandAScreen {
  
func handleDismissal(toRoot:Bool) {
    if toRoot {
      withAnimation(.easeInOut(duration: 0.75)) { // Slower dismissal
        isPresentingDetailView = false
        dismiss()
      }
    } else {
      answerGiven = nil //showAnsweredAlert = false
      showHint=false //  showHintAlert = false
    }
  }
  
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
  
  func handlePass() {
    killTimer=true
    dismiss()
  }
  
  func answeredCorrectly(_ ch:Challenge,row:Int,col:Int,answered:String) {
    chmgr.checkAllTopicConsistency("mark correct before")
    conditionalAssert(gs.checkVsChaMan(chmgr: chmgr,message:"answeredCorrectly"))
    answerCorrect = true
    showBorders = true
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
    TSLog("Challenge \(ch.id) answered correctly")
    gs.saveGameState()
    chmgr.save()
    chmgr.checkAllTopicConsistency("mark correct after")
  }
  func answeredIncorrectly(_ ch:Challenge,row:Int,col:Int,answered:String) {
    chmgr.checkAllTopicConsistency("mark incorrect before")
    conditionalAssert(gs.checkVsChaMan(chmgr: chmgr,message:"answeredCorrectly"))
    answerCorrect = false
    showCorrectAnswer = false
    showBorders = true
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
    TSLog("Challenge \(ch.id) answered incorrectly")
    gs.saveGameState()
    chmgr.save()
    chmgr.checkAllTopicConsistency("mark incorrect after")
  }
  func handleAnswerSelection(answer: String,row:Int,col:Int) {
    if !questionedWasAnswered { // only allow one answer
      let ch = chmgr.everyChallenge[gs.board[row][col]]
      answerCorrect = (answer == ch.correct)
      questionedWasAnswered = true
      answerGiven = answer //triggers the alert
    } else {
      print("dubl tap \(answer)")
    }
  }
}
/*
 
 
 //      switch answerCorrect {
 //      case true: answeredCorrectly(ch,row:row,col:col,answered:answer)
 //      case false: answeredIncorrectly(ch,row:row,col:col,answered: answer)
 //      }
 func answerButtonVue(answer: String,row:Int,col:Int, buttonWidth: CGFloat, buttonHeight: CGFloat,colorScheme: ColorScheme, taller: Bool = false) -> some View {

   return  Button(action: {
     handleAnswerSelection(answer: answer,row:row,col:col)
   })
   {
    // let ch = chmgr.everyChallenge[gs.board[row][col]]
     Text(answer)
       .font(isIpad ? .title:.body)
       .foregroundColor(.white)
       .padding()
     .frame(width:max(20, buttonWidth*0.9), height: max(20,buttonHeight*0.9)) // clamp up
       .background(.blue
       )
       .cornerRadius(5)  // Make the buttons rounded rectangles
       .minimumScaleFactor(0.5)  // Adjust font size to fit
       .lineLimit(8)
       //.rotationEffect(showCorrectAnswer && answer == ch.correct ? .degrees(360) : .degrees(0))
//        .overlay(
//          RoundedRectangle(cornerRadius: 5)  // Match the corner radius
//            .stroke(showBorders && answer == selectedAnswer && !answerCorrect ? Color.red : showBorders && answer == ch.correct && answerCorrect == false ? Color.green : Color.clear, lineWidth: 5)
//        )
       //.animation(.easeInOut(duration: showCorrectAnswer ? 1.0 : 0.5), value: showCorrectAnswer)
       .animation(.easeInOut(duration: answerGiven ? 1.0 : 0.5), value: animateBackToBlue)
       //.animation(.easeInOut(duration: 0.5), value: showBorders)
   }
 }
 */
