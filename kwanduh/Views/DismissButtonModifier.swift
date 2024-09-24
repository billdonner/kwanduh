//
//  DismissButtonModifier.swift
//  qandao
//
//  Created by bill donner on 9/20/24.
//

import SwiftUI

struct DismissButtonModifier: ViewModifier {
    @Environment(\.dismiss) var dismiss
    var backgroundColor: Color
    
    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(appropriateForegroundColor(for: backgroundColor))
                            .padding()
                    }
                }
                Spacer()
            }
        }
    }
    
    // Function to determine the appropriate foreground color based on the luminance of the background
    private func appropriateForegroundColor(for backgroundColor: Color) -> Color {
        let uiColor = UIColor(backgroundColor)
        var white: CGFloat = 0
        uiColor.getWhite(&white, alpha: nil)
        
        // If luminance is less than 0.5, use white for dark backgrounds, else use black
        return white < 0.5 ? Color.white : Color.black
    }
}

extension View {
    // Allow applying the modifier easily
    func dismissButton(backgroundColor: Color) -> some View {
        self.modifier(DismissButtonModifier(backgroundColor: backgroundColor))
    }
}
