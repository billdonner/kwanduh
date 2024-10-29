//
//  ContentViewBottomButtons.swift
//  qandao
//
//  Created by bill donner on 8/19/24.
//

import SwiftUI

struct GameScreenBottomButtons : View {
  let gs:GameState
  let chmgr:ChaMan
  
  @Binding   var isTouching:Bool
  @State   var showingHelp = false
  var body: some View {
    HStack {
        Image("GameBoard2")
        .resizable()
          .frame(width: isIpad ? 65 : 45 , height: isIpad ? 65 : 45)
                 .padding(.leading, 8)
                 .gesture( DragGesture(minimumDistance: gs.gamestate == .playingNow ? 0 : 0)//.infinity)
                               .onChanged { _ in
                                  isTouching = true
                               }
                               .onEnded { _ in
                                 isTouching = false
                               }  )
                 .padding(.leading, 20)
                 .padding(10)
      Spacer()
        Text("\(gameTitle) \(AppVersionProvider.appVersion())")
          .font(isIpad ? .headline: .caption2)
      Spacer()
      //Help
      Button(action: {
        showingHelp = true
      }) {
        Image(systemName:"questionmark")
          .font(.title)
          .frame(width: isIpad ? 70 : 50, height: isIpad ? 70 : 50)
                 .padding(.trailing, 15)
      }
    }
    .debugBorder()
      .fullScreenCover(isPresented: $showingHelp ){
        HowToPlayScreen (chmgr: chmgr, isPresented: $showingHelp)
         
      } 
    }
}
 
