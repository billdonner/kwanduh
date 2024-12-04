import SwiftUI


#Preview {
  
  QandATopBarView(
    gs: GameState.mock,
    topic: "American History running and running to great lengths",
    hint: "What can we say about history?",
    handlePass:{}, handleGimmee: {}, toggleHint: {},
    elapsedTime: .constant(23984923.0),
    killTimer:.constant(false)
  )
}
#Preview ("dark"){
  
  QandATopBarView(
    gs: GameState.mock,
    topic: "American History running and running to great lengths",
    hint: "What can we say about history?",
    handlePass:{}, handleGimmee: {}, toggleHint: {},
    elapsedTime: .constant(23984923.0),
    killTimer:.constant(false)
  )
  .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
