//
//  AlreadyTappedVIew.swift
//  basic
//
//  Created by bill donner on 8/1/24.
//
import SwiftUI

struct AlreadyPlayedView : View {
  
  let ch:Challenge
  let ansinfo:AnsweredInfo
  let gs:GameState
 //
  //let chmgr: ChaMan
  
  @Environment(\.colorScheme) var colorScheme //system light/dark
  @State var showThumbsUp : Challenge? = nil
  @State var showThumbsDown : Challenge? = nil
  
  var thumbsUpButton: some View {
    Button(action: {
      showThumbsUp =  ch
    }){
      Image(systemName: "hand.thumbsup")
        .font(buttFont)
        .cornerRadius(buttRadius)
      //.symbolEffect(.wiggle,isActive: true)
    }
  }
  var thumbsDownButton: some View {
    Button(action: {
      showThumbsDown = ch
    }){
      Image(systemName: "hand.thumbsdown")
        .font(buttFont)
        .cornerRadius(buttRadius)
    }
  }
  func colorsForAnswers(_ answers:[String],correct:String,chosen:String) -> [Color] {
    var colors:[Color] = []
    for a in answers {
      if a == correct {
        colors.append(.green)
      } else if a == chosen {
        colors.append(.red)
      } else {
        colors.append(.white)
      }
    }
    return colors
  }
  
  var body: some View {
    GeometryReader { geometry in
       
        let topicColor =   gs.colorForTopic(ch.topic).0
        VStack {
          Spacer()
          VStack (spacing:30){
            ZStack {
              RoundedRectangle(cornerRadius: 10).foregroundColor(topicColor)
              
              Text(ch.question)
                .font(isIpad ? .largeTitle:.title3)
                .padding()//([.top,.horizontal])
                .lineLimit(8)
                .foregroundColor(foregroundColorFrom( backgroundColor: topicColor))
            }
            ABView(row: ansinfo.row,
                              col: ansinfo.col,
                              answers: ch.answers,
                   colors:colorsForAnswers(ch.answers,correct: ch.correct,chosen: ansinfo.answer),
                              geometry: geometry,
                              colorScheme: colorScheme )
        
            ScrollView {
              VStack (alignment: .leading){
//                HStack{Text ("The correct answer is:").font(.caption);Text(" \(ch.correct)").font(.headline).lineLimit(2);Spacer()}
//                HStack{Text ("Your answer was: ").font(.caption); Text("\(ansinfo.answer)").font(.headline).lineLimit(2);Spacer()}
//       
//                if ch.hint.count<=1 {
//                  Text("There was no hint")
//                } else {
//                  Text ("The hint was: \(ch.hint)")
//                }
                if let exp = ch.explanation,exp.count>1 {
                  Text("\(exp)")
                }
//                else {
 //                 Text ("no explanation was given")
 //               }
                Spacer()
                Text("Played in game \(ansinfo.gamenumber) move \(ansinfo.movenumber) at  (\(ansinfo.row),\(ansinfo.col)) ").font(.footnote)
                Text ("You took \(Int(ansinfo.timetoanswer)) seconds to answer").font(.footnote)
                HStack {
                  Text("id: ");
                  TextField("id", text:.constant("\(ch.id)")).font(.caption)
                  VStack (alignment: .leading){
                    Text ("You answered this question on \(ansinfo.timestamp)").font(.footnote)
                  }
                  Spacer()
                }
                Spacer()
              }
            }.background(Color.gray.opacity(0.2))
          }.padding(.horizontal)
          
            .dismissButton(backgroundColor:foregroundColorFrom( backgroundColor: topicColor))
          //  .border( ansinfo.answer == ch.correct ? .green:.red,width:1)
            .sheet(item:$showThumbsDown) { ch in
              NegativeSentimentView(id: ch.id)
                .dismissable {
                  print("exit from negative sentiment")
                }
            }
            .sheet(item:$showThumbsUp) { ch in
              PositiveSentimentView(id: ch.id)
                .dismissable {
                  print("exit from positive sentiment")
                }
            }
          HStack {
            thumbsUpButton
            Spacer()
            thumbsDownButton
          }.padding()
          Spacer()
        }
    }
    
  }
  
}
#Preview {
  AlreadyPlayedView(ch:Challenge.complexMock, ansinfo: AnsweredInfo.mock,  gs: GameState.mock )
}
