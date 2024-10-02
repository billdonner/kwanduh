//
//  SingleCellView.swift
//  basic
//
//  Created by bill donner on 7/30/24.
//

import SwiftUI

struct CellFormatModifier: ViewModifier {
  let cellSize: CGFloat
  let cornerRadius: CGFloat
  let opacity: Double
  
  func body(content: Content) -> some View {
    content
      .frame(width: cellSize, height: cellSize)
      .cornerRadius(cornerRadius)
      .opacity(opacity)
  }
}

extension View {
  func cellFormat(cellSize: CGFloat, cornerRadius: CGFloat, opacity: Double) -> some View {
    self.modifier(CellFormatModifier(cellSize: cellSize, cornerRadius: cornerRadius, opacity: opacity))
  }
}


struct SingleCellView: View {
  let gs:GameState
  let chmgr:ChaMan
  let row:Int
  let col:Int
  let chidx:Int
  let status:GameCellState
  let cellSize: CGFloat 
  let onSingleTap: (_ row:Int, _ col:Int ) -> Void
  @Binding var firstMove:Bool
  @Binding var isTouching:Bool
  @Binding var marqueeMessage:String
  @Environment(\.colorScheme) var colorScheme //system light/dark
  @State var alreadyPlayed:Sdi?
  
  func playingNowOpacity() -> Double {
    gs.gamestate == .playingNow ? 1.0:1.0//0.7
  }
  
  
  var textbody: some View {
    let challenge = chidx < 0 ? Challenge.amock : chmgr.everyChallenge[chidx]
    let colormix = gs.colorTripleForTopic(challenge.topic)
    return   Text(gs.facedown ? "" : challenge.question)
      .font(isIpad ? .title:.caption)
      .padding(10)
      .frame(width: cellSize, height: cellSize)
      .cornerRadius(cornerradius)
      .background(colormix.0)
      .foregroundColor(foregroundColorFrom( backgroundColor: colormix.0 ))
      .opacity(playingNowOpacity())
  }
  
  var body: some View {
    let thisCellIsLastMove:Bool  = gs.lastmove?.row == row &&  gs.lastmove?.col == col
    let challenge = chidx < 0 ? Challenge.amock : chmgr.everyChallenge[chidx]
   // let colormix = gs.colorForTopic(challenge.topic)
      return  ZStack {
        // part 1:
        // if faceup show the question else blank
        VStack(alignment:.center, spacing:0) {
          if row<gs.boardsize && col<gs.boardsize {
 
              switch gs.cellstate[row][col] {
                
              case .playedCorrectly:
                ZStack {
                  textbody
                  BorderView(color:.green)//colormix.0)
                }
                .cellFormat(cellSize: cellSize, cornerRadius: cornerradius, opacity: playingNowOpacity())
                
              case .playedIncorrectly:
                ZStack {
                  textbody
                  BorderView(color:.red)//colormix.0)
                }
                .cellFormat(cellSize: cellSize, cornerRadius: cornerradius, opacity: playingNowOpacity())
                
              case .unplayed:
                if ( gs.gamestate == .playingNow ) {
                  textbody
                    .cellFormat(cellSize: cellSize, cornerRadius: cornerradius, opacity: playingNowOpacity())
                } else {
                  if  colorScheme == .dark {
                    Color.offBlack
                      .cellFormat(cellSize: cellSize, cornerRadius: cornerradius, opacity: playingNowOpacity())
                  } else {
                    Color.offWhite
                      .cellFormat(cellSize: cellSize, cornerRadius: cornerradius, opacity: playingNowOpacity())
                  }
                }
              }
            }
        }
        //Layer
        // part 3:
        // mark corner of last move with orange circle
        if thisCellIsLastMove && isTouching {
          Circle()
            .fill(Color.orange)
            .frame(width: cellSize/6, height: cellSize/6)
            .offset(x:-cellSize/2 + 10,y:-cellSize/2 + 10)
        }// might have row or col out of whack here
        // mark upper right as well if its been replaced
        
        if row<gs.boardsize && col<gs.boardsize {
          
          // put a symbol in the corner until we play
          if gs.startincorners && gs.gamestate == .playingNow &&  gs.isCornerCell(row: row, col: col) && gs.cellstate [row][col] == .unplayed {
            //Layer
            // let _ = print("at target\(row),\(col)")
            Image(systemName:"target")
              .symbolEffect(.breathe.pulse.byLayer)
              .font(.largeTitle)
              .foregroundColor(
                foregroundColorFrom(backgroundColor:gs.colorTripleForTopic (challenge.topic ).0)).opacity(0.4)
              .frame(width: cellSize, height: cellSize)
          }
          //Layer
          if gs.startincorners && isTouching  { // playing corners
            // only show blue if we are actually in the game
            if gs.gamestate ==  .playingNow && ( ( gs.isCornerCell(row: row, col: col))  ||
                                                 hasAdjacentNeighbor(withStates: [.playedCorrectly,.playedIncorrectly], in: gs.cellstate, for: (row,col)) ){
              Circle()
                .fill(Color.blue)
                .frame(width: cellSize/6, height: cellSize/6)
                .offset(x:cellSize/2 - 7,y:-cellSize/2 + 10)
            }
          }
          if isTouching {
            //Layer
            if gs.replaced[row][col] != [] {
              Circle()
                .fill(Color.neonRed)
                .frame(width: cellSize/6, height: cellSize/6)
                .offset(x:-cellSize/2 + 10,y:cellSize/2 - 10)
            }
            //Layer
            // part 4:
            // nice sfsymbols only until 50
            if gs.moveindex[row][col] == -1 {
              Text("???").font(.footnote).opacity(gs.moveindex[row][col] != -1 ? 1.0:0.0)
            } else
            if gs.moveindex[row][col] > 50 {
              Text("\(gs.moveindex[row][col])").font(.footnote).opacity(gs.moveindex[row][col] != -1 ? 1.0:0.0)
            }
            else {
              //use the sfsymbol // if cell incorrectly played always use white
              Image(systemName:"\(gs.moveindex[row][col]).circle")
                .font(.largeTitle)
                .frame(width: cellSize, height: cellSize)
                .opacity(gs.moveindex[row][col] != -1 ? 0.7:0.0)
                .foregroundColor(colorScheme == .light ? .black : .white )
            }
            //Layer
            // part 5:
            // highlight the winning path with a green checkmark overlays
            if gs.onwinpath[row][col] {
              Image(systemName:"checkmark")
                .font(.largeTitle)
                .frame(width: cellSize, height: cellSize)
                .foregroundColor(.green)
            }
          }
        }// row in bounds
      }
      .fullScreenCover(item: $alreadyPlayed) { goo in
        if let ansinfo = chmgr.ansinfo [challenge.id] {
          AlreadyPlayedView(ch: challenge,ansinfo: ansinfo,  gs:gs)
        }
      }
      // for some unknown reason, the tap surface area is bigger if placed outside the VStack
      .onTapGesture {
        var  tap = false
        /* if already played  present a dffirent view */
        if gs.isAlreadyPlayed(row:row,col:col)  {
          alreadyPlayed = Sdi(row:row,col:col)
        } else
        if  gs.gamestate == .playingNow { // is the game on
          if  gs.cellstate[row][col] == .unplayed {
            // if we've got to start in corner on firstMove
            if gs.startincorners {
              if firstMove{
                tap =  gs.isCornerCell(row: row,col: col)
              } else {
                tap =  gs.isCornerCell(row: row,col: col) ||
                hasAdjacentNeighbor(withStates: [.playedCorrectly,.playedIncorrectly], in: gs.cellstate, for: (row,col))
              }
            }
            else {
              tap = true
            }
          }
        } // actually playing the game
        if tap {
          gs.lastmove =    GameMove(row:row,col:col,movenumber: gs.movenumber)
          firstMove =   false
          onSingleTap(row,col)
        }
        else {
          marqueeMessage = "You need to tap in a corner"
        }
      }
  }// make one cell
}

#Preview ("No Touching",traits:.sizeThatFitsLayout) {
  
  let gs = GameState.mock
  gs.cellstate[0][0] = .playedIncorrectly
  return   SingleCellView(
    gs: GameState.mock,
    chmgr: ChaMan(playData:PlayData.mock),
    row: 0,
    col: 0,
    chidx: 0,
    status: .unplayed,
    cellSize: 250, 
    onSingleTap: { _, _ in },
    firstMove: .constant(false),
    isTouching: .constant(false),
    marqueeMessage: .constant("marquee message")
  )

}

#Preview ("Touching",traits:.sizeThatFitsLayout){
  let gs = GameState.mock
  gs.cellstate[0][0] = .playedCorrectly
  return SingleCellView(
    gs: GameState.mock,
    chmgr: ChaMan(playData:PlayData.mock),
    row: 0,
    col: 0,
    chidx: 0,
    status: .unplayed,
    cellSize: 250,
    onSingleTap: { _, _ in  },
    firstMove: .constant(true),
    isTouching: .constant(true),
    marqueeMessage: .constant("marquee message")
  )
 
}
