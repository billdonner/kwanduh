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
  

   var passButton: some View {
     Button(action: {
       killTimer=true
       dismiss()
     }) {
       Image(systemName: "multiply.circle")
         .font(.title)
         .foregroundColor(.white)
         .frame(width: buttSize, height: buttSize)
         .background(Color.gray)
         .cornerRadius(buttRadius)
     }
   }
   var markCorrectButton: some View {
     Button(action: {
       let x = chmgr.everyChallenge[gs.board[row][col]]
       answeredCorrectly(x,row:row,col:col,answered:x.correct)
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
       answeredIncorrectly(x,row:row,col:col,answered:x.correct)
     }) {
       Image(systemName: "xmark.circle")
         .font(buttFont)
        // .frame(width: buttSize, height: buttSize)
         .cornerRadius(buttRadius)
     }
   }

//   var infoButton: some View {
//     Button(action: {
//       showInfo = true
//     }) {
//       Image(systemName: "info.circle")
//         .font(buttFont)
//        // .frame(width: buttSize, height: buttSize)
//         .cornerRadius(buttRadius)
//     }
//   }

}
