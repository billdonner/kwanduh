//
//  TimeOutModifier.swift
//  kwanduh
//
//  Created by bill donner on 11/6/24.
//
import SwiftUI

struct TimeoutAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let buttonTitle: String?
    let timeout: TimeInterval // Timeout in seconds
    let fadeOutDuration: TimeInterval // Fade-out duration in seconds
    let onButtonTapped: () -> Void

  @Environment(\.colorScheme) var cs //system light/dark
    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                Color.black.opacity(0.4) // Background overlay
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 16) {
                    // Dismiss Button as "X" in the upper-right corner if buttonTitle is nil
                    HStack {
                        Spacer()
                        if buttonTitle == nil {
                            Button(action: dismissAlert) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.title2)
                            }
                        }
                    }
                    .padding([.top, .trailing], 10)

                    // Alert Title
                    Text(title)
                        .font(.headline)
                        .padding(.top, buttonTitle == nil ? 0 : 10)

                    // Alert Message
                    Text(message)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()

                    // Button or Full Dialog Tap Dismiss
                    if let title = buttonTitle {
                        Button(title) {
                            dismissAlert()
                        }
                        .padding(.bottom)
                    }
                }
                .padding()
                .background(cs == .dark ? Color.black.opacity(0.9) : Color.white) // Background adapts to dark/light mode
                .foregroundColor(Color.primary)
                .cornerRadius(12)
                .shadow(radius: 10)
                .frame(maxWidth: 300)
                .opacity(isPresented ? 0.9 : 0)
                .onAppear {
                    // Start the timeout timer
                  TSLog("Timeout Alert: Starting timeout timer for \(timeout) seconds \(title)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
                        if isPresented {
                            withAnimation(.easeOut(duration: fadeOutDuration)) {
                                dismissAlert()
                              TSLog("Timeout Alert: Dismiss timeout timer for \(timeout) seconds \(title)")
                            }
                        }
                    }
                }
                .transition(.opacity) // Fade-in/out transition
                .onTapGesture {
                    if buttonTitle == nil {
                        dismissAlert() // Dismiss when tapping the dialog if there's no button title
                    }
                }
            }
        }
    }

    // Helper method to dismiss the alert and trigger the onButtonTapped action
    private func dismissAlert() {
        withAnimation(.easeOut(duration: fadeOutDuration)) {
            onButtonTapped()
            isPresented = false
        }
    }
}

// View extension to use the custom alert modifier more easily
extension View {
    func timeoutAlert(isPresented: Binding<Bool>, title: String, message: String, buttonTitle: String? = "OK", timeout: TimeInterval , fadeOutDuration: Double ,
                      onButtonTapped: @escaping () -> Void) -> some View {
        self.modifier(TimeoutAlertModifier(isPresented: isPresented, title: title, message: message, buttonTitle: buttonTitle,
                                           timeout: timeout, fadeOutDuration: fadeOutDuration,
                                           onButtonTapped: onButtonTapped))
    }
}

// Example usage
struct TestModifierView: View {
    @State private var showAlert = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Timeout Alert Example")
                .font(.title)
                .padding()

            Button("Show Timeout Alert") {
                withAnimation {
                    showAlert = true
                }
            }
        }
        .timeoutAlert(
            isPresented: $showAlert,
            title: "Attention",
            message: "This alert will disappear automatically if not dismissed within 5 seconds.",
            buttonTitle: nil, // Specify nil to use the "X" for dismiss
            timeout: 5.0,
            fadeOutDuration: 2.0
        ) {
            print("Alert dismissed")
        }
    }
}

#Preview {
    TestModifierView()
}
