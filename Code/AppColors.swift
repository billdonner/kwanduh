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
struct ColorSpec: Codable {
    let backname: String
    let forename: String
    let backrgb: RGB
    let forergb: RGB
}
//struct ColorTriple {
//    var red: Double
//    var green: Double
//    var blue: Double
//}
typealias ColorTriple =  (Color, Color, UUID)
typealias ColorSchemeName = Int

class AppColors {
    
    static func colorForSchemeAndTopic(scheme schmindx: ColorSchemeName, index topicIndex: Int) -> ColorTriple {
        let theScheme = Self.allSchemes[schmindx]
        return theScheme.mappedColors[topicIndex]
    }
    
    static func pretty(for colorIndex: Int) -> String {
        switch colorIndex {
        case 0: return "bleak"
        case 1: return "winter"
        case 2: return "spring"
        case 3: return "summer"
        default: return "autumn"
        }
    }
    
    static func colorForTopicIndex(index: Int, gs: GameState) -> ColorTriple {
        colorForSchemeAndTopic(scheme: gs.currentscheme, index: index)
    }
    
    // Define the color schemes
    static let spring = AppColorScheme(name: 2,
                                        colors: [
                                            ColorSpec(backname: "Light Yellow", forename: "Gold", backrgb: RGB(red: 255, green: 223, blue: 0), forergb: RGB(red: 255, green: 215, blue: 0)), // Light
                                            ColorSpec(backname: "Deep Pink", forename: "Hot Pink", backrgb: RGB(red: 255, green: 20, blue: 147), forergb: RGB(red: 255, green: 105, blue: 180)), // Light
                                            ColorSpec(backname: "Light Blue", forename: "Royal Blue", backrgb: RGB(red: 65, green: 105, blue: 225), forergb: RGB(red: 0, green: 0, blue: 139)), // Darker
                                            ColorSpec(backname: "Peach", forename: "Dark Orange", backrgb: RGB(red: 255, green: 140, blue: 0), forergb: RGB(red: 255, green: 69, blue: 0)), // Darker
                                            ColorSpec(backname: "Lavender", forename: "Dark Violet", backrgb: RGB(red: 148, green: 0, blue: 211), forergb: RGB(red: 138, green: 43, blue: 226)), // Darker
                                            ColorSpec(backname: "Mint", forename: "Dark Green", backrgb: RGB(red: 0, green: 100, blue: 0), forergb: RGB(red: 0, green: 128, blue: 0)), // Darker
                                            ColorSpec(backname: "Light Coral", forename: "Crimson", backrgb: RGB(red: 220, green: 20, blue: 60), forergb: RGB(red: 220, green: 20, blue: 60)), // Darker
                                            ColorSpec(backname: "Aqua", forename: "Teal", backrgb: RGB(red: 0, green: 128, blue: 128), forergb: RGB(red: 0, green: 128, blue: 128)), // Darker
                                            ColorSpec(backname: "Lemon", forename: "Dark Orange", backrgb: RGB(red: 255, green: 140, blue: 0), forergb: RGB(red: 255, green: 140, blue: 0)), // Darker
                                            ColorSpec(backname: "Sky Blue", forename: "Navy", backrgb: RGB(red: 0, green: 0, blue: 128), forergb: RGB(red: 0, green: 0, blue: 205)) // Darker
                                        ])
    
    static let summer = AppColorScheme(name: 3,
                                        colors: [
                                            ColorSpec(backname: "Sky Blue", forename: "Midnight Blue", backrgb: RGB(red: 135, green: 206, blue: 235), forergb: RGB(red: 25, green: 25, blue: 112)), // Light
                                            ColorSpec(backname: "Sunshine Yellow", forename: "Goldenrod", backrgb: RGB(red: 255, green: 255, blue: 0), forergb: RGB(red: 218, green: 165, blue: 32)), // Light
                                            ColorSpec(backname: "Ocean Blue", forename: "Navy", backrgb: RGB(red: 0, green: 105, blue: 148), forergb: RGB(red: 0, green: 34, blue: 64)), // Darker
                                            ColorSpec(backname: "Seafoam", forename: "Teal", backrgb: RGB(red: 70, green: 240, blue: 220), forergb: RGB(red: 0, green: 128, blue: 128)), // Light
                                            ColorSpec(backname: "Palm Green", forename: "Forest Green", backrgb: RGB(red: 34, green: 139, blue: 34), forergb: RGB(red: 0, green: 100, blue: 0)), // Darker
                                            ColorSpec(backname: "Coral", forename: "Crimson", backrgb: RGB(red: 255, green: 127, blue: 80), forergb: RGB(red: 220, green: 20, blue: 60)), // Light
                                            ColorSpec(backname: "Lagoon", forename: "Deep Teal", backrgb: RGB(red: 72, green: 209, blue: 204), forergb: RGB(red: 0, green: 128, blue: 128)), // Darker
                                            ColorSpec(backname: "Shell", forename: "Chocolate", backrgb: RGB(red: 210, green: 105, blue: 30), forergb: RGB(red: 139, green: 69, blue: 19)), // Darker
                                            ColorSpec(backname: "Coconut", forename: "Brown", backrgb: RGB(red: 139, green: 69, blue: 19), forergb: RGB(red: 139, green: 69, blue: 19)), // Darker
                                            ColorSpec(backname: "Pineapple", forename: "Dark Orange", backrgb: RGB(red: 255, green: 223, blue: 0), forergb: RGB(red: 255, green: 140, blue: 0)) // Light
                                        ])
    
    static let autumn = AppColorScheme(name: 4,
                                        colors: [
                                            ColorSpec(backname: "Burnt Orange", forename: "Dark Orange", backrgb: RGB(red: 204, green: 85, blue: 0), forergb: RGB(red: 255, green: 140, blue: 0)), // Darker
                                            ColorSpec(backname: "Golden Yellow", forename: "Dark Goldenrod", backrgb: RGB(red: 255, green: 223, blue: 0), forergb: RGB(red: 184, green: 134, blue: 11)), // Light
                                            ColorSpec(backname: "Crimson Red", forename: "Dark Red", backrgb: RGB(red: 139, green: 0, blue: 0), forergb: RGB(red: 139, green: 0, blue: 0)), // Darker
                                            ColorSpec(backname: "Pumpkin", forename: "Orange Red", backrgb: RGB(red: 255, green: 117, blue: 24), forergb: RGB(red: 255, green: 69, blue: 0)), // Darker
                                            ColorSpec(backname: "Chestnut", forename: "Saddle Brown", backrgb: RGB(red: 149, green: 69, blue: 53), forergb: RGB(red: 139, green: 69, blue: 19)), // Darker
                                            ColorSpec(backname: "Harvest Gold", forename: "Dark Goldenrod", backrgb: RGB(red: 218, green: 165, blue: 32), forergb: RGB(red: 184, green: 134, blue: 11)), // Darker
                                            ColorSpec(backname: "Amber", forename: "Dark Orange", backrgb: RGB(red: 255, green: 191, blue: 0), forergb: RGB(red: 255, green: 69, blue: 0)), // Light
                                            ColorSpec(backname: "Maroon", forename: "Dark Red", backrgb: RGB(red: 139, green: 0, blue: 0), forergb: RGB(red: 139, green: 0, blue: 0)), // Darker
                                        
                                                      ColorSpec(backname: "Russet", forename: "Brown", backrgb: RGB(red: 165, green: 42, blue: 42), forergb: RGB(red: 165, green: 42, blue: 42)), // Darker
                                                      ColorSpec(backname: "Moss Green", forename: "Dark Olive Green", backrgb: RGB(red: 85, green: 107, blue: 47), forergb: RGB(red: 85, green: 107, blue: 47)) // Darker
                                                  ])
              
              static let winter = AppColorScheme(name: 1,
                                                  colors: [
                                                      ColorSpec(backname: "Ice Blue", forename: "Dark Blue", backrgb: RGB(red: 176, green: 224, blue: 230), forergb: RGB(red: 0, green: 0, blue: 139)), // Light
                                                      ColorSpec(backname: "Midnight Blue", forename: "Alice Blue", backrgb: RGB(red: 25, green: 25, blue: 112), forergb: RGB(red: 240, green: 248, blue: 255)), // Darker
                                                      ColorSpec(backname: "Frost", forename: "Steel Blue", backrgb: RGB(red: 70, green: 130, blue: 180), forergb: RGB(red: 70, green: 130, blue: 180)), // Darker
                                                      ColorSpec(backname: "Slate", forename: "Dark Slate Gray", backrgb: RGB(red: 47, green: 79, blue: 79), forergb: RGB(red: 47, green: 79, blue: 79)), // Darker
                                                      ColorSpec(backname: "Silver", forename: "Dark Gray", backrgb: RGB(red: 169, green: 169, blue: 169), forergb: RGB(red: 169, green: 169, blue: 169)), // Darker
                                                      ColorSpec(backname: "Pine", forename: "Dark Green", backrgb: RGB(red: 0, green: 100, blue: 0), forergb: RGB(red: 0, green: 100, blue: 0)), // Darker
                                                      ColorSpec(backname: "Berry", forename: "Dark Red", backrgb: RGB(red: 139, green: 0, blue: 0), forergb: RGB(red: 139, green: 0, blue: 0)), // Darker
                                                      ColorSpec(backname: "Evergreen", forename: "Dark Green", backrgb: RGB(red: 0, green: 100, blue: 0), forergb: RGB(red: 0, green: 100, blue: 0)), // Darker
                                                      ColorSpec(backname: "Storm", forename: "Dark Gray", backrgb: RGB(red: 119, green: 136, blue: 153), forergb: RGB(red: 119, green: 136, blue: 153)), // Darker
                                                      ColorSpec(backname: "Holly", forename: "Dark Green", backrgb: RGB(red: 0, green: 128, blue: 0), forergb: RGB(red: 0, green: 128, blue: 0)) // Darker
                                                  ])
              
              static let bleak = AppColorScheme(name: 0,
                                                 colors: [
                                                     ColorSpec(backname: "Black", forename: "White", backrgb: RGB(red: 0, green: 0, blue: 0), forergb: RGB(red: 255, green: 255, blue: 255)),
                                                     ColorSpec(backname: "Black", forename: "White", backrgb: RGB(red: 0, green: 0, blue: 0), forergb: RGB(red: 255, green: 255, blue: 255)),
                                                     ColorSpec(backname: "Black", forename: "White", backrgb: RGB(red: 0, green: 0, blue: 0), forergb: RGB(red: 255, green: 255, blue: 255)),
                                                     ColorSpec(backname: "Black", forename: "White", backrgb: RGB(red: 0, green: 0, blue: 0), forergb: RGB(red: 255, green: 255, blue: 255)),
                                                     ColorSpec(backname: "Black", forename: "White", backrgb: RGB(red: 0, green: 0, blue: 0), forergb: RGB(red: 255, green: 255, blue: 255)),
                                                     ColorSpec(backname: "Black", forename: "White", backrgb: RGB(red: 0, green: 0, blue: 0), forergb: RGB(red: 255, green: 255, blue: 255)),
                                                     ColorSpec(backname: "Black", forename: "White", backrgb: RGB(red: 0, green: 0, blue: 0), forergb: RGB(red: 255, green: 255, blue: 255)),
                                                     ColorSpec(backname: "Black", forename: "White", backrgb: RGB(red: 0, green: 0, blue: 0), forergb: RGB(red: 255, green: 255, blue: 255)),
                                                     ColorSpec(backname: "Black", forename: "White", backrgb: RGB(red: 0, green: 0, blue: 0), forergb: RGB(red: 255, green: 255, blue: 255)),
                                                     ColorSpec(backname: "Black", forename: "White", backrgb: RGB(red: 0, green: 0, blue: 0), forergb: RGB(red: 255, green: 255, blue: 255))
                                                 ])
              
              static let allSchemes = [bleak, winter, spring, summer, autumn]
          }

          class AppColorScheme {
              internal init(name: ColorSchemeName, colors: [ColorSpec]) {
                  self.name = name
                  self.colors = colors
              }
              
              let name: ColorSchemeName
              let colors: [ColorSpec]
              var _mappedColors: [ColorTriple]? = nil
              
              /// Maps the colors to SwiftUI Color objects and calculates contrasting text colors.
              var mappedColors: [ColorTriple] {
                  if _mappedColors == nil {
                      _mappedColors = colors.map {
                          let bgColor = Color(red: $0.backrgb.red / 255, green: $0.backrgb.green / 255, blue: $0.backrgb.blue / 255)
                          let textColor = Self.contrastingTextColor(for: ($0.backrgb.red, $0.backrgb.green, $0.backrgb.blue))
                        return  (bgColor, textColor, UUID())
                      }
                  }
                  return _mappedColors!
              }
              
              /// Determines the contrasting text color (black or white) for a given background color.
              static func contrastingTextColor(for rgb: (Double, Double, Double)) -> Color {
                  let luminance = 0.299 * rgb.0 + 0.587 * rgb.1 + 0.114 * rgb.2
                  return luminance > 186 ? .black : .white
              }
          }
