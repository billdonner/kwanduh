//
//  ContentView.swift
//  kwanna
//
//  Created by bill donner on 10/29/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
   
          GeometryReader { geometry in
              Color.green
                  .edgesIgnoringSafeArea(.all)
                  .overlay(Text("Width: \(geometry.size.width)\nHeight: \(geometry.size.height)")
                              .foregroundColor(.white)
                              .font(.largeTitle))
          }
        } 
  
}

#Preview {
    ContentView()
}
