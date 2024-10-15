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
  @State   var showCommentsMaker = false
  var body: some View {

    
    HStack {
     Image(systemName:gs.startincorners ? "skew" : "character.duployan")
          .font(.title)
         // .foregroundColor(.accent)
          .frame(width: isIpad ? 70 : 50 , height: isIpad ? 70 : 50)
                 .padding(.leading, 15)
                 .gesture( DragGesture(minimumDistance: gs.gamestate == .playingNow ? 0 : .infinity)
                               .onChanged { _ in
                                  isTouching = true
                               }
                               .onEnded { _ in
                                 isTouching = false
                               }  )
      Spacer()
      Button (action:{  showCommentsMaker.toggle() }) {
        Text("\(gameTitle) \(AppVersionProvider.appVersion())")
          .font(isIpad ? .headline: .caption2)
        }.sheet(isPresented:$showCommentsMaker){
         // CommentsView()
        }
      Spacer()
      //Help
      Button(action: { 
        showingHelp = true
      }) {
        Image(systemName:"questionmark")
          .font(.headline)
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
 
