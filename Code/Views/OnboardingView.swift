//
//  Page1.swift
//  AllAboard
//
//  Created by bill donner on 11/5/24.
//

import SwiftUI

let totalPages = 16

#Preview {
  OnboardingView(pageIndex:1)
}

// was OB13
struct Page1: View {
  var body: some View {
    Image("Watermark") // Name of your watermark image
      .resizable()
      .scaledToFit()
      .padding(45)
      .padding(.top,-70)
      .padding(.horizontal,40)
    .padding(.bottom,-40)
    Text("Do you know enough to win?")
      .font(.title2)
      .bold()
    //  .padding(0)
      .padding(.horizontal,-150)
      .padding(.vertical, -10)
   //   .padding(.bottom, -30)
    Text("In this game where you start in one corner of a grid and have to get to the corner diagonally opposite, a question pops up whenever you touch a square on the board. If you answer the question correctly, you move towards your goal.  If not, you're blocked and you have to find a different way to reach the far corner. Questions come from a stash of 5000, divided into 50 topics.  You choose the topics in your game.")
      .padding(5)
      .font(.title3)
      .padding(.horizontal,-10)
    //  .padding(.vertical, -40)
  //  .padding(.bottom,30)
    Text("If you win and how fast depends on how much you know. . .")
      .font(.title2)
   //   .padding(-10)
      .padding(.horizontal,-10)
      .padding(.vertical,-10)
      .padding(.bottom,-50)
      .bold()
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
     
     //      Image("GBTitle")
     //      .resizable()
    //     .scaledToFit()
              Text("How to Play Kwanduh")
                  .font(.title2)
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
      
              Text("The Kwanduh game board is a grid of color-coded boxes. Each color represents a different topic.")
                .font(.title2)
                .padding(40)
                .padding(.horizontal, -25)
             //   .padding(.vertical,10)
     
     
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
 
            ZStack {
                VStack {
                    
                    Text("Press on a box and a question related to that topic pops up.")
                        .font(.title2)
                        .padding(.top,-20)
                        .padding(20)
                    
                    
                    
                    Image("QuestionAnswer")
                        .resizable()
                        .scaledToFit()
                        .padding(20)
                    
                    
                    
                    
                }
            }
        }
    }

#Preview {
  Page3()
}

// was ob40
struct Page4: View {
  var body: some View {
      ZStack {
        VStack {
   
            Text("If you don't like a question, you can ask for another one. Hit the 'Gimme' icon in the upper left corner of the question box.")
              .font(.title2)
             .padding(.top,-30)
              .padding(.horizontal,20)
         //     .padding(10)
     

         Image("PointToGimme")
         .resizable()
         .scaledToFit()
        // .padding(.horizontal,40)
         .padding(10)
            

        }
      }
    }
  }

#Preview {
  Page4()
}
//was ob19
struct Page5: View {
  var body: some View {
      ZStack {
        VStack {
            
            Text("What's a 'Gimme'?")
                .font(.title2)
                .padding(20)
                .padding(.top,-40)
            
            Image(systemName: "arrow.trianglehead.2.clockwise")
            .resizable()
            .frame(width: 65, height: 80)
       //     .padding(.top,-20)
        //    .padding()
            
    
            Text("A Gimme is a token you can use to win games. For example, you pay a gimme to get a new question.")
                .font(.title2)
         //       .padding(20)
         //       .padding(.top,-40)
            
            Text("You collect gimmes while you play.  The first time you play you are given gimmees to start you off.")
              .font(.title2)
          //    .padding(.horizontal,20)
              .padding(.vertical,10)
          //    .padding(.top,-20)
            
        //    Text("The first time you play you are given gimmees to start you off.")
        //        .font(.title2)
           //     .padding()
       //         .padding(.leading,-25)

   
        }
      }
    }
  }

#Preview {
  Page5()
}

//was ob04
struct Page6: View {
  var body: some View {
      ZStack {

        VStack {
            Text("If you answer the question correctly, a green square is displayed in the box.")
              .font(.title3)
             .padding(.horizontal,10)
              .padding(.vertical,10)
         //     .padding(25)
            Text("If you answer the question incorrectly, a red square is displayed.")
                  .font(.title3)
                  .padding(.horizontal,10)
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


#Preview {
  Page6()
}

//was ob06
struct Page7: View {
  var body: some View {
      ZStack {
        VStack {
            Text("Your goal is to create a path of correctly answered questions from one corner of the grid to the corner diagonally opposite it.")
                  .font(.title3)
         //     .padding(25)
          //    .padding(.top,10)
            Text("Going Up")
                  .font(.title2)
              .padding(5)
        //      .padding(.top,-10)
            Image("Up")
            .resizable()
            .scaledToFit()
       //     .padding(.horizontal,5)
   
            Text("or Going Down.")
                  .font(.title2)
       //       .padding(0)
            Image("Down")
              .resizable()
              .scaledToFit()
   
     //         .padding(.horizontal,-19)

        }
      }
    }
  }

#Preview {
  Page7()
}
//was ob08
struct Page8: View {
  var body: some View {

        ZStack {

          VStack {
              Text("The path doesn't have to be a straight line as long as it goes from corner to corner.")
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
#Preview {
  Page8()
}


struct Page9: View {
  var body: some View {
    
      ZStack {
        VStack {
            Text("When you are not playing a game, the game board is white.")
                  .font(.title2)
                  .padding()
          
           Image("BlankGameboard")
            .resizable()
            .scaledToFit()
            .padding(.vertical,20)
            .padding(.horizontal,35)
            
            Text("To start a game, press 'Play.'")
                           .font(.title2)
                        .padding()
                    
        }
      }
    }
  }

#Preview {
  Page9()
}

struct Page10: View {
  var body: some View {
      ZStack {
        VStack {
  
            Text("If you tap the circular menu icon on the upper right . . .")
                .font(.title2)
                .padding(.top,-30)
     //           .padding(.horizontal,-15)
                .padding(20)
  
            Image("MenuPointer")
             .resizable()
             .scaledToFit()
         //    .padding(.vertical,-20)
           //  .padding(.horizontal,25)
             .padding(20)

  //          Image(systemName: "ellipsis.circle")
  //              .font(.system(size: 50))
  //              .padding()
            
            
            Text("you can select topics, change the size of your game board,choose a different color scheme.")
                .font(.title2)
      //          .padding(15)
                .padding(.top,20)
            
     //       Text("change the size of your game board, ")
     //           .font(.title2)
         //       .padding()
            //    .padding(.top,-50)
            
   //         Text("choose a different color scheme.")
   //             .font(.title2)
       //         .padding()
   //             .padding(.horizontal,-15)
            
  
            
  
        }
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
            Text("On the Select Topics Screen you increase your odds of winning by choosing topics you know well. You can add and remove topics until you're satisfied.")
                  .font(.title2)
              .padding(20)
       //       .padding(.top, 10)
            
            Image("Topics")
            .resizable()
            .scaledToFit()
            .padding(40)
            .padding(.horizontal,10)
            
        }
      }
    }
  }
#Preview {
  Page11()
}

struct Page12: View {
  var body: some View {
    
      ZStack {
 
        VStack {
            Text("Across the top of the screen is a row of colored circles with a topic name beneath each. These are the topics you've currently chosen for your games.")
                .font(.title3)
    //            .padding(20)
                .padding(.horizontal,-10)
    
            Image("TopicFeed")
              .resizable()
              .scaledToFit()
              .padding(.bottom,10)
  
            
            Text("The color of each circle matches the color of the boxes on the gameboard with questions about that topic.")
                .font(.title3)
    

            
            Image("TopicColors")
              .resizable()
              .scaledToFit()
  
              .padding(.horizontal,-30)
            
   
        }
      }
    }
  }

#Preview {
  Page12()
}

struct Page13: View {
  var body: some View {
    
      ZStack {
 
        VStack {
            Text("Topics you can add are listed under the 'Available Topics' heading. To add a topic, click on the 'Add' button next to the topic. When you add a topic, it appears in the 'Chosen Topics' at the top of the screen. To see all your Chosen topics, swipe left on the Chosen Topics.")
                .font(.title3)
                .padding(.horizontal,10)
       //         .padding(.top,-10)
                .padding(-15)
   
      
            
            Image("Topics")
              .resizable()
              .scaledToFit()
              .padding(20)
      //        .padding(.bottom,-40)
//              .padding(.horizontal,50)
              .padding(.vertical,5)
            
            Text("To remove a topic, click on the circle for that topic.")
                .font(.title3)
                .padding(.top,-20)
                .padding(.leading,-11)
                .padding(.bottom, 5)
            
     
            
            Text("Adding a topic costs a gimme. Removing one is free.")
                .font(.title3)
                .padding(.horizontal,5)
                .padding(.bottom,-50)
        }
      }
    }
  }
#Preview {
  Page13()
}

struct Page14: View {
  var body: some View {
    
      ZStack {

        VStack {
            Image("TopicNumbers")
              .resizable()
              .scaledToFit()
              .padding(-30)
            
            Text("The number in the center of the circle is the number of questions left in that topic.  Every topic starts with 100 questions.  The same question is never given twice so as you play a certain topic, the number of questions left decreases.")
                .font(.title3)
      //          .padding()
                .padding(.top,-120)
                .padding(.horizontal,12)
      //          .padding(.bottom,20)
    
            Text("When the number of questions reaches 0, the topic will disappear from your screen.")
                .font(.title3)
                .padding(.top,5)
                .padding(.bottom,5)
                .padding(.horizontal,10)
            
            Text("There must always be enough questions in your chosen topics to assign a question to each box in your gameboard.  If you don't have enough questions, you'll be prompted to add topics or make your board size smaller.")
                .font(.title3)
                .padding(.horizontal,15)
                .padding(.bottom,-20)
    
     
            

        }
      }
    }
  }
#Preview {
  Page14()
}

struct Page15: View {
  var body: some View {
    
      ZStack {

        VStack {
            Text("To change the size of the game board or the color scheme, tap on your preference in the row of options.")
                  .font(.title3)
              .padding(30)
              .padding(.top,-30)
              .padding(.horizontal,-15)
              .padding(.bottom,-55)
            Image("GameBoardSize")
            .resizable()
            .scaledToFit()
            .padding(0)
            .padding(.vertical,30)
            .padding(.horizontal,-80)
            .padding(.bottom,-20)
            Image("ColorScheme")
            .resizable()
            .scaledToFit()
            .padding(15)
            .padding(.vertical,10)
      //      .padding(.top,-4)
            .padding(.horizontal,-80)
        }
      }
    }
  }
#Preview {
  Page15()
}

struct Page16: View {
  var body: some View {
    
      ZStack {

          VStack {
             
              Image("Watermark") // Name of your watermark image
                  .resizable()
                  .scaledToFit()
                  .padding(45)
          //       .padding(.top,-130)
               //  .padding(.horizontal,90)
              //    .padding(.bottom,-20)
    
      //        Image("Enjoy") // Name of your watermark image
     //             .resizable()
     //             .scaledToFit()
     //             .padding()
     //             .padding(.vertical,-30)
                  
    //          Text("ENJOY")
     //             .font(.title)
   //               .bold()
   //               .padding(.horizontal,0)
   //              .padding(.vertical,-60)
  //               .padding(.bottom,100)
              
//              Text("PLAY")
 //                 .padding(.vertical,-70)
  //                .font(.title)
  //                .bold()
                  
                 
          }
      }
    }
  }
#Preview {
  Page16()
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
      
      Text("Put your own content here. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent interdum tincidunt erat, ut convallis lorem faucibus in.")
        .multilineTextAlignment(.center)
        .padding(.horizontal)
    }
    
  }
  
}

