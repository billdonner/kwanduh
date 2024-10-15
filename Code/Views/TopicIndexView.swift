//
//  TopicIndexView.swift
//  dmangler
//
//  Created by bill donner on 10/5/24.
//
 
import SwiftUI


struct TopicIndexView: View {
  let gs: GameState
  let chmgr: ChaMan
    // Binding to the temporary selected topics
  @Binding var  selectedTopics: [String: FreeportColor]

  @Environment(\.colorScheme) var cs //system light/dark
    var body: some View {
     // let _ = print(selectedTopics)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
              ForEach(selectedTopics.keys.sorted(), id: \.self) { topic in
               // let _ = print("**",topic)
                if let colorEnum = selectedTopics[topic] {
                //  let _ = print("colorenum:",colorEnum)
//                  if   let topicidx = chmgr.everyTopicName.firstIndex(where: { $0 == topic }) {
                  //  let _ = print("topicidx:",topicidx)
                    VStack(spacing:0) {
                      let x = chmgr.tinfo[topic]?.freecount ?? 0
                      let pct = Double(x) / 200.0// for now Double(dmangler.allCounts.max()!)
                      let backColor = ColorManager.backgroundColor(for: colorEnum)
                      
                      HighWaterMarkCircleView(text:"\(x)", percentage: pct,
                                              size: 40, color: backColor)
                      
                      Text(topic)
                        .lineLimit(3)
                        .frame(width: 70, height: 40)
                        .foregroundColor(cs == .dark ? .white : .black)
                    }
                  }
                }
            }
            .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
        }.background(Color.gray.opacity(0.4))
    }
}
struct TopicIndexView_Previews: PreviewProvider {
    static var previews: some View {
     
        // Example selected topics
@State var  selectedTopics:[String:FreeportColor] = [
          "Topic1": .myNavy,
          "Topic2": .myAqua,
          "Topic3": .myMossGreen,
          "Topic4": .myGoldenYellow,
          "Topic5": .myHotPink
        ]

      return TopicIndexView(gs:GameState.mock,chmgr:ChaMan.mock, selectedTopics:$selectedTopics)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Topic Index View")
            .environment(\.colorScheme, .light)  // Test dark mode with .dark if needed
    }
}
