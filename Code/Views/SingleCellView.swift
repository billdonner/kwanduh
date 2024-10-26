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
    func cellFormat(cellSize: CGFloat, cornerRadius: CGFloat, opacity: Double) -> some View {
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
    @Binding var firstMove: Bool
    @Binding var isTouching: Bool
    @Binding var marqueeMessage: String
    @Environment(\.colorScheme) var colorScheme
    @State var alreadyPlayed: Sdi?

  private var showBlue: Bool {
      gs.gamestate == .playingNow && (gs.isCornerCell(row: row, col: col) || hasAdjacentNeighbor(withStates: [.playedCorrectly, .playedIncorrectly], in: gs.cellstate, for: (row, col)))
  }

  private var showRed: Bool {
      !gs.replaced[row][col].isEmpty
  }

    private var isLastMove: Bool {
        gs.lastmove?.row == row && gs.lastmove?.col == col && isTouching
    }

    private var needsTarget: Bool {
    gs.gamestate == .playingNow && gs.isCornerCell(row: row, col: col) && gs.cellstate[row][col] == .unplayed
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
            if showBlue {
                Circle()
                    .fill(Color.blue)
                    .frame(width: cellSize / 6, height: cellSize / 6)
                    .offset(x: cellSize / 2 - 7, y: -cellSize / 2 + 10)
            }

            if showRed {
                Circle()
                    .fill(Color.neonRed)
                    .frame(width: cellSize / 6, height: cellSize / 6)
                    .offset(x: -cellSize / 2 + 10, y: cellSize / 2 - 10)
            }

            moveIndicator()

            if gs.onwinpath[row][col] {
                Image(systemName: "checkmark")
                    .font(.largeTitle)
                    .frame(width: cellSize, height: cellSize)
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

    private func bottomLayer(challenge: Challenge) -> some View {
        
        return VStack(alignment: .center, spacing: 0) {
            switch gs.cellstate[row][col] {
            case .playedCorrectly:
                ZStack {
                    textBody(challenge: challenge)
                    BorderView(color: .green)
                }
                .cellFormat(cellSize: cellSize, cornerRadius: 10, opacity: playingNowOpacity())
            case .playedIncorrectly:
                ZStack {
                    textBody(challenge: challenge)
                    BorderView(color: .red)
                }
                .cellFormat(cellSize: cellSize, cornerRadius: 10, opacity: playingNowOpacity())
            case .unplayed:
                if gs.gamestate == .playingNow {
                    textBody(challenge: challenge)
                        .cellFormat(cellSize: cellSize, cornerRadius: 10, opacity: playingNowOpacity())
                } else {
                 (colorScheme == .dark ? Color.offBlack : Color.offWhite)
                        .cellFormat(cellSize: cellSize, cornerRadius: 10, opacity: playingNowOpacity())
                }
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
        gs.gamestate == .playingNow ? 1.0 : 1.0 // Adjust if needed
    }

    private func handleTap() {
        var tap = false
        if gs.isAlreadyPlayed(row: row, col: col) {
            alreadyPlayed = Sdi(row: row, col: col)
        } else if gs.gamestate == .playingNow, gs.cellstate[row][col] == .unplayed {
            tap = firstMove ? gs.isCornerCell(row: row, col: col) : (gs.isCornerCell(row: row, col: col) || hasAdjacentNeighbor(withStates: [.playedCorrectly, .playedIncorrectly], in: gs.cellstate, for: (row, col)))
        }

        if tap {
            gs.lastmove = GameMove(row: row, col: col, movenumber: gs.movenumber)
            firstMove = false
            onSingleTap(row, col)
        } else {
            marqueeMessage = "You need to tap in a corner"
        }
    }
  
  var body: some View {
      let inBounds = row < gs.boardsize && col < gs.boardsize
      let challenge = (chidx < 0) ? Challenge.amock : chmgr.everyChallenge[chidx]
      
      return ZStack {
          if inBounds {
              bottomLayer(challenge: challenge)
              if isLastMove { lastMoveIndicator() }
            if needsTarget { targetIndicator(challenge: challenge) }
              if isTouching { touchingIndicators() }
          }
      }
      .onTapGesture { handleTap() }
      .fullScreenCover(item: $alreadyPlayed) { goo in
          if let ansinfo = chmgr.ansinfo[challenge.id] {
              ReplayingScreen(ch: challenge, ansinfo: ansinfo, gs: gs)
          }
      }
  }
  
}// make one cell



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
