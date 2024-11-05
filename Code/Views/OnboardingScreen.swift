//
//  Onboarding.swift
//  qview
//
//  Created by bill donner on 6/9/24.
//  Carol Friedman 10/15/24.
//

import SwiftUI

/**
### Panel 1: Welcome & Objective
- **Title:** Welcome to QANDA Game!
- **Content:** Provide a brief overview of the game and its main objective.
 Original:
  - "Welcome to QANDA! In this game, you'll answer trivia questions to connect two diagonal corners on a grid. Answer questions correctly to complete a path from one corner to its opposite corner."
 V2:
 Welcome to QANDAo! To win this game you answer questions from 50 different topics to move from one corner of a grid to another.
 You choose how many topics to include in a game and which topics you want to be questioned on.
*/
 struct OB01: View {
   @Binding var isPresented:Bool
   var body: some View {
     ZStack {
       
       WrappedDismissButton(isPresented: $isPresented)
       VStack {
              Image("Title")
           .resizable()
           .scaledToFit()
         .padding(.vertical,-40)
           .padding(.horizontal,40)
           .padding(.top,-100)
           .padding(3)
           
           Image("Picture")
           .resizable()
           .scaledToFit()
           .padding(-10)
           .padding(.vertical,-30)
           .padding(.horizontal,90)
         
         Text("Welcome to QANDAo! To win this game you answer questions from 50 different topics to move from one corner of a grid to another.")
               .font(.title2)
               .padding(.horizontal,25)
               .padding(.vertical,50)
           .padding(10)
           Text("You choose how many topics to include in a game and which topics you want to be questioned on.")
                 .font(.title2)
                 .padding(.horizontal,50)
                 .padding(.vertical,-10)
             .padding(-30)
       }
     }
     }
}

 /**
### Panel 2: Game Board & Topics
- **Title:** Game Board & Topics
- **Content:** Explain the game board layout and how topics are organized and color-coded.
  Original:
  - "Each game board is a grid of cells with questions inside. Each cell is color-coded by topic. Choose and answer questions in any order, but you must create a continuous path of correct answers from corner to corner!"
  V2:
  The QANDAo gameboard is a grid of color-coded boxes.
  Each color represents a different topic. Press on a box and a question related to that topic will pop up.
  */

struct OB02: View {
  @Binding var isPresented:Bool
  var body: some View {
    ZStack {
      WrappedDismissButton(isPresented: $isPresented)
      VStack {
 
 //      Image("GBTitle")
 //      .resizable()
//     .scaledToFit()
          Text("How to Play kwanduh")
              .font(.title)
              .bold()
          .padding(.vertical,-55)
   //    .padding(.horizontal,30)
       .padding(.top,20)
       .padding(30)
       
       Image("GameBoard")
       .resizable()
       .scaledToFit()
       .padding(-10)
       .padding(.vertical,-5)
       .padding(.horizontal,90)
  
          Text("The QANDAo gameboard is a grid of color-coded boxes.")
            .font(.title2)
            .padding(60)
            .padding(.horizontal, -25)
         //   .padding(.vertical,10)
 
          Text("Each color represents a different topic. Press on a box and a question related to that topic will pop up.")
              .font(.title2)
              .padding(.vertical,-60)
              .padding(20)
        
      }
    }
  }
}


/*
  ### Panel 3: Selecting Topics
- **Title:** Selecting Topics
- **Content:** Explain the topic screen how topics are organized and color-coded.
 Original:
  - "You can choose some topics, but we will choose the others. If you dont like our choices, you can re-roll them once!  We'll pick the colors or you can choose your own"
 V2:
 "'Active Topics' shows the topics you've currently chosen for your games. To see the color assigned to each of those topics, look at the horizontal line at the top of the screen."
 "'Available Topics' shows the topics you can add to your game."
 "To add or delete topics you need to use 'gimmees' which are tokens you earn by winning games. The first time you play you are given gimmees to set your topics."
 */

struct OB03: View {
  @Binding var isPresented:Bool
  var body: some View {
    ZStack {
      WrappedDismissButton(isPresented: $isPresented)
      VStack {
          Text("'Active Topics' shows the topics you've currently chosen for your games. To see the color assigned to each of those topics, look at the horizontal line at the top of the screen.")
          .font(.title3)
          .padding()
        Text("'Available Topics' shows the topics you can add to your game.")
              .font(.title3)         .padding()
          
          Text("To add or delete topics you need to use 'gimmees' which are tokens you earn by winning games. The first time you play you are given gimmees to set your topics.")
                .font(.title3)         .padding()
          Image("Topics2")
            .resizable()
            .scaledToFit()

      }
    }
  }
}

/*

### Panel 4: Answering Questions
- **Title:** Answering Questions
- **Content:** Original:Describe the multiple-choice questions and how to interact with them.
 V2: Describes what happens when player answers question correctly or incorrectly
  - Original:
 "Tap any cell to see a multiple-choice question. Answer correctly to earn a point and mark the cell as correct. Incorrect answers mark the cell as incorrect. You can only move to adjacent cells next."
 V2:
 "If you answer the question correctly, a green square will be displayed in the box."
 "If you answer the question incorrectly, a red square is displayed."
*/

struct OB04: View {
  @Binding var isPresented:Bool
  var body: some View {
    ZStack {
      WrappedDismissButton(isPresented: $isPresented)
      VStack {
          Text("If you answer the question correctly, a green square will be displayed in the box.")
            .font(.title3)
           .padding(.horizontal,6)
            .padding(.vertical,-10)
            .padding(30)
          Text("If you answer the question incorrectly, a red square is displayed.")
                .font(.title3)
                .padding(.horizontal,30)
              //  .padding(.vertical,10)
               // .padding()
          Image("Questions")
          .resizable()
          .scaledToFit()
          .padding(40)
 
      }
    }
  }
}
/*
### Panel 5: Using Gimmees
- **Title:** Using Gimmees
- **Content:** Explain the concept of gimmees and how players can use them.
  - "You start each game with a few gimmees, which let you replace a question. Long-press an unplayed cell to use a gimmee. If you get stuck, gimmees can save the day!"
*/
struct OB05: View {
  @Binding var isPresented:Bool
  var body: some View {
    ZStack {
      WrappedDismissButton(isPresented: $isPresented)
      VStack {
        Image("Gimmees")
          .resizable()
          .scaledToFit()
          .padding()
        Text("Using Gimmees")
          .font(.title)
          .padding()
        Text("You start each game with a few gimmees, which let you replace a question. Long-press an unplayed cell to use a gimmee. If you get stuck, gimmees can save the day!")
          .padding()
      }
    }
  }
}
/*
### Panel 6: Winning & Losing
- **Title:** Winning & Losing
- **Content:** Outline the win and lose conditions.
 Original:
  - "To win, complete a path of correct answers from one corner to the opposite diagonal corner. The game is over if there's no possible winning path and you have no gimmees left."
 V2:
 "Your goal is to create a path of correctly answered questions from one corner of the grid to the corner diagonally opposite it."
 "Going up"
 "or going down."
*/
struct OB06: View {
  @Binding var isPresented:Bool
  var body: some View {
    ZStack {
      WrappedDismissButton(isPresented: $isPresented)
      VStack {
          Text("Your goal is to create a path of correctly answered questions from one corner of the grid to the corner diagonally opposite it.")
                .font(.title2)
            .padding()
            .padding(.top, 40)
          Text("Going up")
                .font(.title2)
            .padding(-5)
          Image("Up")
          .resizable()
          .scaledToFit()
          .padding()
          .padding(.top,10)
          .padding(.horizontal,40)
          Text("or going down.")
                .font(.title2)
            .padding(0)
          Image("Down")
            .resizable()
            .scaledToFit()
            .padding(0)
            .padding(.top,10)
            .padding(.horizontal,86)
      }
    }
  }
}


struct OB08: View {
  @Binding var isPresented:Bool
  var body: some View {
    ZStack {
      WrappedDismissButton(isPresented: $isPresented)
      VStack {
          Text("The path doesn't have to be a straight line as long as it goes from corner to corner")
                .font(.title2)
            .padding(20)
            .padding(.top, 10)
          
          Image("NotStraight")
          .resizable()
          .scaledToFit()
          .padding(40)
          .padding(.horizontal,10)
          
      }
    }
  }
}

/*
### Panel 9: Blank Gameboard
- **Title:**
- **Content:** Explain the Gameboard/screen when a game isn't being played
  - "When you are not playing a game, the gameboard is white. To start a game, press 'Play'."
 "To set topics, tap on the gear icon to get to the Game Settings screen."
 "To set topics, tap on the gear icon to get to the Game Settings screen."
*/
struct OB09: View {
  @Binding var isPresented:Bool
  var body: some View {
    ZStack {
      WrappedDismissButton(isPresented: $isPresented)
      VStack {
          Text("When you are not playing a game, the gameboard is white. To start a game, press 'Play'.")
                .font(.title2)
            .padding(20)
            .padding(.top, 10)
          Text("To set topics, tap on the gear icon to get to the Game Settings screen.")
                .font(.title2)
            .padding(20)
            .padding(.top, 10)
          Image("BlankGameboard")
          .resizable()
          .scaledToFit()
          .padding(40)
          
 
      }
    }
  }
}

/*
### Panel 10: How to change Topics
- **Title:**
- **Content:** Explain how to change topics and gimmees
  - "You can change topics by clicking on the 'Add' and 'Remove' buttons next to the topics.  Each change costs a 'Gimmee.'  You earn gimmees by winning games. Lose them by losing games.  You can also buy gimmees. The number of gimmees you have is displayed at the top of the screen."
*/
struct OB10: View {
  @Binding var isPresented:Bool
  var body: some View {
    ZStack {
      WrappedDismissButton(isPresented: $isPresented)
      VStack {
          Text("You can change topics by clicking on the 'Add' and 'Remove' buttons next to the topics.  Each change costs a 'Gimmee.'  You earn gimmees by winning games. Lose them by losing games.  You can also buy gimmees. The number of gimmees you have is displayed at the top of the screen.")
              .font(.title3)
              .padding(12)
  
          Image("Topics2")
            .resizable()
            .scaledToFit()

      }
    }
  }
}



/*
### Panel 13: First onboarding screen -
- **Title:**
- **Content:** Explain game and intrigue people
  - "Do you know enough to win?"
 "In this game where you start in one corner of a grid and have to get to the corner diagonally opposite it, a question pops up whenever you touch a square on the board. If you answer the question correctly, you move towards your goal.  If not, you're blocked and you have to find a different way to reach the far corner. Questions come from a stash of 5000, divided into 50 topics.  You choose the topics in your game."
 "Whether you win and how fast depends on how much you know. . ."
 "<-  START             MORE INFO  -> "
*/
struct OB13: View {
  @Binding var isPresented:Bool
  @Environment(\.presentationMode) var presentationMode
  var body: some View {
      
    ZStack {
      WrappedDismissButton(isPresented: $isPresented)
        VStack {
           
            Image("Watermark") // Name of your watermark image
                .resizable()
                .scaledToFit()
                .padding(80)
               .padding(.top,-70)
               .padding(.horizontal,25)
         //       .padding(.bottom,-60)
            Text("Do you know enough to win?")
                .font(.title2)
                .bold()
                .padding(0)
               .padding(.horizontal,-150)
               .padding(.vertical, -65)
            Text("In this game where you start in one corner of a grid and have to get to the corner diagonally opposite it, a question pops up whenever you touch a square on the board. If you answer the question correctly, you move towards your goal.  If not, you're blocked and you have to find a different way to reach the far corner. Questions come from a stash of 5000, divided into 50 topics.  You choose the topics in your game.")
                .padding(5)
                .font(.title3)
                .padding(.horizontal,20)
                .padding(.vertical, -40)
           //     .padding(.bottom,50)
               Text("If you win and how fast depends on how much you know. . .")
                .font(.title2)
               .padding(-10)
                .padding(.horizontal,30)
                .padding(.vertical,60)
                .padding(.bottom,-30)
                .bold()
        /*  HStack {
            Button ("<-  START ")
            {
              self.presentationMode.wrappedValue.dismiss()
            }
            Button (" MORE INFO  ->")
            {
              self.selectedTabIndex = 3
            }
          }.font(.title3)
                .bold()
                .padding(0) */
        }
        
    }
  }
}
#Preview {
  OB13(isPresented: .constant(false))
}
/*
### Panel 14: Last onboarding screen -
- **Title:**
- **Content:** Send people to play
  - "Enjoy"
 
 "             START  -> "
*/
struct OB14: View {
  @Binding var isPresented:Bool
  var body: some View {
    ZStack {
      WrappedDismissButton(isPresented: $isPresented)
        VStack {
           
            Image("Watermark") // Name of your watermark image
                .resizable()
                .scaledToFit()
                .padding(110)
               .padding(.top,-130)
             //   .padding(.horizontal,90)
            //    .padding(.bottom,-20)
  
    //        Image("Enjoy") // Name of your watermark image
   //             .resizable()
   //             .scaledToFit()
   //             .padding()
   //             .padding(.vertical,-30)
                
            Text("ENJOY")
                .font(.title)
                .bold()
               .padding(.vertical,-60)
               .padding(.bottom,100)

                
               
        }
    }
  }
}



/*
### Panel 15: The Settings Screen
- **Title:**
- **Content:** Explain how to use the Game Settings screen
  - "On the Settings screen you can set topics and change the size and color scheme of the gameboard."
 "To set topics, tap on 'Edit Topics'."
 "To change the gameboard, tap on your preferred size or color scheme."
 */
struct OB15: View {
  @Binding var isPresented:Bool
  var body: some View {
    ZStack {
      WrappedDismissButton(isPresented: $isPresented)
      VStack {
          Text("On the Settings screen you can set topics and change the size and color scheme of the gameboard.")
                .font(.title2)
            .padding(20)
            .padding(.top, 10)
          Text("To set topics, tap on 'Edit Topics'.  ")
                .font(.title2)
            .padding(-20)
            .padding(.top, 10)
            .padding(.horizontal,-20)
          Text("To change the gameboard, tap on your preferred size or color scheme.  ")
                .font(.title2)
            .padding(20)
            .padding(.top, 10)
          Image("SettingsScreen")
          .resizable()
          .scaledToFit()
          .padding(40)
          
 
      }
    }
  }
}






struct OnboardingScreen: View {
  @Binding var  isPresented: Bool
  // State variable to track the selected tab index
  @State private var selectedTabIndex: Int = 0

  var body: some View {
    VStack (spacing:0){
    TabView(selection:$selectedTabIndex) {
      OB13(isPresented: $isPresented)
        .tag(mkID())
      OB02(isPresented: $isPresented)
        .tag(mkID())
      OB04(isPresented: $isPresented)
        .tag(mkID())
      OB06(isPresented: $isPresented)
        .tag(mkID())
      OB08(isPresented: $isPresented)
        .tag(mkID())
      OB09(isPresented: $isPresented)
        .tag(mkID())
      OB15(isPresented: $isPresented)
        .tag(mkID())
      OB10(isPresented: $isPresented)
        .tag(mkID())
      OB14(isPresented: $isPresented)
        .tag(mkID())
    }
    .background(Color.clear.opacity(1))
    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    Divider()
  }
  }
  
}
#Preview {
  OnboardingScreen(isPresented: .constant(true))
}
/*
### Panel 7: Difficulty Levels & Game Variants
- **Title:** Difficulty & Variants
- **Content:**
 Original: Briefly describe the difficulty settings and game variants.
 V2: Explains that path doesn't have to be straight
  - "Choose your difficulty level: easy, normal, or hard. Experiment with different game variants like 'All Questions Face Up' or 'All Questions Face Down' for extra challenges. Good luck!"
*/
//struct OB07: View {
//    @Binding var isPresented:Bool
//    var body: some View {
//      ZStack {
//        WrappedDismissButton(isPresented: $isPresented)
//        VStack {
//          Image("Onboarding7")
//            .resizable()
//            .scaledToFit()
//            .padding()
//          Text("Difficulty & Variants")
//            .font(.title)
//            .padding()
//          Text("Choose your difficulty level: easy, normal, or hard. Experiment with different game variants like 'All Questions Face Up' or 'All Questions Face Down' for extra challenges. Good luck!")
//            .padding()
//        }
//      }
//    }
//  }
