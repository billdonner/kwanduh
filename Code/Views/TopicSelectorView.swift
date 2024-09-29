import SwiftUI

struct TopicColor {
    var name: String
    var colorSpec: ColorSpec
}

struct TopicSelectorView: View {
    let allTopics: [String]
    @Binding var selectedTopics: [TopicColor] // Now an array of TopicColor
    @Binding var selectedScheme: ColorSchemeName
    let chmgr: ChaMan
    let gs: GameState
    let minTopics: Int
    let maxTopics: Int
    @Binding var gimms: Int // might change, must be restored on cancel

    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    @State private var oldgimms: Int = 0
    @State private var oldselectedTopics: [TopicColor] = [] // Update here

    // New state variables for alerts
    @State private var showAlert = false
    @State private var selectedAction: ActionType?
    @State private var pendingTopic: TopicColor? // Update here
    
    // Store colors already assigned to selected topics
    @State private var assignedColors: [ColorSpec] = []

    enum ActionType {
        case add, remove
    }

    // Computed property for the color pool based on selected scheme
    private var colorPool: [ColorSpec] {
        // Access colors from the selected scheme in AppColors
      return AppColors.allSchemes[selectedScheme].colors
    }

    var filteredTopics: [String] {
        if searchText.isEmpty {
            return allTopics.filter { !selectedTopics.map { $0.name }.contains($0) }
        } else {
            return allTopics.filter { $0.localizedCaseInsensitiveContains(searchText) && !selectedTopics.map { $0.name }.contains($0) }
        }
    }

    fileprivate func isNotReallyAvailable() -> Bool {
        return gimms <= 0 || selectedTopics.count >= maxTopics
    }

    fileprivate func isNotRemoveable() -> Bool {
        return gimms <= 0 || selectedTopics.count <= minTopics
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Text("You currently have \(gimms) gimmees").font(.footnote)
                
                // Use the computed property for topic names
                TopicIndexView(gs: gs, chmgr: chmgr, inPlayTopics: .constant(selectedTopics.map { $0.name }), scheme: $selectedScheme)

                Form {
                    // Active Topics Section
                    Section(header: HStack {
                        Text("Active Topics")
                        Image(systemName: "info.circle")
                        Spacer()
                        Text("min \(minTopics) \(minTopics == 1 ? "topic" : "topics")").font(.caption2)
                    }) {
                        ForEach(selectedTopics, id: \.name) { topic in
                            HStack {
                                Text(topic.name)
                                    .font(.body)
                                    .foregroundColor(getColor(for: topic)) // Use the assigned color
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        pendingTopic = topic
                                        selectedAction = .remove
                                        removeTopic(topic)
                                    }
                                }) {
                                    Text("remove?")
                                        .font(.footnote)
                                        .foregroundColor(.orange)
                                        .opacity(isNotRemoveable() ? 0.0 : 1.0)
                                }
                            }
                            .disabled(isNotRemoveable())
                            .transition(.slide) // Add transition for removing topics
                        }
                    }

                    // Available Topics Section
                    Section(header: HStack {
                        Text("Available Topics")
                        Spacer()
                        Text("add \(maxTopics - selectedTopics.count) more \(maxTopics - selectedTopics.count == 1 ? "topic" : "topics").")
                    }) {
                        ForEach(filteredTopics, id: \.self) { topic in
                            HStack {
                                Text(topic)
                                    .font(.body)
                                    .foregroundColor(getColor(for: TopicColor(name: topic, colorSpec: ColorSpec(backname: "Default", forename: "Default", backrgb: RGB(red: 255, green: 255, blue: 255), forergb: RGB(red: 0, green: 0, blue: 0))))) // Default ColorSpec for display
                                Spacer()
                                Button(action: {
                                    withAnimation(.easeInOut) {
                                        pendingTopic = TopicColor(name: topic, colorSpec: ColorSpec(backname: "Default", forename: "Default", backrgb: RGB(red: 255, green: 255, blue: 255), forergb: RGB(red: 0, green: 0, blue: 0)))
                                        selectedAction = .add
                                        addTopic(topic)
                                    }
                                }) {
                                    Text("add?")
                                        .font(.footnote)
                                        .foregroundColor(.orange)
                                        .opacity(isNotReallyAvailable() ? 0.0 : 1.0)
                                }
                            }
                            .disabled(isNotReallyAvailable())
                            .transition(.slide) // Add transition for adding topics
                        }
                    }
                }
            }
            .onAppear {
                oldgimms = gimms // save in case we are cancelling
                oldselectedTopics = selectedTopics // Store current state
                assignedColors = Array(repeating: ColorSpec(backname: "Default", forename: "Default", backrgb: RGB(red: 255, green: 255, blue: 255), forergb: RGB(red: 0, green: 0, blue: 0)), count: selectedTopics.count) // Initialize assigned colors as needed
            }
            .navigationTitle("Choose Topics")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    // if cancelling, undo gimms
                    gimms = oldgimms
                    selectedTopics = oldselectedTopics // restore to what we entered with
                    self.presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Done") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
            .onChange(of: gimms) {
                if gimms == 0 {
                    showAlert = true
                }
            }
            .alert(isPresented: $showAlert) {
                getNoGimmeesAlert()
            }
        }
    }

    private func getColor(for topic: TopicColor) -> Color {
        return Color(red: topic.colorSpec.backrgb.red / 255,
                     green: topic.colorSpec.backrgb.green / 255,
                     blue: topic.colorSpec.backrgb.blue / 255)
    }

    private func getNoGimmeesAlert() -> Alert {
        guard let _ = selectedAction, let _ = pendingTopic else {
            return Alert(title: Text("Error"), message: Text("An unexpected error occurred."))
        }

        let title = "You have no Gimmees!"
        let message = "Right now we are giving away some free gimmees every time you finish a game!"

        return Alert(
            title: Text(title),
            message: Text(message),
            primaryButton: .default(Text("OK")) {},
            secondaryButton: .cancel()
        )
    }

    private func addTopic(_ topic: String) {
        if !selectedTopics.map({ $0.name }).contains(topic) && selectedTopics.count < maxTopics {
            // Assign the next available color from the pool
            if let availableColor = colorPool.first(where: { color in !assignedColors.contains(where: { $0.backname == color.backname }) }) {
                let newTopicColor = TopicColor(name: topic, colorSpec: availableColor)
                selectedTopics.append(newTopicColor)
            }
            gimms -= 1
        }
    }

    private func removeTopic(_ topic: TopicColor) {
        if let index = selectedTopics.firstIndex(where: { $0.name == topic.name }) {
            selectedTopics.remove(at: index)
            // Recycle the color by removing it from the assigned colors
            assignedColors.remove(at: index)
        }
        gimms -= 1
    }
}

#Preview {
    TopicSelectorView(allTopics: ["Topic 1", "Topic 2", "Topic 3"],
                      selectedTopics: .constant([TopicColor(name: "Topic 1", colorSpec: ColorSpec(backname: "Default", forename: "Default", backrgb: RGB(red: 255, green: 0, blue: 0), forergb: RGB(red: 255, green: 255, blue: 255)))]),
                      selectedScheme: .constant(ColorSchemeName(0)),
                      chmgr: ChaMan.mock,
                      gs: GameState.mock,
                      minTopics: 1,
                      maxTopics: 9,
                      gimms: .constant(5))
}
