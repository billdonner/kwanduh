import SwiftUI

struct Tdi: Identifiable {
    let name: String
    let id = UUID()
}

struct TopicIndexView: View {
    let gs: GameState
    let chmgr: ChaMan
    @Binding var inPlayTopics:[String]
    @Binding var scheme: ColorSchemeName
  
    @Environment(\.colorScheme) var colorScheme // System light/dark
    @State var succ = false
    @State var topicDetailInfo: Tdi? = nil
  

  var body: some View {
    VStack (alignment:.center){
      ScrollView(.horizontal, showsIndicators: false)  {
        HStack  {
          
          Image(systemName: "arrow.left.to.line").font(.footnote).opacity(0.3)
          ForEach(inPlayTopics.map {BasicTopic(name: $0)}, id: \.name) { topic in
            HStack {
              RoundedRectangle(cornerSize: CGSize(width: 10.0, height: 3.0))
                .frame(width: isIpad ? 40 : 25, height: isIpad ? 40 : 25)
                .foregroundStyle(gs.colorForTopic(topic.name,within:inPlayTopics).0)
              Text(truncatedText(topic.name, count: isIpad ? 60 : 30))
                .lineLimit(1)
                .font(isIpad ? .title : .body)
                .foregroundColor(textColor)
            }
            .padding(.horizontal, isIpad ? 8 : 4)
            .background(Color.clear)
            //.cornerRadius(8)
            .onTapGesture {
              topicDetailInfo = Tdi(name: topic.name)
            }
          }
          
          Image(systemName: "arrow.right.to.line").font(.footnote).opacity(0.3)
        }
        .padding(4)
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
      }
      .fullScreenCover(item: $topicDetailInfo) { tdi in
        TopicDetailsView(topic: tdi.name, gs: gs, chmgr: chmgr,colortrip:gs.colorForTopic(tdi.name,within:inPlayTopics))
      }
      .debugBorder()
    }
  }
    // Computed properties for background and text colors
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(white: 0.2) : Color(white: 0.96)
    }
    private var textColor: Color {
        colorScheme == .dark ? Color.white : Color.black
    }
}

// Assuming you have the ChaMan and colorSchemes to preview the view
struct TopicIndexView_Previews: PreviewProvider {
    static var previews: some View {
        TopicIndexView(
          gs: GameState.mock,
            chmgr: ChaMan.mock,
            inPlayTopics:.constant( ["a","b","c"]),
          scheme: .constant(2)
        )
    }
}
