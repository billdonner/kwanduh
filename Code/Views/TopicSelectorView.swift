//
//  TopicSelectorView.swift
//  dmangler
//
//  Created by bill donner on 10/5/24.
//


import SwiftUI


let test_allTopics = ["Topic1", "Topic2", "Topic3", "Topic4", "Topic5", "Topic6", "Topic7", "Topic8", "Topic9", "Topic10","Topic11","Topic12","Topic13","Topic14","Topic15","Topic16","Topic17","Topic18","Topic19","Topic20"]
let test_allCounts = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200]
let test_scheme = 1
let test_selected:[String:FreeportColor] = ["Topic1":.myIceBlue]





let minTopicCount = 3
let maxTopicCount = 10

func dumpTopicsAndColors(_ comment:String,from selectedTopics:[String:FreeportColor]) {
  print("---> \(comment)")
  for (topic, color) in selectedTopics {
    print("\(topic) : \(color)")
  }
}

struct TopicSelectorView: View {
  @Bindable var dmangler: Dmangler
  @Binding var  gimmeCount: Int // Gimme count passed as a binding
  
  // Temporary state to handle topic selections
  
  @State private var tempGimmeeCount: Int = 0
  @State private var tempSelectedTopics: [String: FreeportColor] = [:]
  

  // Alert state
  @State private var showNoGimmeeAlert = false
  @State private var showMinimumSelectionAlert = false  // New alert state for minimum selection
  @State private var showMaximumSelectionAlert = false  // New alert state for maximum selection
  
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    NavigationView {
      VStack {
        // Use the modified TopicIndexView with a binding to tempSelectedTopics
        TopicIndexView(dmangler: dmangler, selectedTopics: $tempSelectedTopics)
          .frame(height: 100)
          .padding(.top, 8)
        
        // Gimme count display at the top
        Text("Gimmees: \(tempGimmeeCount)")
          .font(tempGimmeeCount <= 0 ? .title : .body)
          .foregroundColor(.secondary)
          .padding(.top, 8)
        
        // List of already selected topics
        List {
          Section(header: Text("Selected Topics")) {
            ForEach(tempSelectedTopics.keys.sorted(), id: \.self) { topic in
              if let color = tempSelectedTopics[topic] {
                HStack {
                  Text(topic)
                  Spacer()
                  Circle()
                    .fill(ColorManager.backgroundColor(for: color))  // Use enum to get Color
                    .frame(width: 20, height: 20)
                  Button("Remove?") {
                    removeTopic(topic)
                  }
                 // .disabled(tempGimmeeCount <= 0)  // Disable if gimme count is zero or less
                }
              }
            }
          }
        }
        
        // List of available topics
        List {
          Section(header: Text("Available Topics")) {
            let tempAvailableTopics = removeInstances(from:  dmangler.allTopics, removing: flattenDictionaryKeys( tempSelectedTopics))
            ForEach(tempAvailableTopics, id: \.self) { topic in
              HStack {
                Text(topic)
                Spacer()
                Button("Add?") {
                  addTopic(topic)
                }
               // .disabled(tempGimmeeCount <= 0)  // Disable if gimme count is zero or less
              }
            }
          }
        }
      }
      .navigationBarItems(
        leading: Button("Cancel") {
          print("Cancelling selection")
          cancelSelection()
        },
        trailing: Button("Done") {
          print("Finalizing selection")
          finalizeSelection()//save changes, sets bool below
          if !showMinimumSelectionAlert {
            presentationMode.wrappedValue.dismiss()
          }
        }
      )
      .navigationTitle("Select Topics")
      .onAppear {
        setupView()
      }

      
      .alert(isPresented: Binding<Bool>(
          get: {
              showMinimumSelectionAlert || showMaximumSelectionAlert || showNoGimmeeAlert
          },
          set: { _ in
              // Reset all alerts when dismissed
              showMinimumSelectionAlert = false
              showMaximumSelectionAlert = false
              showNoGimmeeAlert = false
          }
      )) {
          if showMinimumSelectionAlert {
              return Alert(title: Text("Selection Required"), message: Text("Please select at least \(minTopicCount) topics."), dismissButton: .default(Text("OK")))
          } else if showMaximumSelectionAlert {
              return Alert(title: Text("Maximum Reached"), message: Text("You cannot select more than \(maxTopicCount) topics."), dismissButton: .default(Text("OK")))
          } else if showNoGimmeeAlert {
              return Alert(title: Text("No Gimmees"), message: Text("You have no gimmees left to add or remove topics."), dismissButton: .default(Text("OK")))
          } else {
              return Alert(title: Text("Unknown"), message: Text("An unknown alert was triggered."), dismissButton: .default(Text("OK")))
          }
      }
    }
  }
  
  // MARK: - Action Methods
  
  private func addTopic(_ topic: String) {
    if tempGimmeeCount <= 0 {
      showNoGimmeeAlert = true
    } else
    if tempSelectedTopics.count >= maxTopicCount {
      showMaximumSelectionAlert = true
    } else {
      let active = flattenDictionaryValues(tempSelectedTopics)
      let avail = removeInstances(from: availableColorsForScheme(dmangler.currentScheme), removing: active)
      guard  let color = avail.randomElement()  else {
        print("Could not get random Color for scheme \(dmangler.currentScheme) in addtopic")
        return}
      // print("Add topic \(topic) with color \(color)")
       tempSelectedTopics[topic] = color
        tempGimmeeCount -= 1
       dumpTopicsAndColors("added topic \(topic) with color \(color) scheme \(dmangler.currentScheme)",from:tempSelectedTopics)
 
    }
  }
  
  private func removeTopic(_ topic: String) {
    if tempGimmeeCount <= 0 {
      showNoGimmeeAlert = true
    } else {
      guard  let color = tempSelectedTopics[topic] else {
        print("Could not get color for \(topic) in removetopic")
        return
      }
      // print("Remove topic \(topic) with color \(color)")
      tempSelectedTopics.removeValue(forKey: topic)
      tempGimmeeCount -= 1
      dumpTopicsAndColors("removed topic \(topic) with color \(color) scheme \(dmangler.currentScheme)",from:tempSelectedTopics)
    }
  }
  private func cancelSelection() {  // Restore the initial gimme count
    presentationMode.wrappedValue.dismiss()  // Dismiss without saving changes
  }
  

  
  
  private func finalizeSelection() {
    if tempSelectedTopics.count < minTopicCount {
      showMinimumSelectionAlert = true
    } else {
      
      gimmeCount = tempGimmeeCount
      dmangler.selectedTopics = tempSelectedTopics  // Persist the changes

      dumpTopicsAndColors("finalized selection for scheme \(dmangler.currentScheme)", from: dmangler.selectedTopics)
      presentationMode.wrappedValue.dismiss()  // Dismiss and save changes
    }
  }
  
  private func setupView() {
    tempGimmeeCount = gimmeCount  // Store the initial gimme count
    tempSelectedTopics = dmangler.selectedTopics  // Load the selected topics
    dumpTopicsAndColors("setup view for scheme \(dmangler.currentScheme)", from: dmangler.selectedTopics)
    if tempGimmeeCount <= 0 {
      showNoGimmeeAlert = true
    }
  }
}
struct TopicSelectorView_Previews: PreviewProvider {
  @State static private var gimmeCount: Int = 5  // Example gimme count
  
  static var previews: some View {
    let dmangler = Dmangler(currentScheme:test_scheme,allCounts:test_allCounts,allTopics:test_allTopics,selectedTopics:test_selected)
    
    
    return TopicSelectorView(dmangler: dmangler, gimmeCount: $gimmeCount)
      .previewLayout(.device)
      .previewDisplayName("Topic Selector View")
      .environment(\.colorScheme, .light)  // You can also test dark mode by setting .dark
  }
}
