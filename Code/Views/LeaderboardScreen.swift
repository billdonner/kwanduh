import SwiftUI


// MARK: - Views
struct LeaderboardScreen: View {
  let leaderboardService:LeaderboardService
//  var button: some View {
//    Button( action: {}, label: { Image(systemName: "x.circle")})
//  }
//  
    var body: some View {
     ZStack{
       DismissButtonView()
            VStack {

                Text("Leaderboard")
                .font(.custom(mainFont,size:mainFontSize))
                    .padding()

                List(leaderboardService.scores) { score in
                    HStack {
                        Text(score.playerName)
                        Spacer()
                        Text("\(score.score) pts")
                    }
                }
              //  .navigationBarTitle("Leaderboard", displayMode: .inline)
//                .navigationBarItems(trailing: NavigationLink(destination: AddScoreView(leaderboardService: leaderboardService)) {
//                    Text("Add Score")
//                })
           //     .navigationBarItems(trailing: )
            }
        }
    }
}


#Preview {
  LeaderboardScreen(leaderboardService: LeaderboardService())
}

