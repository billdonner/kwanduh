//
//  MainGridView.swift
//  basic
//
//  Created by bill donner on 7/30/24.
//


import SwiftUI
struct PreviewGridView : View {
  let gs:GameState
  let chmgr:ChaMan
  @Binding var  boardsize: Int
  @Binding var  scheme:ColorSchemeName
  
  var body: some View {
    AltGridView(gs: gs,
                 chmgr: chmgr, 
                 boardsize:boardsize,
                scheme:scheme
    )
  }
}
#Preview ("PreviewGridView") {
  PreviewGridView(gs: GameState.mock,
               chmgr: ChaMan(playData: PlayData.mock),
                  boardsize: .constant(GameState.mock.boardsize),
                  scheme:.constant(2)
     )
  .frame(width: 300,height: 300)
}

struct AltGridView : View {
  let gs:GameState
  let chmgr:ChaMan

  let boardsize: Int
  let scheme: ColorSchemeName
   
  var body: some View {
    let spacing: CGFloat = 1.0 * (isIpad ? 1.2 : 1.0)
    return   GeometryReader { geometry in
      let totalSpacing = spacing * CGFloat(boardsize + 1)
      let axisSize = min(geometry.size.width, geometry.size.height) - totalSpacing
      let cellSize = (axisSize / CGFloat(boardsize)) //* shrinkFactor  // Apply shrink factor
      let colorPreviewValues:[[Color]] = gs.previewColorMatrix(size: boardsize , scheme: scheme)
      VStack(alignment:.center, spacing: spacing) {
        ForEach(0..<boardsize, id: \.self) { row in
          HStack(spacing:0) {
            Spacer(minLength:spacing/2)
            ForEach(0..<boardsize, id: \.self) { col in
              // i keep getting row and col out of bounds, so clamp it
              if row < boardsize  && col < boardsize
              { // ensure its inbounds and allocated
                  let color = colorPreviewValues[row][col]
                  color
                    .frame(width: cellSize, height: cellSize)
                }
                   
              else {
                Color.clear
                  .frame(width: cellSize, height: cellSize)
              }
              Spacer(minLength:spacing/2)
            }
          }
        }
      }
    }
  }
}
struct MainGridView : View {
  @Bindable var  gs:GameState
  let chmgr:ChaMan
//  @Binding var boardsize: Int
  @Binding var firstMove: Bool
  @Binding var isTouching : Bool
  @Binding var marqueeMessage: String
  let onSingleTap: (Int,Int) -> Void
  
  var body: some View {
    let spacing: CGFloat = 1.0 * (isIpad ? 1.2 : 1.0)
    return   GeometryReader { geometry in
      let totalSpacing = spacing * CGFloat(gs.boardsize + 1)
      let axisSize = min(geometry.size.width, geometry.size.height) - totalSpacing
      let cellSize = (axisSize / CGFloat(gs.boardsize)) //* shrinkFactor  // Apply shrink factor
      VStack(alignment:.center, spacing: spacing) {
        ForEach(0..<gs.boardsize, id: \.self) { row in
          HStack(spacing:0) {
            Spacer(minLength:spacing/2)
            ForEach(0..<gs.boardsize, id: \.self) { col in
              // i keep getting row and col out of bounds, so clamp it
              if row < gs.boardsize  && col < gs.boardsize
              //&&  gs.board[row][col] >= 0
              { // ensure its inbounds and allocated
              // if gs.gamestate == .playingNow {
                  SingleCellView(gs:gs,chmgr:chmgr,row:row,col:col,
                                 chidx:gs.board[row][col],
                                 status:gs.cellstate[row][col],
                                 cellSize: cellSize,  onSingleTap:  onSingleTap,firstMove:$firstMove,isTouching:$isTouching,marqueeMessage: $marqueeMessage)
//                } else {
//                  Color.offWhite
//                    .frame(width: cellSize, height: cellSize)
//                }
              }
              else {
                Color.clear
                  .frame(width: cellSize, height: cellSize)
              }
              Spacer(minLength:spacing/2)
            }
          }
        }
      }
    }
  }
}

#Preview ("MainGridView") {
  MainGridView(gs:GameState.mock,
               chmgr: ChaMan(playData: PlayData.mock),
              // boardsize: .constant(GameState.mock.boardsize),
               firstMove: .constant(true),
               isTouching: .constant(false), marqueeMessage: .constant("marquee") ,
               onSingleTap: { row,col in
    print("Tapped cell with challenge \(row) \(col)")
  })
}
