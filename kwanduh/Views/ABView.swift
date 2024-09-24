//
//  AnswerButtonsView 2.swift
//  qandao
//
//  Created by bill donner on 9/23/24.
//

import SwiftUI

struct ABView: View {

  
  let row: Int
  let col: Int
  let answers:[String]
  let colors: [Color]
  let geometry: GeometryProxy
  let colorScheme: ColorScheme

  var body: some View
  {
    let paddingWidth = geometry.size.width * 0.1
    let contentWidth = geometry.size.width - paddingWidth
    
    if answers.count >= 5 {
      let buttonWidth = (contentWidth / 2.5) - 10 // Adjust width to fit 2.5 buttons
      let buttonHeight = buttonWidth * 1.57 // 57% higher than the four-answer case
      return AnyView(
        VStack {
          ScrollView(.horizontal) {
            HStack(spacing: 15) {
              ForEach(Array(answers.enumerated()), id: \.offset) { index, answer in
                SoloAnswerButtonView(answer: answer, row: row, col: col, buttonWidth: buttonWidth, buttonHeight: buttonHeight, colorScheme: colorScheme, borderColor: colors[index], taller: true, disabled:true) { answer,row,col in
                }
              }
              .padding(.horizontal)  // Disable all answer buttons after an answer is given
            }
            Image(systemName: "arrow.right")
              .foregroundColor(.gray)
              .padding(.top, 10)
          }
          .frame(width: contentWidth)
        }  // Set width of the scrolling area
          )
    } else if answers.count == 3 {
      return AnyView(
        VStack(spacing: 15) {
          SoloAnswerButtonView(answer: answers[0], row: row, col: col, buttonWidth: contentWidth / 2.5, buttonHeight: contentWidth / 2.5, colorScheme: colorScheme, borderColor: colors[0], disabled:true  ) { answer,row,col in  }
          HStack {
            SoloAnswerButtonView(answer: answers[1], row: row, col: col, buttonWidth: contentWidth / 2.5, buttonHeight: contentWidth / 2.5, colorScheme: colorScheme, borderColor: colors[1], disabled:true )  { answer,row,col in  }
            SoloAnswerButtonView(answer: answers[2], row: row, col: col, buttonWidth: contentWidth / 2.5, buttonHeight: contentWidth / 2.5, colorScheme: colorScheme, borderColor: colors[2], disabled:true)  { answer,row,col in  }
          }
        }
          .padding(.horizontal)  // Disable all answer buttons after an answer is given
      )
    } else {
      let buttonWidth = min(geometry.size.width / 3 - 20, isIpad ? 200:100) * 1.5
      let buttonHeight = buttonWidth * 0.8 // Adjust height to fit more lines
      return AnyView(
        VStack(spacing: 10) {
          HStack {
            SoloAnswerButtonView(answer: answers[0], row: row, col: col, buttonWidth: buttonWidth, buttonHeight: buttonHeight, colorScheme: colorScheme,borderColor: colors[0], disabled:true) { answer,row,col in  }
            SoloAnswerButtonView(answer: answers[1], row: row, col: col, buttonWidth: buttonWidth, buttonHeight: buttonHeight, colorScheme: colorScheme, borderColor:colors[1], disabled:true) { answer,row,col in  }
          }
          HStack {
            SoloAnswerButtonView(answer: answers[2], row: row, col: col, buttonWidth: buttonWidth, buttonHeight: buttonHeight, colorScheme: colorScheme, borderColor: colors[2], disabled:true) { answer,row,col in  }
            SoloAnswerButtonView(answer: answers[3], row: row, col: col, buttonWidth: buttonWidth, buttonHeight: buttonHeight, colorScheme: colorScheme, borderColor: colors[3] , disabled:true) { answer,row,col in  }
          }
        }
          .padding(.horizontal)
      )
    }
  }
}

#Preview {
  GeometryReader { geometry in
    
    ABView(row: 10, col:10, answers: ["a", "b", "c","d"], colors:[.red,.blue,.green,.yellow],geometry:geometry, colorScheme: .light  )
  }
}
  
