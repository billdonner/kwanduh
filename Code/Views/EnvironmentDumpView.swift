//
//  ContentView 2.swift
//  kwanduh
//
//  Created by bill donner on 10/3/24.
//

import SwiftUI

struct EnvironmentDumpView: View {
    var body: some View {
        VStack {
            Text("Environment Variables")
                .font(.headline)
                .padding()

            List {
                ForEach(ProcessInfo.processInfo.environment.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    HStack {
                        Text(key)
                            .fontWeight(.bold)
                        Spacer()
                        Text(value)
                            .foregroundColor(.gray)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding()
    }
}
