//
//  SingleCellView.swift
//  basic
//
//  Created by Bill Donner on 7/30/24.
//

import SwiftUI

struct SingleCellViewModifier: ViewModifier {
  let cellSize: CGFloat
  let cornerRadius: CGFloat
  let opacity: Double
  
  func body(content: Content) -> some View {
    content
      .frame(width: cellSize, height: cellSize)
      .opacity(opacity)
  }
}

extension View {
  func singleFormat(cellSize: CGFloat, cornerRadius: CGFloat, opacity: Double) -> some View {
    self.modifier(SingleCellViewModifier(cellSize: cellSize, cornerRadius: cornerRadius, opacity: opacity))
  }
}

struct SingleCellView: View {
  @Bindable var gs: GameState
  let chmgr: ChaMan
  let row: Int
  let col: Int
  let chidx: Int
  let status: GameCellState
  let cellSize: CGFloat
  let onSingleTap: (_ row: Int, _ col: Int) -> Void
  @Binding var isTouching: Bool
  @Environment(\.colorScheme) var colorScheme
  
  private var showBlue: Bool {
    gs.playstate == .playingNow &&
    (gs.isCornerCell(row: row, col: col) ||
     hasAdjacentNeighbor(withStates: [.playedCorrectly, .playedIncorrectly],
                         in: gs.cellstate, for: Coordinate(row: row, col: col)))
  }
  
  private var showRed: Bool {
    !gs.replaced[row][col].isEmpty
  }
  
  private var isLastMove: Bool {
    gs.lastmove?.row == row &&
    gs.lastmove?.col == col
    && isTouching
  }
  
  private func showTargetFor(row:Int,col:Int) -> Bool {
    guard gs.playstate == .playingNow else {
      return false
    }
    guard gs.cellstate[row][col] == .unplayed else {
      return false
    }
    guard let (orow, ocol) = gs.oppositeCornerCell(row: row, col: col) else {
      return false // if not corner dont need target
     }
    guard  gs.movenumber != 0 else {
       return true // this guard must be after we determine its a
     }
    //if the opposite corner is empty or green
    guard
      gs.cellstate[orow][ocol] == .unplayed || gs.cellstate[orow][ocol] ==   .playedCorrectly
                else { return false}

    guard let (lrow, lcol) = gs.lhCornerCell(row: row, col: col) else {
      return false // if not corner dont need target
     }
    guard let (rrow, rcol) = gs.rhCornerCell(row: row, col: col) else {
      return false // if not corner dont need target
     }
    
    let rNeighborState = gs.cellstate[rrow][rcol]
    let lNeighborState = gs.cellstate[lrow][lcol]
    
    switch (rNeighborState,lNeighborState) {
      case(.unplayed, .unplayed):
      return true
      case (.playedIncorrectly, .playedIncorrectly):
      return true
    case (.playedCorrectly, .playedCorrectly):
    return true // needs more thinking
    case (.playedCorrectly, .unplayed):
      return false
      case (.unplayed, .playedCorrectly):
      return false
    case (.playedIncorrectly, .unplayed):
      return true
      case (.unplayed, .playedIncorrectly):
      return true
    case (.playedCorrectly, .playedIncorrectly):
      return true
    case (.playedIncorrectly, .playedCorrectly):
      return true
    case (.blocked, _):
      return false
    case (_, .blocked):
      return false
    }
  }
   
  private func lastMoveIndicator() -> some View {
    Circle()
      .fill(Color.orange)
      .frame(width: cellSize / 6, height: cellSize / 6)
      .offset(x: -cellSize / 2 + 10, y: -cellSize / 2 + 10)
  }
  
  private func targetIndicator(challenge: Challenge) -> some View {
    Image(systemName: "target")
      .symbolEffect(.breathe.pulse.byLayer)
      .font(.largeTitle)
      .foregroundColor(foregroundColorFrom(backgroundColor: gs.topicsinplay[chidx < 0 ? Challenge.amock.topic : challenge.topic]?.toColor() ?? .red).opacity(0.4))
      .frame(width: cellSize, height: cellSize)
  }
  
  private func touchingIndicators() -> some View {
    Group {
      // blue indicates a legal move
      if showBlue {
        Circle()
          .fill(Color.blue)
          .frame(width: cellSize / 6, height: cellSize / 6)
          .offset(x: cellSize / 2 - 7, y: -cellSize / 2 + 10)
      }
      
      if showRed {
        // red indicates challenge was gimmeed in this cell
        Circle()
          .fill(Color.neonRed)
          .frame(width: cellSize / 6, height: cellSize / 6)
          .offset(x: -cellSize / 2 + 10, y: cellSize / 2 - 10)
      }
      
      // show movenumber in a circle in the cell
      moveIndicator()
      
      // show a checkmark if on winning path
     if gs.onwinpath[row][col] {
        Image(systemName: "checkmark")
            .resizable() // Makes the symbol resizable
            .aspectRatio(contentMode: .fit) // Maintains the aspect ratio
            .frame(width: cellSize / 8, height: cellSize / 8 )// Half the cell size
            .offset(x: cellSize / 3 - 1, y: cellSize / 3 - 1)
            .foregroundColor(.green)
     }
    }
  }
  
  
  
  private func moveIndicator() -> some View {
    let moveIndex = gs.moveindex[row][col]
    switch moveIndex {
    case -1:
      return AnyView(Text("???").font(.footnote).opacity(0.0))
    case 0...50:
      return AnyView(Image(systemName: "\(moveIndex).circle")
        .font(.largeTitle)
        .frame(width: cellSize, height: cellSize)
        .opacity(0.7)
        .foregroundColor(colorScheme == .light ? .black : .white))
    default:
      return AnyView(Text("\(moveIndex)").font(.footnote).opacity(1.0))
    }
  }
  
  // basic cell on bottom
  private func bottomLayer(challenge: Challenge) -> some View {
    return VStack(alignment: .center, spacing: 0) {
      switch gs.cellstate[row][col] {
      case .playedCorrectly: 
          textBody(challenge: challenge)
            .border(Color.green,width:Double(9 - gs.boardsize))
          .singleFormat(cellSize: cellSize, cornerRadius: 10, opacity: playingNowOpacity())
      case .playedIncorrectly:
          textBody(challenge: challenge)
            .border(Color.green,width:Double(9 - gs.boardsize))
        .singleFormat(cellSize: cellSize, cornerRadius: 10, opacity: playingNowOpacity())
      case .unplayed:
        if gs.playstate == .playingNow {
          textBody(challenge: challenge)
            .singleFormat(cellSize: cellSize, cornerRadius: 10, opacity: playingNowOpacity())
        } else {
          (colorScheme == .dark ? Color.offBlack : Color.offWhite)
            .singleFormat(cellSize: cellSize, cornerRadius: 10, opacity: playingNowOpacity())
        }
      case .blocked:
        (colorScheme == .light ? Color.offBlack : Color.offWhite)
          .singleFormat(cellSize: cellSize, cornerRadius: 10, opacity: 1.0)
      }
    }
  }
  
  private func textBody(challenge: Challenge) -> some View {
    let colormix = gs.topicsinplay[challenge.topic]?.toColor() ?? .red
    let foregroundcolor = foregroundColorFrom(backgroundColor: colormix)
    
    return Text("") // Replace with challenge.question if needed
      .font(UIScreen.main.bounds.width > 768 ? .title : .caption)
      .padding(10)
      .frame(width: cellSize, height: cellSize)
      .cornerRadius(10)
      .background(colormix)
      .foregroundColor(foregroundcolor)
      .opacity(playingNowOpacity())
  }
  
  private func playingNowOpacity() -> Double {
    gs.playstate == .playingNow ? 1.0 : 0.5// Adjust if needed
  }
  
  private func handleTap()   {
    onSingleTap(row,col)
  }

  var body: some View {
    let inBounds = row < gs.boardsize && col < gs.boardsize
    let challenge = (chidx < 0) ? Challenge.amock : chmgr.everyChallenge[chidx]
    
    return ZStack {
      if inBounds {
        bottomLayer(challenge: challenge)
        if isLastMove { lastMoveIndicator() }
        if showTargetFor(row:row,col:col) { targetIndicator(challenge: challenge) }
        if isTouching || gs.playstate != .playingNow
        { touchingIndicators() }
      }
    }
    .onTapGesture {
      handleTap()
    }
  }
}// make one cell



#Preview ("No Touching",traits:.sizeThatFitsLayout) {
  let gs = GameState.mock
  gs.cellstate[0][0] = .playedCorrectly
 return  SingleCellView(
    gs: gs,
    chmgr: ChaMan(playData:PlayData.mock),
    row: 0,
    col: 0,
    chidx: 0,
    status: .unplayed,
    cellSize: 250,
    onSingleTap: { _, _ in },
    isTouching: .constant(false)
    )
  
}

#Preview ("Touching",traits:.sizeThatFitsLayout){
  let gs = GameState.mock
  gs.cellstate[0][0] = .playedCorrectly
  return SingleCellView(
    gs: gs,
    chmgr: ChaMan(playData:PlayData.mock),
    row: 0,
    col: 0,
    chidx: 0,
    status: .unplayed,
    cellSize: 250,
    onSingleTap: { _, _ in  }, 
    isTouching: .constant(true)
  )
  
}
