//
//  DismissableModifier.swift
//  kwanduh
//
//  Created by bill donner on 12/28/24.
//
import SwiftUI

struct DismissableModifier: ViewModifier {
    var onDismiss: () -> Void

    func body(content: Content) -> some View {
        ZStack {
            content
                .onDisappear {
                    onDismiss()
                }
            // Additional layers can be added to the ZStack here if needed
        }
    }
}

extension View {
    func dismissable(onDismiss: @escaping () -> Void) -> some View {
        self.modifier(DismissableModifier(onDismiss: onDismiss))
    }
}
