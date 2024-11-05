//
//  Page1.swift
//  AllAboard
//
//  Created by bill donner on 11/5/24.
//

import SwiftUI

let totalPages = 9

#Preview {
  OnboardingView(pageIndex: 0)
}

// was OB13
struct Page1: View {
  var body: some View {
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
  }
}
#Preview {
  Page1()
}
//was OB02
struct Page2: View {
  var body: some View {
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
#Preview {
  Page2()
}
//was OB04
struct Page3: View {
  var body: some View {
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
#Preview {
  Page3()
}
// was ob06
struct Page4:View {
  var body: some View {
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
#Preview {
  Page4()
}
// was ob08
struct Page5: View {
  var body: some View {
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
#Preview {
  Page5()
}
//was ob09
struct Page6: View {
  var body: some View {
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
#Preview {
  Page6()
}

//was ob15
struct Page7: View {
  var body: some View {
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
#Preview {
  Page7()
}

//was ob10
struct Page8: View {
  var body: some View {
    Text("You can change topics by clicking on the 'Add' and 'Remove' buttons next to the topics.  Each change costs a 'Gimmee.'  You earn gimmees by winning games. Lose them by losing games.  You can also buy gimmees. The number of gimmees you have is displayed at the top of the screen.")
        .font(.title3)
        .padding(12)

    Image("Topics2")
      .resizable()
      .scaledToFit()
  }
}
#Preview {
  Page8()
}
//was ob14
struct Page9: View {
  var body: some View {
    
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
#Preview {
  Page9()
}


// OnboardingView shows  paginated screens with exit and play options
struct OnboardingView:View {
  let pageIndex:Int
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
      
      Text("Put your own content here. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent interdum tincidunt erat, ut convallis lorem faucibus in.")
        .multilineTextAlignment(.center)
        .padding(.horizontal)
    }
    
  }
  
}

