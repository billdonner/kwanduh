//
//  QandAButtons.swift
//  basic
//
//  Created by bill donner on 8/11/24.
//

import SwiftUI

let freeportButtons = false
let buttSize = 45.0
let buttRadius = 8.0
let buttFont : Font = isIpad ? .title : .headline

extension QandAScreen {
  
   var hintButton: some View {
       Button(action: {
           toggleHint()
       }) {
           Image(systemName: "lightbulb")
               .font(buttFont)
               //.frame(width: buttSize, height:buttSize)
               .cornerRadius(buttRadius)
       }
       .disabled(chmgr.everyChallenge[gs.board[row][col]].hint.count <= 1 )
       .opacity(chmgr.everyChallenge[gs.board[row][col]].hint.count <= 1 ? 0.5:1.0)
   }
   var thumbsUpButton: some View {
       Button(action: {
         showThumbsUp =  chmgr.everyChallenge[gs.board[row][col]]
       }){
         Image(systemName: "hand.thumbsup")
           .font(buttFont)
               .cornerRadius(buttRadius)
               //.symbolEffect(.wiggle,isActive: true)
       }
   }
   var thumbsDownButton: some View {
       Button(action: {
         showThumbsDown = chmgr.everyChallenge[gs.board[row][col]]
       }){
         Image(systemName: "hand.thumbsdown")
           .font(buttFont)
               .cornerRadius(buttRadius)
              // .symbolEffect(.wiggle,isActive: true)
       }
   }
//   var passButton: some View {
//     Button(action: {
//       let ch = chmgr.everyChallenge[gs.board[row][col]]
//       handlePass()
//       qarb = QAReturnBlock(op: .donothing, ch: ch, row: row, col: col, answered: "", elapsed: elapsedTime)
//       dismiss() // get out now
//     }) {
//       Image(systemName: "multiply.circle")
//         .font(.title)
//         .foregroundColor(.white)
//         .frame(width: buttSize, height: buttSize)
//         .background(Color.gray)
//         .cornerRadius(buttRadius)
//     }
//   }
   var markCorrectButton: some View {
     Button(action: {
       let x = chmgr.everyChallenge[gs.board[row][col]]
       qarb = answeredCorrectly(x,row:row,col:col,answered:x.correct, elapsed: elapsedTime)
       dismiss() // get out now
     }) {
       Image(systemName: "checkmark.circle")
         .font(buttFont)
         //.frame(width: buttSize, height: buttSize)
         .cornerRadius(buttRadius)
     }
   }
   var markIncorrectButton: some View {
     Button(action: {
       let x = chmgr.everyChallenge[gs.board[row][col]]
       qarb =  answeredIncorrectly(x,row:row,col:col,answered:x.correct, elapsed: elapsedTime)
       dismiss() // get out now
     }) {
       Image(systemName: "xmark.circle")
         .font(buttFont)
        // .frame(width: buttSize, height: buttSize)
         .cornerRadius(buttRadius)
     }
   }
   var gimmeeButton: some View {
     Button(action: {
       gimmeeAlert = true
     }) {
       Image(systemName: "arrow.trianglehead.2.clockwise")
         .font(buttFont)
         //.frame(width: buttSize, height: buttSize)
         .cornerRadius(buttRadius)
     }
     .disabled(gs.gimmees<1)
     .opacity(gs.gimmees<1 ? 0.5:1)
     
   }
   var infoButton: some View {
     Button(action: {
       showInfo = true
     }) {
       Image(systemName: "info.circle")
         .font(buttFont)
        // .frame(width: buttSize, height: buttSize)
         .cornerRadius(buttRadius)
     }
   }

}
