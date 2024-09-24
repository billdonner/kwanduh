import SwiftUI


// MARK: - Views
struct LeaderboardScreen: View {
  let leaderboardService:LeaderboardService

    var body: some View {
        NavigationView {
            VStack {
                HStack {
//                    Button(action: {
//                        leaderboardService.clearScores()
//                    }) {
//                        Text("Clear Leaderboard")
//                            .font(.headline)
//                            .foregroundColor(.red)
//                    }
//                    .padding()

                    Spacer()
                }

                Text("Leaderboard")
                    .font(.largeTitle)
                    .padding()

                List(leaderboardService.scores) { score in
                    HStack {
                        Text(score.playerName)
                        Spacer()
                        Text("\(score.score) pts")
                    }
                }
                .navigationBarTitle("Leaderboard", displayMode: .inline)
//                .navigationBarItems(trailing: NavigationLink(destination: AddScoreView(leaderboardService: leaderboardService)) {
//                    Text("Add Score")
//                })
            }
        }
    }
}


#Preview {
  LeaderboardScreen(leaderboardService: LeaderboardService())
}

