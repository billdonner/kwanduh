//
//  TopicIndexView.swift
//  dmangler
//
//  Created by bill donner on 10/5/24.
//
 
import SwiftUI
enum TopIndexOp {
  case showDetails
  case removeTopic
}
struct IdentifiableString : Identifiable {
  let id = UUID()
  let value: String
  let op: TopIndexOp
}
struct TopicIndexView: View {
  let gs: GameState
  let chmgr: ChaMan
    // Binding to the temporary selected topics
  @Binding var  selectedTopics: [String: FreeportColor] 
  let opType: TopIndexOp
  @Binding var isTouching: Bool
  @State var presentTopic: IdentifiableString? = nil

  @Environment(\.colorScheme) var cs //system light/dark
  var body: some View {
    VStack {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 16) {
        //cause insertion on the left
        ForEach(selectedTopics.keys.sorted(by: > ), id: \.self) { topic in
          // let _ = print("**",topic)
          if let colorEnum = selectedTopics[topic] {
            VStack(spacing:0) {
              let x = chmgr.tinfo[topic]?.freecount ?? 0
              let y = chmgr.tinfo[topic]?.alloccount ?? 1
              let pct = Double(x) / Double(y)// for now Double(dmangler.allCounts.max()!)
              let backColor = ColorManager.backgroundColor(for: colorEnum)
               
                
                HighWaterMarkCircleView(text:"\(x)", percentage: pct,
                                        size: 40, color: backColor, plainTopicIndex: plainTopicIndex,isTouching:$isTouching)
              
              .onTapGesture {
                switch opType {
                case .removeTopic:
                  withAnimation(.easeInOut) { 
                    removeThisTopic(topic)
                  }
                  
                case .showDetails :
                  presentTopic = IdentifiableString(value: topic,op:.showDetails)
                  
                }
              }
                
                Text(topic)
                
                .font(.footnote)
                  .lineLimit(3)
                  .frame(width: 60, height: 50)
                  .foregroundColor(cs == .dark ? .white : .black)
              }
            }
          }
        .padding(EdgeInsets(top: 5, leading: 2, bottom: 5, trailing: 2))
      }
      .sheet(item: $presentTopic) { s in
        if let freeportColor = gs.topicsinplay[s.value] {
          let bkg = freeportColor.toColor()
          TopicDetailsView(topic: s.value, gs: gs, chmgr: chmgr , background:bkg ,
                           foreground: contrastingTextColor(for: colorToRGB(color: bkg)))
        } else {
          Color.red
        }
      }
        }.background(cs == .dark ? Color.offBlack : .offWhite)
    }
  }
  
  func removeThisTopic(_ topic:String) {
       selectedTopics.removeValue(forKey: topic)
      
      }
}
struct TopicIndexView_Previews: PreviewProvider {
    static var previews: some View {
     
        // Example selected topics
@State var  selectedTopics:[String:FreeportColor] = [
          "Topic1": .myNavy,
          "Topic2 is long": .myAqua,
          "Topic3hasnotspaces": .myMossGreen,
          "Topic4": .myGoldenYellow,
          "Topic5": .myHotPink
        ]

      return TopicIndexView(gs:GameState.mock,chmgr:ChaMan.mock, selectedTopics:$selectedTopics, opType: .showDetails, isTouching: .constant(true))
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Topic Index View")
            .environment(\.colorScheme, .light)  // Test dark mode with .dark if needed
    }
}
