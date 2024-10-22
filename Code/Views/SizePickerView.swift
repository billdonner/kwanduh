//
//  SizePickerView.swift
//  qandao
//
//  Created by bill donner on 8/24/24.
//

import SwiftUI

struct SizePickerView: View {
   @Binding   var chosenSize: Int
    var body: some View {
        // Horizontal Picker
        Picker("Select a number", selection: $chosenSize) {
          ForEach(3...8, id: \.self) { number in
            Text("\(number)x\(number)").tag(number)
          }
        }
        .pickerStyle(SegmentedPickerStyle())

    }
    
    // Function to return a paragraph of text based on the selected number
    func descriptionForNumber(_ number: Int) -> (String ,String){
        switch number { 
        case 3:
            return ("Three is often considered a lucky number in various cultures and represents harmony, wisdom, and understanding.","9 cells, face up, play anywhere")
        case 4:
            return ("Four is a number of stability and balance, symbolizing the four elements, four seasons, and four cardinal directions.","16 cells, face up, play anywhere")
        case 5:
            return ("Five is associated with dynamic energy and the balance between material and spiritual aspects of life.","25 cells, face down, play anywhere")
        case 6:
            return ("Six is often seen as a number of love, family, and domestic happiness, representing harmony and balance.","36 cells, face down, corner rules")
        case 7:
            return ("Seven is a mystical number, often associated with spiritual awakening, introspection, and inner wisdom.","49 cells,face down,corner rules")
        case 8:
            return ("Eight is a symbol of abundance, success, and material wealth, often seen as a number of power and ambition.","64 cells,face down, corner rules")
        default:
            return ("","")
        }
    }
}

struct SizePickerView_Previews: PreviewProvider {
    static var previews: some View {
      SizePickerView(chosenSize: .constant(8))
    }
}


//.padding()

// Text Paragraph based on the selected number
//        Text(descriptionForNumber(chosenSize).1)
//        .padding(.horizontal)
//          .frame(maxWidth: .infinity, alignment: .leading)
//
//        Text(descriptionForNumber(chosenSize).0)
//          .padding()
//          .frame(maxWidth: .infinity, alignment: .leading)
//        if chosenSize >=  6 {
//          Text("Corner rules require starting in a corner and moving only to adjacent cells.")
//            .font(.footnote)
//            .padding(.horizontal)
//        }
