//
//  OnboardingView.swift
//  AllAboard
//
//  Created by bill donner on 11/5/24.
//

import SwiftUI


// Single onboarding page with text, image, and exit/play buttons
fileprivate struct OnboardingPageView: View {
    let pageIndex: Int
    let totalPages: Int
    @Binding var isOnboardingComplete: Bool
    @Binding var currentPage: Int

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
          OnboardingView(pageIndex:pageIndex)
            
            Spacer()
            
            // Exit button allows users to skip onboarding
            HStack {
          
                Button("Exit") {
                    isOnboardingComplete = true
                }
                .padding()
              Spacer()
            
            // Display Next button or Play button on the last page
            if pageIndex < totalPages - 1 {
                Button("Next") {
                    withAnimation {
                        currentPage += 1
                    }
                }
                .buttonStyle(.borderedProminent)
            } else {
                Button("Play") {
                    isOnboardingComplete = true
                }
                .buttonStyle(.borderedProminent)
            }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding(.horizontal)
    }
}
struct InnerOnboardingView: View {
    @Binding var isOnboardingComplete: Bool

    @State private var currentPage = 0

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<totalPages, id: \.self) { index in
                   OnboardingPageView(
                        pageIndex: index,
                        totalPages: totalPages,
                        isOnboardingComplete: $isOnboardingComplete,
                        currentPage: $currentPage
                    )
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}

//// Single onboarding page with text, image, and exit/play buttons
//struct OnboardingPageView: View {
//    let pageIndex: Int
//    let totalPages: Int
//    @Binding var isOnboardingComplete: Bool
//    @Binding var currentPage: Int
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Spacer()
//            
//            // Display a sample title and description for each onboarding page
//            Text("Game Feature \(pageIndex + 1)")
//                .font(.largeTitle)
//                .padding()
//            
//            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent interdum tincidunt erat, ut convallis lorem faucibus in.")
//                .multilineTextAlignment(.center)
//                .padding(.horizontal)
//            
//            // Placeholder image
//            Image(systemName: "gamecontroller")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 100, height: 100)
//                .padding()
//            
//            Spacer()
//            
//            // Exit button allows users to skip onboarding
//            HStack {
//          
//                Button("Exit") {
//                    isOnboardingComplete = true
//                }
//                .padding()
//              Spacer()
//            
//            // Display Next button or Play button on the last page
//            if pageIndex < totalPages - 1 {
//                Button("Next") {
//                    withAnimation {
//                        currentPage += 1
//                    }
//                }
//                .buttonStyle(.borderedProminent)
//            } else {
//                Button("Play") {
//                    isOnboardingComplete = true
//                }
//                .buttonStyle(.borderedProminent)
//            }
//            }
//        }
//        .padding()
//        .background(Color(UIColor.systemBackground))
//        .cornerRadius(15)
//        .shadow(radius: 10)
//        .padding(.horizontal)
//    }
//}
//struct SampleOnboardingView: View {
//    @Binding var isOnboardingComplete: Bool
//    private let totalPages = 3
//    @State private var currentPage = 0
//
//    var body: some View {
//        VStack {
//            TabView(selection: $currentPage) {
//                ForEach(0..<totalPages, id: \.self) { index in
//                    OnboardingPageView(
//                        pageIndex: index,
//                        totalPages: totalPages,
//                        isOnboardingComplete: $isOnboardingComplete,
//                        currentPage: $currentPage
//                    )
//                }
//            }
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
//        }
//    }
//}
