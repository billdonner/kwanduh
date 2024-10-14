//
//  TopicColor.swift
//  dmangler
//
//  Created by bill donner on 10/6/24.
//
 
// Combined Swift Code: ColorManager with Background and Foreground Colors

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
enum FreeportColor: Int, CaseIterable, Comparable,Codable {
    // Enum cases synthesized from color names
    case myLightYellow
    case myDeepPink
    case myLightBlue
    case myRoyalBlue
    case myPeach
    case myOrange
    case myLavender
    case myMint
    case myLightCoral
    case myAqua
    case myLemon
    case mySkyBlue
    case mySunshineYellow
    case myOceanBlue
    case mySeafoam
    case myPalmGreen
    case myCoral
    case myLagoon
    case myShell
    case mySienna
    case myCoconut
    case myPineapple
    case myBurntOrange
    case myGoldenYellow
    case myCrimsonRed
    case myPumpkin
    case myChestnut
    case myHarvestGold
    case myAmber
    case myMaroon
    case myRusset
    case myMossGreen
    case myIceBlue
    case myMidnightBlue
    case myFrost
    case mySlate
    case mySilver
    case myPine
    case myBerry
    case myEvergreen
    case myStorm
    case myHolly
    case myBlack0
  case myBlack1
  case myBlack2
  case myBlack3
  case myBlack4
  case myBlack5
  case myBlack6
  case myBlack7
  case myBlack8
  case myBlack9
  case myBlackA
  case myBlackB
  case myOffWhite
  case myOffBlack
    // Foreground enum cases
    case myGold
    case myHotPink//not used in any scheme right now, identifies error situations
    case myDarkOrange
    case myDarkViolet
    case myDarkGreen
    case myCrimson
    case myTeal
    case myNavy
    case myGoldenrod//not used in any scheme right now, identifies error situations
    case myForestGreen
    case myDeepTeal
    case myChocolate
    case myBrown
    case myDarkGoldenrod
    case myDarkRed
    case myOrangeRed
    case mySaddleBrown
    case myDarkOliveGreen
    case myDarkBlue
    case myAliceBlue
    case mySteelBlue
    case myDarkSlateGray
    case myDarkGray
    case myWhite

    static func < (lhs: FreeportColor, rhs: FreeportColor) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
// this should exactly parallel TopicColor due to rawValue indexing
struct ColorManager {
    // Static array for background colors
    static let mycolors: [(topic: FreeportColor, color: Color, name: String)] = [
        (.myLightYellow, Color(red: 255/255, green: 223/255, blue: 0/255), "Light Yellow"),
        (.myDeepPink, Color(red: 255/255, green: 20/255, blue: 147/255), "Deep Pink"),
        (.myLightBlue, Color(red: 65/255, green: 105/255, blue: 225/255), "Light Blue"),
        (.myPeach, Color(red: 255/255, green: 140/255, blue: 0/255), "Peach"),
        (.myLavender, Color(red: 148/255, green: 0/255, blue: 211/255), "Lavender"),
        (.myMint, Color(red: 0/255, green: 100/255, blue: 0/255), "Mint"),
        (.myLightCoral, Color(red: 220/255, green: 20/255, blue: 60/255), "Light Coral"),
        (.myAqua, Color(red: 0/255, green: 128/255, blue: 128/255), "Aqua"),
        (.myLemon, Color(red: 255/255, green: 140/255, blue: 0/255), "Lemon"),
        (.mySkyBlue, Color(red: 135/255, green: 206/255, blue: 235/255), "Sky Blue"),
        (.mySunshineYellow, Color(red: 255/255, green: 255/255, blue: 0/255), "Sunshine Yellow"),
        (.myOceanBlue, Color(red: 0/255, green: 105/255, blue: 148/255), "Ocean Blue"),
        (.mySeafoam, Color(red: 70/255, green: 240/255, blue: 220/255), "Seafoam"),
        (.myPalmGreen, Color(red: 34/255, green: 139/255, blue: 34/255), "Palm Green"),
        (.myCoral, Color(red: 255/255, green: 127/255, blue: 80/255), "Coral"),
        (.myLagoon, Color(red: 72/255, green: 209/255, blue: 204/255), "Lagoon"),
        (.myShell, Color(red: 210/255, green: 105/255, blue: 30/255), "Shell"),
        (.myCoconut, Color(red: 139/255, green: 69/255, blue: 19/255), "Coconut"),
        (.myPineapple, Color(red: 255/255, green: 223/255, blue: 0/255), "Pineapple"),
        (.myBurntOrange, Color(red: 204/255, green: 85/255, blue: 0/255), "Burnt Orange"),
        (.myGoldenYellow, Color(red: 255/255, green: 223/255, blue: 0/255), "Golden Yellow"),
        (.myCrimsonRed, Color(red: 139/255, green: 0/255, blue: 0/255), "Crimson Red"),
        (.myPumpkin, Color(red: 255/255, green: 117/255, blue: 24/255), "Pumpkin"),
        (.myChestnut, Color(red: 149/255, green: 69/255, blue: 53/255), "Chestnut"),
        (.myHarvestGold, Color(red: 218/255, green: 165/255, blue: 32/255), "Harvest Gold"),
        (.myAmber, Color(red: 255/255, green: 191/255, blue: 0/255), "Amber"),
        (.myMaroon, Color(red: 139/255, green: 0/255, blue: 0/255), "Maroon"),
        (.myRusset, Color(red: 165/255, green: 42/255, blue: 42/255), "Russet"),
        (.myMossGreen, Color(red: 85/255, green: 107/255, blue: 47/255), "Moss Green"),
        (.myIceBlue, Color(red: 176/255, green: 224/255, blue: 230/255), "Ice Blue"),
        (.myMidnightBlue, Color(red: 25/255, green: 25/255, blue: 112/255), "Midnight Blue"),
        (.myFrost, Color(red: 70/255, green: 130/255, blue: 180/255), "Frost"),
        (.mySlate, Color(red: 47/255, green: 79/255, blue: 79/255), "Slate"),
        (.mySilver, Color(red: 169/255, green: 169/255, blue: 169/255), "Silver"),
        (.myPine, Color(red: 0/255, green: 100/255, blue: 0/255), "Pine"),
        (.myBerry, Color(red: 139/255, green: 0/255, blue: 0/255), "Berry"),
        (.myEvergreen, Color(red: 0/255, green: 100/255, blue: 0/255), "Evergreen"),
        (.myStorm, Color(red: 119/255, green: 136/255, blue: 153/255), "Storm"),
        (.myHolly, Color(red: 0/255, green: 128/255, blue: 0/255), "Holly"),
        // these seemingly duplicate black colors allow us to implement "bleak" scheme for free
        (.myBlack0, Color(red: 0/255, green: 0/255, blue: 0/255), "Black"),
        (.myBlack1, Color(red: 0/255, green: 0/255, blue: 0/255), "Black"),
        (.myBlack2, Color(red: 0/255, green: 0/255, blue: 0/255), "Black"),
        (.myBlack3, Color(red: 0/255, green: 0/255, blue: 0/255), "Black"),
        (.myBlack4, Color(red: 0/255, green: 0/255, blue: 0/255), "Black"),
        (.myBlack5, Color(red: 0/255, green: 0/255, blue: 0/255), "Black"),
        (.myBlack6, Color(red: 0/255, green: 0/255, blue: 0/255), "Black"),
        (.myBlack7, Color(red: 0/255, green: 0/255, blue: 0/255), "Black"),
        (.myBlack8, Color(red: 0/255, green: 0/255, blue: 0/255), "Black"),
        (.myBlack9, Color(red: 0/255, green: 0/255, blue: 0/255), "Black"),
        (.myBlackA, Color(red: 0/255, green: 0/255, blue: 0/255), "Black"),
        (.myBlackB, Color(red: 0/255, green: 0/255, blue: 0/255), "Black"),
        (.myOffBlack, Color(red: 0.1, green: 0.1, blue: 0.1),"Off Black"),
        (.myOffWhite, Color(red: 0.95, green: 0.95, blue: 0.95),"Off White"),
 
   

    // Static array for foreground colors
  
        (.myGold, Color(red: 255/255, green: 223/255, blue: 0/255), "Gold"),
        (.myHotPink, Color(red: 255/255, green: 20/255, blue: 147/255), "Hot Pink"),
        (.myRoyalBlue, Color(red: 65/255, green: 105/255, blue: 225/255), "Royal Blue"),
        (.myDarkOrange, Color(red: 255/255, green: 191/255, blue: 0/255), "Dark Orange"),
        (.myDarkViolet, Color(red: 148/255, green: 0/255, blue: 211/255), "Dark Violet"),
        (.myDarkGreen, Color(red: 0/255, green: 128/255, blue: 0/255), "Dark Green"),
        (.myCrimson, Color(red: 255/255, green: 127/255, blue: 80/255), "Crimson"),
        (.myTeal, Color(red: 70/255, green: 240/255, blue: 220/255), "Teal"),
        (.myNavy, Color(red: 0/255, green: 105/255, blue: 148/255), "Navy"),
        (.myMidnightBlue, Color(red: 135/255, green: 206/255, blue: 235/255), "Midnight Blue"),
        (.myGoldenrod, Color(red: 255/255, green: 255/255, blue: 0/255), "Goldenrod"),
        (.myForestGreen, Color(red: 34/255, green: 139/255, blue: 34/255), "Forest Green"),
        (.myDeepTeal, Color(red: 72/255, green: 209/255, blue: 204/255), "Deep Teal"),
        (.myChocolate, Color(red: 210/255, green: 105/255, blue: 30/255), "Chocolate"),
        (.myBrown, Color(red: 165/255, green: 42/255, blue: 42/255), "Brown"),
        (.myDarkGoldenrod, Color(red: 218/255, green: 165/255, blue: 32/255), "Dark Goldenrod"),
        (.myDarkRed, Color(red: 139/255, green: 0/255, blue: 0/255), "Dark Red"),
        (.myOrangeRed, Color(red: 255/255, green: 117/255, blue: 24/255), "Orange Red"),
        (.mySaddleBrown, Color(red: 149/255, green: 69/255, blue: 53/255), "Saddle Brown"),
        (.myDarkOliveGreen, Color(red: 85/255, green: 107/255, blue: 47/255), "Dark Olive Green"),
        (.myDarkBlue, Color(red: 176/255, green: 224/255, blue: 230/255), "Dark Blue"),
        (.myAliceBlue, Color(red: 25/255, green: 25/255, blue: 112/255), "Alice Blue"),
        (.mySteelBlue, Color(red: 70/255, green: 130/255, blue: 180/255), "Steel Blue"),
        (.myDarkSlateGray, Color(red: 47/255, green: 79/255, blue: 79/255), "Dark Slate Gray"),
        (.myDarkGray, Color(red: 119/255, green: 136/255, blue: 153/255), "Dark Gray"),
        (.myWhite, Color(red: 0/255, green: 0/255, blue: 0/255), "White")
    ]

    // Function to retrieve a background color for a TopicColor
    static func backgroundColor(for topicColor: FreeportColor) -> Color {
        return mycolors.first(where: { $0.topic == topicColor })?.color ?? Color.clear
    }
    
 
    // Get all available colors as enum values
    static func getAllColors() -> [FreeportColor] {
        return FreeportColor.allCases
    }
}

let scheme0Colors: [FreeportColor] = [
    .myBlack0, .myBlack1, .myBlack2, .myBlack3, .myBlack4,
    .myBlack5, .myBlack6, .myBlack7, .myBlack8, .myBlack9,  
      .myBlackA,.myBlackB
]

let scheme1Colors: [FreeportColor] = [
    .myIceBlue, .myMidnightBlue, .myFrost, .mySlate, .mySilver,
    .myPine, .myBerry, .myEvergreen, .myStorm, .myHolly,
    .myOffWhite, .myOffBlack
]

let scheme2Colors: [FreeportColor] = [
    .myLightYellow, .myDeepPink, .myLightBlue, .myPeach, .myLavender,
    .myMint, .myLightCoral, .myAqua, .myLemon, .mySkyBlue,
    .myOffWhite, .myOffBlack
]

let scheme3Colors: [FreeportColor] = [
    .mySkyBlue, .mySunshineYellow, .myOceanBlue, .mySeafoam, .myPalmGreen,
    .myCoral, .myLagoon, .myShell, .myCoconut, .myPineapple,
    .myOffWhite, .myOffBlack
]

let scheme4Colors: [FreeportColor] = [
    .myBurntOrange, .myGoldenYellow, .myCrimsonRed, .myPumpkin, .myChestnut,
    .myHarvestGold, .myAmber, .myMaroon, .myRusset, .myMossGreen,
    .myOffWhite, .myOffBlack
]
let allColorSchemes: [[FreeportColor]] = [
  scheme0Colors, scheme1Colors, scheme2Colors, scheme3Colors, scheme4Colors
]
func allColorsForScheme(_ schmindx: Int) -> [FreeportColor] {
  return allColorSchemes[schmindx]
}
func colorForSchemeAndTopic(scheme schmindx: Int, index topicIndex: Int) -> FreeportColor {
    let theScheme = allColorSchemes[schmindx]
    return theScheme[topicIndex]
}
func availableColorsForScheme (_ schmindx: Int) -> [FreeportColor] {
  return allColorSchemes[schmindx]
}
/**
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
  
   
