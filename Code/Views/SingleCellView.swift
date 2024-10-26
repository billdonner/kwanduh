//
//  SingleCellView.swift
//  basic
//
//  Created by bill donner on 7/30/24.
//

import SwiftUI

struct SingleCellViewModifier: ViewModifier {
  let cellSize: CGFloat
  let cornerRadius: CGFloat
  let opacity: Double
  
  func body(content: Content) -> some View {
    content
      .frame(width: cellSize, height: cellSize)
    //  .cornerRadius(cornerRadius)
      .opacity(opacity)
  }
}

extension View {
  func cellFormat(cellSize: CGFloat, cornerRadius: CGFloat, opacity: Double) -> some View {
    self.modifier(SingleCellViewModifier(cellSize: cellSize, cornerRadius: cornerRadius, opacity: opacity))
  }
}


struct SingleCellView: View {
  @Bindable var gs:GameState
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
    let colormix =  gs.topicsinplay[challenge.topic]?.toColor() ?? .red
    return   Text("")//challenge.question)
      .font(isIpad ? .title:.caption)
      .padding(10)
      .frame(width: cellSize, height: cellSize)
      .cornerRadius(cornerradius)
      .background(colormix)
      .foregroundColor(foregroundColorFrom( backgroundColor: colormix ))
      .opacity(playingNowOpacity())
  }
  
  
  var bottomLayer: some View {
    VStack(alignment:.center, spacing:0) {
      switch gs.cellstate[row][col] {
      case .playedCorrectly:
        ZStack {
          textbody
          BorderView(color:.green)
        }
        .cellFormat(cellSize: cellSize, cornerRadius: cornerradius, opacity: playingNowOpacity())
      case .playedIncorrectly:
        ZStack {
          textbody
          BorderView(color:.red)
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
  
  var body: some View {
    
    let moveIndex = gs.moveindex[row][col]
    let onWinningPath = gs.onwinpath[row][col]
    
    let isLastMove: Bool = gs.lastmove?.row == row && gs.lastmove?.col == col && isTouching
    let inBounds = row < gs.boardsize && col < gs.boardsize
    let challenge = (chidx < 0) ? Challenge.amock : chmgr.everyChallenge[chidx]

    let isPlayingNow = gs.gamestate == .playingNow
    let isCornerCell = gs.isCornerCell(row: row, col: col)
    let hasNeighbors = hasAdjacentNeighbor(withStates: [.playedCorrectly, .playedIncorrectly], in: gs.cellstate, for: (row, col))

    let showBlue = isPlayingNow && (isCornerCell || hasNeighbors)
    let showRed = !gs.replaced[row][col].isEmpty
    let topicColor = gs.topicsinplay[challenge.topic]?.toColor() ?? .red
    let needsTarget = isPlayingNow && isCornerCell && gs.cellstate[row][col] == .unplayed

    return  ZStack {
      // might have row or col out of whack here
      if inBounds {
        //Bottom Layer is the question(not used) and its background
        bottomLayer
        
        // mark corner of last move with orange circle
        if isLastMove {
          Circle()
            .fill(Color.orange)
            .frame(width: cellSize/6, height: cellSize/6)
            .offset(x:-cellSize/2 + 10,y:-cellSize/2 + 10)
        }
        // mark upper right as well if its been replaced
        // put a symbol in the corner until we play
        if needsTarget {
          Image(systemName:"target")
            .symbolEffect(.breathe.pulse.byLayer)
            .font(.largeTitle)
            .foregroundColor(
              foregroundColorFrom(backgroundColor:topicColor.opacity(0.4)))
            .frame(width: cellSize, height: cellSize)
        }
        
        //Layers only show if User touching the Grid Button
        if  isTouching  { // playing corners
          // only show blue if we are actually in the game
          if showBlue {
            Circle()
              .fill(Color.blue)
              .frame(width: cellSize/6, height: cellSize/6)
              .offset(x:cellSize/2 - 7,y:-cellSize/2 + 10)
          }
          
          //Layer
          if showRed {
            Circle()
              .fill(Color.neonRed)
              .frame(width: cellSize/6, height: cellSize/6)
              .offset(x:-cellSize/2 + 10,y:cellSize/2 - 10)
          }
          
          //Layer
          // part 4:
          // nice sfsymbols only until 50
          switch moveIndex {
          case -1 :   Text("???").font(.footnote).opacity(moveIndex != -1 ? 1.0:0.0)
          case 0...50 :
            //use the sfsymbol // if cell incorrectly played always use white
            Image(systemName:"\(moveIndex).circle")
              .font(.largeTitle)
              .frame(width: cellSize, height: cellSize)
              .opacity(moveIndex != -1 ? 0.7:0.0)
              .foregroundColor(colorScheme == .light ? .black : .white )
          default:
            Text("\(moveIndex)").font(.footnote).opacity(moveIndex != -1 ? 1.0:0.0)
          }
          
          //Layer
          // part 5:
          // highlight the winning path with a green checkmark overlays
          if onWinningPath {
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
        ReplayingScreen(ch: challenge,ansinfo: ansinfo,  gs:gs)
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
            if firstMove{
              tap =  gs.isCornerCell(row: row,col: col)
            } else {
              tap =  gs.isCornerCell(row: row,col: col) ||
              hasAdjacentNeighbor(withStates: [.playedCorrectly,.playedIncorrectly], in: gs.cellstate, for: (row,col))
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
