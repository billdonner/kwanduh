//
//  TopicIndexView.swift
//  dmangler
//
//  Created by bill donner on 10/5/24.
//
 
import SwiftUI

struct IdentifiableString : Identifiable {
  let id = UUID()
  let value: String
}
struct TopicIndexView: View {
  let gs: GameState
  let chmgr: ChaMan
    // Binding to the temporary selected topics
  @Binding var  selectedTopics: [String: FreeportColor]
  
  @State var presentTopic: IdentifiableString? = nil

  @Environment(\.colorScheme) var cs //system light/dark
    var body: some View {
     // let _ = print(selectedTopics)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
              ForEach(selectedTopics.keys.sorted(), id: \.self) { topic in
               // let _ = print("**",topic)
                if let colorEnum = selectedTopics[topic] {
                    VStack(spacing:0) {
                      let x = chmgr.tinfo[topic]?.freecount ?? 0
                      let y = chmgr.tinfo[topic]?.alloccount ?? 1
                      let pct = Double(x) / Double(y)// for now Double(dmangler.allCounts.max()!)
                      let backColor = ColorManager.backgroundColor(for: colorEnum)
          
                        
                        HighWaterMarkCircleView(text:"\(x)", percentage: pct,
                                                size: 40, color: backColor)
                   
                      .onTapGesture {
                        presentTopic = IdentifiableString(value: topic)
                      }
                      
                      Text(topic)
                        .lineLimit(3)
                        .frame(width: 50, height: 40)
                        .foregroundColor(cs == .dark ? .white : .black)
                        .font(.footnote)
                    }
                  }
                }
            }
            .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
        }.background(cs == .dark ? Color.offBlack : .offWhite)
        .sheet(item: $presentTopic) { s in
          if let freeportColor = gs.topicsinplay[s.value] {
            let bkg = freeportColor.toColor()
            TopicDetailsView(topic: s.value, gs: gs, chmgr: chmgr , background:bkg ,
                             foreground: contrastingTextColor(for: colorToRGB(color: bkg)))
          } else {
            Color.red
          }
        }
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

      return TopicIndexView(gs:GameState.mock,chmgr:ChaMan.mock, selectedTopics:$selectedTopics)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Topic Index View")
            .environment(\.colorScheme, .light)  // Test dark mode with .dark if needed
    }
}
