//
//  File.swift
//  kwanduh
//
//  Created by bill donner on 10/27/24.
//

import SwiftUI

let gameTitle = "kwandoo"
let mainFont = "Avenir-Book"
let mainFontSize = 30.0
let playDataURL  = Bundle.main.url(forResource: "playdata.json", withExtension: nil)
let starting_size = 3 // Example size, can be 3 to 8
let cornerradius = 0.0 // something like 8 makes nice rounded corners in main grid
let isDebugModeEnabled: Bool = false
let debugBorderColor: Color = .red
let shouldAssert = true //// External flag to control whether assertions should be enforced
let cloudKitBypass = false
let plainTopicIndex = true
