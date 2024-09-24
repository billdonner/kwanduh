//
//  ScrollableMessageView.swift
//  qandao
//
//  Created by bill donner on 9/9/24.
//

import SwiftUI

import SwiftUI

struct MarqueeMessageView: View {
  @Binding var message: String
  let fadeInDuration: Double
  let fadeOutDuration: Double
  let displayDuration: Double
  
  @State private var isVisible = false
  
  var body: some View {
      ScrollView(.horizontal, showsIndicators: false) {
          Text(message)
          .padding(.horizontal)
              .opacity(isVisible ? 1 : 0)
              .animation(.easeIn(duration: fadeInDuration), value: isVisible)
              .onChange(of: message) { _, newMessage in
                  if !newMessage.isEmpty {
                      // Restart the animation when the message changes
                      withAnimation(Animation.easeIn(duration: fadeInDuration)) {
                          isVisible = true
                      }
                      
                      // Schedule fade-out after displayDuration seconds
                      DispatchQueue.main.asyncAfter(deadline: .now() + displayDuration) {
                          withAnimation(Animation.easeOut(duration: fadeOutDuration)) {
                              isVisible = false
                          }
                          // Set the message to an empty string as soon as fade-out begins
                        withAnimation {
                          message = ""
                        }
                      }
                  }
              }
      }
      .onAppear {
          if !message.isEmpty {
              withAnimation(Animation.easeIn(duration: fadeInDuration)) {
                  isVisible = true
              }
              
              // Schedule fade-out after displayDuration seconds
              DispatchQueue.main.asyncAfter(deadline: .now() + displayDuration) {
                  withAnimation(Animation.easeOut(duration: fadeOutDuration)) {
                      isVisible = false
                  }
                  // Set the message to an empty string immediately when fade-out starts
                withAnimation {
                  message = ""
                }
              }
          }
      }
  }
}

#Preview {
  MarqueeMessageView(
    message: .constant("This message will fade out after a few seconds."),
      fadeInDuration: 1.0,
      fadeOutDuration: 3.0,
      displayDuration: 5.0 // Message stays visible for 5 seconds before fading out
  )
  .frame(height: 50)
  .padding()
    }
