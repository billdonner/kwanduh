//
//  QuestionSectionView.swift
//  kwanduh
//
//  Created by bill donner on 11/28/24.
//


//
//  QuestionSectionView.swift
//  kwanduh
//
//  Created by bill donner on 11/28/24.
//

import SwiftUI

struct QandAQuestionView: View {
    let chmgr: ChaMan
    let gs: GameState
    let geometry: GeometryProxy
    let row: Int
    let col: Int

    var body: some View {
        let paddingWidth = geometry.size.width * 0.1
        let contentWidth = geometry.size.width - paddingWidth
        let ch = chmgr.everyChallenge[gs.board[row][col]]
        let topicColor = gs.topicsinplay[ch.topic]?.toColor() ?? .red

        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(topicColor.opacity(1.0))
            VStack(spacing: 0) {
                QandAButtonRowView(chmgr: chmgr, gs: gs, topicColor: topicColor)
                    .foregroundColor(foregroundColorFrom(backgroundColor: topicColor))
                    .padding([.top, .horizontal])
                    .debugBorder()
                Spacer()
                Text(ch.question)
                    .font(isIpad ? .largeTitle : .title3)
                    .padding(.horizontal)
                    .lineLimit(8)
                    .foregroundColor(foregroundColorFrom(backgroundColor: topicColor))
                    .frame(width: max(0, contentWidth), height: max(0, geometry.size.height * 0.25))
                    .fixedSize(horizontal: false, vertical: true)
                    .debugBorder()
                Spacer()
            }
        }
        .debugBorder()
    }
}
