//
//  Page1.swift
//  AllAboard
//
//  Created by bill donner on 11/5/24.
//

import SwiftUI

let totalPages = 16

#Preview {
Page14()
//OuterOnboardingView(isOnboardingComplete: .constant(false))
}

// was OB13
struct Page1: View {
  var body: some View {
    VStack {
      Image("Watermark")  // Name of your watermark image
        .resizable()
        .scaledToFit()
        //.frame(width:300, height:300)
      Text("Do you know enough to win?")
        .font(.title2)
        .bold()
      ScrollView {
        Text("""
In this game where you start in one corner of a grid and have to get to the corner diagonally opposite, a question pops up whenever you touch a square on the board. If you answer the question correctly, you move towards your goal.  If not, you're blocked and you have to find a different way to reach the far corner. Questions come from a stash of 5000, divided into 50 topics.  You choose the topics in your game.

"""
        ).padding()
          .font(.body)
      }

      Text("If you win and how fast depends on how much you know. . .")
        .font(.title2)
        .bold()
        .padding()
      Spacer()
    }
  }
}
#Preview {
  Page1()
}
//was OB02
struct Page2: View {
  var body: some View {
    ZStack {

      VStack {
        Text("How to Play Kwanduh")
          .font(.title2)
          .bold()
          .padding(.vertical, -55)
          .padding(.top, 20)
          .padding(30)

        Image("GameBoard")
          .resizable()
          .scaledToFit()
          .padding(-10)
          .padding(.vertical, -5)
          .padding(.horizontal, 90)

        Text(
          "The Kwanduh game board is a grid of color-coded boxes. Each color represents a different topic."
        )
        .font(.title2)
        .padding(40)
        .padding(.horizontal, -25)
      }
    }
  }
}
#Preview {
  Page2()
}
//was OB11
struct Page3: View {
  var body: some View {
 
      VStack {

        Text("Press on a box and a question related to that topic pops up.")
          .font(.title2)
          .padding(.top, -20)
          .padding(20)
        Image("QuestionAnswer")
          .resizable()
          .scaledToFit()
          .padding(20)
      }
  }
}

#Preview {
  Page3()
}

// was ob40
struct Page4: View {
  var body: some View {
      VStack {

        Text(
          "If you don't like a question, you can ask for another one. Hit the 'Gimme' icon in the upper left corner of the question box."
        )
        .font(.title2)
        .padding(.top, -30)
        .padding(.horizontal, 20)
        Image("PointToGimme")
          .resizable()
          .scaledToFit()
          .padding(10)
      }
  }
}

#Preview {
  Page4()
}
//was ob19
struct Page5: View {
  var body: some View {
 
      VStack {

        Text("What's a 'Gimme'?")
          .font(.title2)
          .padding(20)
          .padding(.top, -40)

        Image(systemName: "arrow.trianglehead.2.clockwise")
          .resizable()
          .frame(width: 65, height: 80)
        Text(
          "A Gimme is a token you can use to win games. For example, you pay a gimme to get a new question."
        )
        .font(.title2)
        Text(
          "You collect gimmes while you play.  The first time you play you are given gimmees to start you off."
        )
        .font(.title2)
      
      }.padding()
  }
}

#Preview {
  Page5()
}

//was ob04
struct Page6: View {
  var body: some View {
 

    VStack (alignment: .center, spacing:0 ) {
      ScrollView {
        
        Text(
          "If you answer the question correctly, a green square is displayed in the box. \n\nIf you answer the question incorrectly, a red square is displayed."
        ).font(.title3)
        
      }
        
        Image("Questions")
          .resizable()
          .scaledToFit()
      
      Spacer(minLength: 100)
    }.padding()
  }
}

#Preview {
  Page6()
}

//was ob06
struct Page7: View {
  var body: some View {
    VStack {
      Spacer()
      Text(
        "Your goal is to create a path of correctly answered questions from one corner of the grid to the corner diagonally opposite."
      ) .font(.title3)
      Spacer()
      HStack{
        VStack {
          Text("Going Up")
            .font(.title2)
          Image("Up")
            .resizable()
            .scaledToFit()
        }
        VStack {
          Text("or Going Down.")
            .font(.title2)
          Image("Down")
            .resizable()
            .scaledToFit()
        }
        
    }
      Spacer()
      }
    }
}

#Preview {
  Page7()
}
//was ob08
struct Page8: View {
  var body: some View {
 

      VStack {
        Text(
          "The path doesn't have to be a straight line as long as it goes from corner to corner."
        )
        .font(.title2)
        .padding(20)
        .padding(.top, 10)

        Image("NotStraight")
          .resizable()
          .scaledToFit()
          .padding(40)
          .padding(.horizontal, 10)

      }
    }
}
#Preview {
  Page8()
}

struct Page9: View {
  var body: some View {
 
      VStack {
        Text("When you are not playing a game, the game board is white.")
          .font(.title2)
          .padding()

        Image("BlankGameboard")
          .resizable()
          .scaledToFit()
          .padding(.vertical, 20)
          .padding(.horizontal, 35)

        Text("To start a game, press 'Play.'")
          .font(.title2)
          .padding()

      }
    }
}

#Preview {
  Page9()
}

struct Page10: View {
  var body: some View {
      VStack {

        Text("If you tap the circular menu icon on the upper right . . .")
          .font(.title2)
          .padding(.top, -30)
          .padding(20)

        Image("MenuPointer")
          .resizable()
          .scaledToFit()
          .padding(20)

        Text(
          "you can select topics, change the size of your game board,choose a different color scheme."
        )
        .font(.title2)
        .padding(.top, 20)

      }
    }
  }

#Preview {
  Page10()
}

struct Page11: View {
  var body: some View {

    ZStack {

      VStack {
        Text(
          "On the Select Topics Screen you increase your odds of winning by choosing topics you know well. You can add and remove topics until you're satisfied."
        )
        .font(.title2)
        .padding(20)

        Image("Topics")
          .resizable()
          .scaledToFit()
          .padding(40)
          .padding(.horizontal, 10)

      }
    }
  }
}
#Preview {
  Page11()
}

struct Page12: View {
  var body: some View {
 
      VStack {
        ScrollView{   Text(
          "Across the top of the screen is a row of colored circles with a topic name beneath each. These are the topics you've currently chosen for your games."
        )
        .font(.title3)
        }
        Image("TopicFeed")
          .resizable()
          .scaledToFit()
          .padding()
        ScrollView {
          Text(
            "The color of each circle matches the color of the boxes on the gameboard with questions about that topic."
          )
          .font(.title3)
        }
        Image("TopicColors")
          .resizable()
          .scaledToFit()
        
        
          Spacer(minLength: 50)

      }
    }
  }

#Preview {
  Page12()
}


struct Page13: View {
  var body: some View {
      VStack {
        ScrollView {
          Text("""
Topics you can add are listed under the 'Available Topics' heading. \n\nTo add a topic, click on the 'Add' button next to the topic. \n\nWhen you add a topic, it appears in the 'Chosen Topics' at the top of the screen. \n\nTo see all your Chosen topics, swipe left on the Chosen Topics.
"""
          ).padding().background(Color.white.opacity(0.1))
        }

        Image("Topics")
          .resizable()
          .scaledToFit()
       
        Spacer()
        ScrollView {
          Text("To remove a topic, click on the circle for that topic.\n\nAdding a topic costs a gimme. Removing one is free.")
        }.padding().background(Color.white.opacity(0.1))
        
      }.padding()
    }
}
#Preview {
  Page13()
}

struct Page14: View {
  var body: some View {
 
    VStack(alignment: .leading,spacing: 20) {
        Image("TopicNumbers")
          .resizable()
          .scaledToFit()
      ScrollView {
        
        Text(
"""
          The number in the center of the circle is the number of questions left in that topic.  Every topic starts with 100 questions.  The same question is never given twice so as you play a certain topic, the number of questions left decreases.\n\nWhen the number of questions reaches 0, the topic will disappear from your screen.\n\nThere must always be enough questions in your chosen topics to assign a question to each box in your gameboard.  If you don't have enough questions, you'll be prompted to add topics or make your board size smaller.
          """
        )
        
      }
    }.font(.title3)
      .padding()
    }
}
#Preview {
  Page14()
}

struct Page15: View {
  var body: some View {
 
    VStack {
      ScrollView {   Text(
        "To change the size of the game board or the color scheme, tap on your preference in the row of options."
      )
      //.font(.title)
      }

        Image("GameBoardSize")
          .resizable()
          .scaledToFit()
        
        
        Image("ColorScheme")
          .resizable()
          .scaledToFit()
     
      
    }.padding()
    }
}
#Preview {
  Page15()
}

struct Page16: View {
  var body: some View {
 

      VStack {

        Image("Watermark")  // Name of your watermark image
          .resizable()
          .scaledToFit()
          .padding(45)
      }
  }
}
#Preview {
  Page16()
}

// OnboardingView shows  paginated screens with exit and play options
struct OnboardingView: View {
  let pageIndex: Int
  var body: some View {

    switch pageIndex {
    case 0: Page1()
    case 1: Page2()
    case 2: Page3()
    case 3: Page4()
    case 4: Page5()
    case 5: Page6()
    case 6: Page7()
    case 7: Page8()
    case 8: Page9()
    case 9: Page10()
    case 10: Page11()
    case 11: Page12()
    case 12: Page13()
    case 13: Page14()
    case 14: Page15()
    case 15: Page16()

    default:
      Image(systemName: "gamecontroller")
        .resizable()
        .scaledToFit()
        .frame(width: 100, height: 100)
        .padding()

      // Display a sample title and description for each onboarding page
      Text("Dummy Feature \(pageIndex + 1)")
        .font(.largeTitle)
        .padding()

      Text(
        "Put your own content here. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent interdum tincidunt erat, ut convallis lorem faucibus in."
      )
      .multilineTextAlignment(.center)
      .padding(.horizontal)
    }

  }

}

struct OuterOnboardingView: View {
  @Binding var isOnboardingComplete: Bool

  @State private var currentPage = 0

  var body: some View {
    ZStack(alignment: .topTrailing) {

      TabView(selection: $currentPage) {
        ForEach(0..<totalPages, id: \.self) { index in
          OnboardingView(pageIndex: currentPage)
         
        }
      }
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
      // Dismiss button in the upper-right corner
            Button(action: {
                isOnboardingComplete = true
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding()
                    .foregroundColor(.gray)
            }
        }
    .background(Color.blue.opacity(0.2).ignoresSafeArea())    }

}

//// Single onboarding page with text, image, and exit/play buttons
///
// Single onboarding page with text, image, and exit/play buttons
//private struct OnboardingPageView: View {
//  //let pageIndex: Int
//  let totalPages: Int
//  @Binding var isOnboardingComplete: Bool
//  @Binding var currentPage: Int
//
//  var body: some View {
//    VStack(spacing: 20) {
//      Spacer()
//
//      OnboardingView(pageIndex: currentPage)
//
//      Spacer()
//
//      // Exit button allows users to skip onboarding
//      HStack {
//        if currentPage == 0 {
//          Button("PLAY") {
//            isOnboardingComplete = true
//          }.buttonStyle(.borderedProminent)
//        } else {
//          Button("Exit") {
//            isOnboardingComplete = true
//          }
//        }
//        Spacer()
//
//        // Display Next button or Play button on the last page
//        if currentPage < totalPages - 1 {
//          Button("Next") {
//            withAnimation {
//              currentPage += 1
//            }
//          }
//          .buttonStyle(.borderedProminent)
//        } else {
//          Button("PLAY") {
//            isOnboardingComplete = true
//          }
//          .buttonStyle(.borderedProminent)
//        }
//      }
//    }
//    .padding()
//    .background(Color(UIColor.systemBackground))
//    .cornerRadius(15)
//    .shadow(radius: 10)
//    .padding(.horizontal)
//  }
//}
//struct OnboardingPageView: View {
//    let pageIndex: Int
//    let totalPages: Int
//    @Binding var isOnboardingComplete: Bool
//    @Binding var currentPage: Int
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Spacer()
//
//            // Display a sample title and description for each onboarding page
//            Text("Game Feature \(pageIndex + 1)")
//                .font(.largeTitle)
//                .padding()
//
//            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent interdum tincidunt erat, ut convallis lorem faucibus in.")
//                .multilineTextAlignment(.center)
//                .padding(.horizontal)
//
//            // Placeholder image
//            Image(systemName: "gamecontroller")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 100, height: 100)
//                .padding()
//
//            Spacer()
//
//            // Exit button allows users to skip onboarding
//            HStack {
//
//                Button("Exit") {
//                    isOnboardingComplete = true
//                }
//                .padding()
//              Spacer()
//
//            // Display Next button or Play button on the last page
//            if pageIndex < totalPages - 1 {
//                Button("Next") {
//                    withAnimation {
//                        currentPage += 1
//                    }
//                }
//                .buttonStyle(.borderedProminent)
//            } else {
//                Button("Play") {
//                    isOnboardingComplete = true
//                }
//                .buttonStyle(.borderedProminent)
//            }
//            }
//        }
//        .padding()
//        .background(Color(UIColor.systemBackground))
//        .cornerRadius(15)
//        .shadow(radius: 10)
//        .padding(.horizontal)
//    }
//}
//struct SampleOnboardingView: View {
//    @Binding var isOnboardingComplete: Bool
//    private let totalPages = 3
//    @State private var currentPage = 0
//
//    var body: some View {
//        VStack {
//            TabView(selection: $currentPage) {
//                ForEach(0..<totalPages, id: \.self) { index in
//                    OnboardingPageView(
//                        pageIndex: index,
//                        totalPages: totalPages,
//                        isOnboardingComplete: $isOnboardingComplete,
//                        currentPage: $currentPage
//                    )
//                }
//            }
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
//        }
//    }
//}
