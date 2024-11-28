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
      QandAnswerButtonsView(row: row,col: col,answers: ch.answers.shuffled(), geometry: geometry, colorScheme: colorScheme,disabled:questionedWasAnswered,answerGiven: answerGiven,answerCorrect: answerCorrect)
      { answer,row,col in
        if !questionedWasAnswered { // only allow one answer
          let ch = chmgr.everyChallenge[gs.board[row][col]]
          answerCorrect.wrappedValue = (answer == ch.correct)
          questionedWasAnswered = true
          answerGiven.wrappedValue = answer //triggers the alert
        } else {
          print("dubl tap \(answer)")
        }
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


