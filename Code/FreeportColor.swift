

import SwiftUI
struct RGB: Codable {
  let red: Double
  let green: Double
  let blue: Double
}
// Function to convert SwiftUI Color to RGB
func colorToRGB(color: Color) -> RGB {
  // Convert to UIColor (iOS)
  let uiColor = UIColor(color)
  
  // Extract RGB components
  var red: CGFloat = 0
  var green: CGFloat = 0
  var blue: CGFloat = 0
  var alpha: CGFloat = 0
  
  uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
  
  // Return RGB as a struct
  return RGB(red: Double(red) * 255.0,
             green: Double(green) * 255.0,
             blue: Double(blue) * 255.0)
}

/// Determines the contrasting text color (black or white) for a given background color.
func contrastingTextColor(for rgb: RGB) -> Color {
  let luminance = 0.299 * rgb.red + 0.587 * rgb.green + 0.114 * rgb.blue
  return luminance > 186 ? .black : .white
}
func optimalTextColor(for color: Color) -> Color {
  contrastingTextColor(for: colorToRGB(color: color))
}


import SwiftUI

struct ColorManager {
  // Dictionary for background colors indexed by FreeportColor
  static let mycolors: [FreeportColor: (color: Color, name: String)] = [
    .myLightYellow: (Color(red: 255/255, green: 223/255, blue: 0/255), "Light Yellow"), // Spring
    .myDeepPink: (Color(red: 255/255, green: 20/255, blue: 147/255), "Deep Pink"), // Spring
    .myLightBlue: (Color(red: 65/255, green: 105/255, blue: 225/255), "Light Blue"), // Spring
    .myPeach: (Color(red: 255/255, green: 140/255, blue: 0/255), "Peach"), // Spring
    .myOrange: (Color(red: 255/255, green: 165/255, blue: 0/255), "Orange"), // Spring
    .myLavender: (Color(red: 148/255, green: 0/255, blue: 211/255), "Lavender"), // Spring
    .myMint: (Color(red: 0/255, green: 100/255, blue: 0/255), "Mint"), // Spring
    .myLightCoral: (Color(red: 220/255, green: 20/255, blue: 60/255), "Light Coral"), // Spring
    .myAqua: (Color(red: 0/255, green: 128/255, blue: 128/255), "Aqua"), // Spring
    .myLemon: (Color.yellow, "Lemon"), // Spring
    .mySkyBlue: (Color(red: 135/255, green: 206/255, blue: 235/255), "Sky Blue"), // Spring
    .mySunshineYellow: (Color(red: 255/255, green: 255/255, blue: 0/255), "Sunshine Yellow"), // Spring
    
      .myOceanBlue: (Color(red: 0/255, green: 105/255, blue: 148/255), "Ocean Blue"), // Summer
    .mySeafoam: (Color(red: 70/255, green: 240/255, blue: 220/255), "Seafoam"), // Summer
    .myPalmGreen: (Color(red: 34/255, green: 139/255, blue: 34/255), "Palm Green"), // Summer
    .myCoral: (Color(red: 255/255, green: 127/255, blue: 80/255), "Coral"), // Summer
    .myLagoon: (Color(red: 72/255, green: 209/255, blue: 204/255), "Lagoon"), // Summer
    .myShell: (Color(red: 210/255, green: 105/255, blue: 30/255), "Shell"), // Summer
    
      .mySienna: (Color(red: 160/255, green: 82/255, blue: 45/255), "Sienna"), // Neutral??
    .myCoconut: (Color(red: 139/255, green: 69/255, blue: 19/255), "Coconut"), // Summer
    .myPineapple: (Color(red: 255/255, green: 223/255, blue: 0/255), "Pineapple"), // Summer
    .myBurntOrange: (Color(red: 204/255, green: 85/255, blue: 0/255), "Burnt Orange"), // Summer
    .myGoldenYellow: (Color(red: 255/255, green: 223/255, blue: 0/255), "Golden Yellow"), // Summer
    .myCrimsonRed: (Color(red: 139/255, green: 0/255, blue: 0/255), "Crimson Red"), // Summer
    .myPumpkin: (Color(red: 255/255, green: 117/255, blue: 24/255), "Pumpkin"), // Summer
    
      .myChestnut: (Color(red: 149/255, green: 69/255, blue: 53/255), "Chestnut"), // Fall
    .myHarvestGold: (Color(red: 218/255, green: 165/255, blue: 32/255), "Harvest Gold"), // Fall
    .myAmber: (Color(red: 255/255, green: 191/255, blue: 0/255), "Amber"), // Fall
    .myMaroon: (Color(red: 139/255, green: 0/255, blue: 0/255), "Maroon"), // Fall
    .myRusset: (Color(red: 165/255, green: 42/255, blue: 42/255), "Russet"), // Fall
    .myMossGreen: (Color(red: 85/255, green: 107/255, blue: 47/255), "Moss Green"), // Fall
    .myIceBlue: (Color(red: 176/255, green: 224/255, blue: 230/255), "Ice Blue"), // Winter
    .myMidnightBlue: (Color(red: 25/255, green: 25/255, blue: 112/255), "Midnight Blue"), // Winter
    .myFrost: (Color(red: 70/255, green: 130/255, blue: 180/255), "Frost"), // Winter
    .mySlate: (Color(red: 47/255, green: 79/255, blue: 79/255), "Slate"), // Winter
    .mySilver: (Color(red: 169/255, green: 169/255, blue: 169/255), "Silver"), // Winter
    .myPine: (Color(red: 0/255, green: 100/255, blue: 0/255), "Pine"), // Winter
    
      .myBerry: (Color(red: 139/255, green: 0/255, blue: 0/255), "Berry"), // Fall
    .myEvergreen: (Color(red: 0/255, green: 100/255, blue: 0/255), "Evergreen"), // Winter
    .myStorm: (Color(red: 119/255, green: 136/255, blue: 153/255), "Storm"), // Winter
    .myHolly: (Color(red: 0/255, green: 128/255, blue: 0/255), "Holly"), // Winter
    .myBlack0: (Color(red: 0/255, green: 0/255, blue: 0/255), "Black"), // Neutral
    .myBlack1: (Color(red: 0/255, green: 0/255, blue: 0/255), "Black"), // Neutral
    .myBlack2: (Color(red: 0/255, green: 0/255, blue: 0/255), "Black"), // Neutral
    .myBlack3: (Color(red: 0/255, green: 0/255, blue: 0/255), "Black"), // Neutral
    .myBlack4: (Color(red: 0/255, green: 0/255, blue: 0/255), "Black"), // Neutral
    .myBlack5: (Color(red: 0/255, green: 0/255, blue: 0/255), "Black"), // Neutral
    .myBlack6: (Color(red: 0/255, green: 0/255, blue: 0/255), "Black"), // Neutral
    .myBlack7: (Color(red: 0/255, green: 0/255, blue: 0/255), "Black"), // Neutral
    .myBlack8: (Color(red: 0/255, green: 0/255, blue: 0/255), "Black"), // Neutral
    .myBlack9: (Color(red: 0/255, green: 0/255, blue: 0/255), "Black"), // Neutral
    .myBlackA: (Color(red: 0/255, green: 0/255, blue: 0/255), "Black"), // Neutral
    .myBlackB: (Color(red: 0/255, green: 0/255, blue: 0/255), "Black"), // Neutral
    .myOffBlack: (Color(red: 0.1, green: 0.1, blue: 0.1), "Off Black"), // Neutral
    .myOffWhite: (Color(red: 0.95, green: 0.95, blue: 0.95), "Off White"), // Neutral
    
    // Static array for foreground colors
      .myGold: (Color(red: 255/255, green: 223/255, blue: 0/255), "Gold"), // Neutral
    .myHotPink: (Color(red: 255/255, green: 20/255, blue: 147/255), "Hot Pink"), // Error
    .myRoyalBlue: (Color(red: 65/255, green: 105/255, blue: 225/255), "Royal Blue"), // Neutral
    .myDarkOrange: (Color(red: 255/255, green: 191/255, blue: 0/255), "Dark Orange"), // Fall
    .myDarkViolet: (Color(red: 148/255, green: 0/255, blue: 211/255), "Dark Violet"), // Fall
    .myDarkGreen: (Color(red: 0/255, green: 128/255, blue: 0/255), "Dark Green"), // Fall
    .myCrimson: (Color(red: 255/255, green: 127/255, blue: 80/255), "Crimson"), // Fall
    .myTeal: (Color(red: 70/255, green: 240/255, blue: 220/255), "Teal"), // Fall
    .myNavy: (Color(red: 0/255, green: 105/255, blue: 148/255), "Navy"), // Fall
    .myGoldenrod: (Color(red: 255/255, green: 255/255, blue: 0/255), "Goldenrod"), // Fall
    .myForestGreen: (Color(red: 34/255, green: 139/255, blue: 34/255), "Forest Green"), // Fall
    .myDeepTeal: (Color(red: 72/255, green: 209/255, blue: 204/255), "Deep Teal"), // Fall
    .myChocolate: (Color(red: 210/255, green: 105/255, blue: 30/255), "Chocolate"), // Fall
    .myBrown: (Color(red: 165/255, green: 42/255, blue: 42/255), "Brown"), // Fall
    .myDarkGoldenrod: (Color(red: 218/255, green: 165/255, blue: 32/255), "Dark Goldenrod"), // Fall
    .myDarkRed: (Color(red: 139/255, green: 0/255, blue: 0/255), "Dark Red"), // Fall
    .myOrangeRed: (Color(red: 255/255, green: 117/255, blue: 24/255), "Orange Red"), // Fall
    .mySaddleBrown: (Color(red: 149/255, green: 69/255, blue: 53/255), "Saddle Brown"), // Fall
    .myDarkOliveGreen: (Color(red: 85/255, green: 107/255, blue: 47/255), "Dark Olive Green"), // Fall
    .myPrussianBlue: (Color(red: 0/255, green: 49/255, blue: 83/255), "Prussian Blue") ,// #003153
    .myAliceBlue: (Color(red: 25/255, green: 25/255, blue: 112/255), "Alice Blue"), // Fall
    .mySteelBlue: (Color(red: 70/255, green: 130/255, blue: 180/255), "Steel Blue"), // Fall
    .myDarkSlateGray: (Color(red: 47/255, green: 79/255, blue: 79/255), "Dark Slate Gray"), // Fall
    .myDarkGray: (Color(red: 119/255, green: 136/255, blue: 153/255), "Dark Gray"), // Fall
    .myWhite: (Color(red: 255/255, green: 255/255, blue: 255/255), "White") // Fall
  ]
  
  // Ensure every FreeportColor has an entry in the dictionary
  static func validateColorEntries() {
    var missingCases: [FreeportColor] = []
    
    for color in FreeportColor.allCases {
      if mycolors[color] == nil {
        missingCases.append(color)
      }
    }
    
    // Print all missing cases if any
    if !missingCases.isEmpty {
      print("Missing entries for the following colors:")
      for missingColor in missingCases {
        print(missingColor)
      }
    }
    
    // Assert that there are no missing cases
    assert(missingCases.isEmpty, "Missing entries for FreeportColor cases.")
  }
  
  // Function to retrieve a background color for a FreeportColor
  static func backgroundColor(for topicColor: FreeportColor) -> Color {
    return mycolors[topicColor]?.color ?? Color.clear
  }
  
  // Get all available colors as enum values
  static func getAllColors() -> [FreeportColor] {
    return FreeportColor.allCases
  }
}



let bleakColors: [FreeportColor] = [
  .myBlack0, .myBlack1, .myBlack2, .myBlack3, .myBlack4,
  .myBlack5, .myBlack6, .myBlack7, .myBlack8, .myBlack9,
  // .myBlackA,.myBlackB
]

let winterColors: [FreeportColor] = [
  .myIceBlue,.myFrost,.myMint,.myBrown,.myPrussianBlue,.myNavy,.myBerry,.myLavender,.myPine,.mySilver
  //.myIceBlue, .myMidnightBlue, .myFrost, .mySlate, .mySilver,
  //.myPine, .myBerry, .myEvergreen, .myStorm, .myHolly,
  // .myOffWhite, .myOffBlack
]

let springColors: [FreeportColor] = [
  .myLightYellow, .myDeepPink, .myLightBlue, .myPeach, .myLavender,
  .myMint, .myLightCoral, .myAqua, .myLemon, .mySkyBlue,
  // .myOffWhite, .myOffBlack
]

let summerColors: [FreeportColor] = [
  .mySkyBlue, .mySunshineYellow, .myOceanBlue, .mySeafoam, .myPalmGreen,
  .myCoral, .myLagoon, .myShell, .myCoconut, .myPineapple,
  // .myOffWhite, .myOffBlack
]

let fallColors: [FreeportColor] = [
  .myBurntOrange, .myGoldenYellow, .myCrimsonRed, .myPumpkin, .myChestnut,
  .myHarvestGold, .myAmber, .myMaroon, .myRusset, .myMossGreen,
  //.myOffWhite, .myOffBlack
]
let allColorSchemes: [[FreeportColor]] = [
  bleakColors, winterColors, springColors, summerColors, fallColors
]
func allColorsForScheme(_ schmindx: Int) -> [FreeportColor] {
  let x = allColorSchemes[schmindx]
  assert(x.count == 10, "Scheme \(schmindx) has \(x.count) colors" )
  return x
}
func colorForSchemeAndTopic(scheme schmindx: Int, index topicIndex: Int) -> FreeportColor {
  let theScheme = allColorSchemes[schmindx]
  return theScheme[topicIndex]
}
func availableColorsForScheme (_ schmindx: Int) -> [FreeportColor] {
  return allColorSchemes[schmindx]
}


let allSchemeNames: [String] = ["Bleak","Winter","Spring","Summer","Autumn"]
/*
 Rework the basic topics->mycolor dict from one scheme to another, each topic is separately processed
 
 - get the current color for the topic as specified in in dict as its value ;
 -  lookup the color in the scheme's list of MyColors, obtaining its index or fail
 - find corresponding color for the new/to scheme
 - use that for topic's value
 
 */
func reworkColors(topics:[String:FreeportColor],fromscheme:Int, toscheme:Int) -> [String:FreeportColor] {
  print("Reworking colors for topics  from scheme \(fromscheme) to scheme \(toscheme)")
  return topics.mapValues { mycolor  in
    //find position in "fromscheme"
    guard let  posfrom = allColorSchemes[fromscheme].firstIndex(of: mycolor) else {
      print("did not find \(mycolor) in scheme \(fromscheme)")
      return FreeportColor.myHotPink}
    
    print("found index of \(mycolor) in scheme \(fromscheme) at \(posfrom)")
    // find color in same position in "toscheme" and return it
    guard posfrom >= 0 && posfrom < allColorSchemes[toscheme].count
    else { return FreeportColor.myGoldenrod
    }
    let  newColor = allColorSchemes[toscheme][posfrom]
    print("transformed to \(newColor) in scheme \(toscheme)")
    return newColor
  }
}


extension FreeportColor {
    func toColor() -> Color {
        return ColorManager.mycolors[self]?.color ?? Color.clear // Access the color using the enum case
    }
    
    func toColorName() -> String {
        return ColorManager.mycolors[self]?.name ?? "Unknown Color" // Access the name using the enum case
    }
}
