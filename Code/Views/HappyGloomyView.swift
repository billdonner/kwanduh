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




#Preview ("Happy") {
  HappySmileyView(color: .blue)
    .frame(width: 100, height: 100) // Set the size of the square
}

 
#Preview ("Gloomy"){
  BorderView(color:.red)
    .frame(width: 100, height: 100) // Set the size of the square
}
