//
//  HappyGloomyView.swift
//  qandao
//
//  Created by bill donner on 8/19/24.
//

import SwiftUI
struct HappySmileyView : View {
  let color:Color
  @Environment(\.colorScheme) var colorScheme //system light/dark
  var body: some View {
    ZStack {
      colorScheme == .dark ? Color.offBlack : Color.offWhite
      Circle().foregroundStyle(color)
    }
  }
}


struct BorderView: View {
    let color: Color
    let fudge = 4.0
    let lineWidth: CGFloat = 5.0
    @Environment(\.colorScheme) var colorScheme // system light/dark
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Black background
              colorScheme == .dark ? Color.offBlack : Color.offWhite
              //Color.clear
                // Diagonal lines forming an inside border
              Path { path in
                  let size = geometry.size
                  let adjustedFudge = fudge + lineWidth / 2
                  
                  path.move(to: CGPoint(x: adjustedFudge, y: adjustedFudge)) // Top-left corner
                  path.addLine(to: CGPoint(x: size.width - adjustedFudge, y: adjustedFudge)) // Top-right corner
                  path.addLine(to: CGPoint(x: size.width - adjustedFudge, y: size.height - adjustedFudge)) // Bottom-right corner
                  path.addLine(to: CGPoint(x: adjustedFudge, y: size.height - adjustedFudge)) // Bottom-left corner
                  path.closeSubpath() // Closes the path to form the square
              }
                .stroke(color, lineWidth: lineWidth)
            }
        }
    }
}

#Preview ("Happy") {
  HappySmileyView(color: .blue)
    .frame(width: 100, height: 100) // Set the size of the square
}

 
#Preview ("Gloomy"){
  BorderView(color:.red)
    .frame(width: 100, height: 100) // Set the size of the square
}
